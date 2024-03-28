import copy
import json
from telegram import InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import Updater, CommandHandler, CallbackQueryHandler
from ChatGPT_HKBU import HKBU_ChatGPT
from util.database import (get_user_context, update_user_context, get_random_system_recipe, get_system_recipe_type, get_random_recipe_from_type, get_random_recipe_list_from_type, get_user_recipe, get_one_user_recipe)


chatgpt = HKBU_ChatGPT()

def send_system_command_to_chatgpt(system_command, user_id):
    global chatgpt
    system_message = {'role': 'user', 'content': system_command}

    # get history context from postgreSQL
    current_context = get_user_context(user_id)

    current_context_update = copy.deepcopy(current_context)

    current_context_update.append(system_message)

    # submit to chatgpt
    reply_message = chatgpt.submit_with_context(system_command, current_context)

    current_context_update.append(reply_message)
    update_context = current_context_update
    update_context = json.dumps(update_context)
    # update user's context with reply in database
    update_user_context(user_id, update_context)
    return reply_message

def add_system_information_to_chatgpt_context(system_information, user_id):
    system_message = {'role': 'assistant', 'content': system_information}

    # get history context from postgreSQL
    current_context = get_user_context(user_id)

    current_context_update = copy.deepcopy(current_context)

    current_context_update.append(system_message)

    update_context = current_context_update
    update_context = json.dumps(update_context)
    # update user's context with reply in database
    update_user_context(user_id, update_context)

def main_menu(update, context):
    query = update.callback_query
    query.answer()
    keyboard = [[InlineKeyboardButton("🥧 Recipe Recommendations", callback_data='main_rp')],
                [InlineKeyboardButton("🌏 Recipe Browsing", callback_data='main_recipe_browse')],
                [InlineKeyboardButton("🧑‍🍳 User Recipe Browsing", callback_data='user_recipe_browse')],
                [InlineKeyboardButton("⬆️ Upload Recipe", callback_data='user_upload_start')]]

    reply_markup = InlineKeyboardMarkup(keyboard)
    query.edit_message_text(" 😎 <b>Hello!</b> \n     I'm your recipe and nutritional analysis assistant! \n      You can choose from the options below or ask me directly about recipes and nutritional analyses. \n     How can I help you ?", reply_markup=reply_markup, parse_mode='HTML')

def recommendations_button(update, context):
    query = update.callback_query
    query.answer()
    keyboard = [[InlineKeyboardButton("Today's Random Recommendations", callback_data='today_rr')],
                [InlineKeyboardButton("Recommendations by type", callback_data='recommendation_type')],
                [InlineKeyboardButton("Back to menu🔙", callback_data='return_to_start_menu')]]

    reply_markup = InlineKeyboardMarkup(keyboard)
    query.edit_message_text(text="Please select the type of recommendation.", reply_markup=reply_markup, parse_mode='HTML')

def random_recommendation_button(update, context):
    user_id = update.effective_chat.id
    query = update.callback_query
    query.answer()
    keyboard = [[InlineKeyboardButton("Nutritional Advice", callback_data='nutrition_advice')],
                [InlineKeyboardButton("Back🔙", callback_data='main_rp')]]

    reply_markup = InlineKeyboardMarkup(keyboard)

    # get random recipe
    recipe_name = get_random_system_recipe()
    if recipe_name:
        recipe_name = recipe_name[1]
        system_command = f'Please recommend a dish randomly selected by the system, the name of this dish is {recipe_name}, please return it strictly in the following json format: {{"dish_name": {recipe_name}, "reason": the reason for recommending {recipe_name}, "steps": a brief description of the process of making {recipe_name}}}'
        # system_command = f' Please recommend a dish randomly selected by the system, the name of which is {recipe_name}, and return it in the following strict HTML format, in which the detailed descriptions of ingredients, steps, and procedures can be expanded, but please format it typographically: <b>Name of the dish<b> <b>Reason for recommendation<b>: the reason for the recommendation  <b>Preparation<b> Steps 1. <b>Prepare ingredients<b>: - Ingredients 1 - Ingredient 2 and so on. 2. <b>Step 1<b>: - Step 1 Description. - Step 1 description. And so on. 3. <b>Step 2<b>: - Step 2 Description. - Step 2 description.'
        # request chatgpt
        reply_message = send_system_command_to_chatgpt(system_command, user_id)
        # print(reply_message['content'])
        reply_json = reply_message['content']
        reply_json = json.loads(reply_json)
        reply_reason = reply_json['reason']
        reply_steps = reply_json['steps']
        format_reply_message = f' 🏷️ <strong>{recipe_name}</strong> \n  {reply_reason}\n<strong> 🏷️ Directions</strong> \n  {reply_steps}'
        # print(reply_json)
        # print(reply_json['reason'])
        # reply to user
        query.edit_message_text(text=format_reply_message, reply_markup=reply_markup, parse_mode='HTML')
    else:
        query.edit_message_text(text="recommendation error, please try again.", reply_markup=reply_markup)

def nutritional_analysis_button(update, context):
    user_id = update.effective_chat.id
    query = update.callback_query
    query.answer()

    system_command = f'Please analyse the proposed nutritional analysis of the last dish mentioned above. Please return it strictly in the following json format, replace each value with your generated content, Only one text value per value position, do not use grouped values: {{"target_group": analysis that what is the advice of different target people from a health and nutritional point of view, "analysis": a brief nutritional analysis of the dish.}}'

    # request chatgpt
    reply_message = send_system_command_to_chatgpt(system_command, user_id)
    # print(reply_message['content'])
    reply_json = reply_message['content']
    reply_json = json.loads(reply_json)
    target_group = reply_json['target_group']
    reply_analysis = reply_json['analysis']
    format_reply_message = f'<strong> 🏷️ Nutritional Analysis</strong> \n  😋 Target Group:<i>{target_group}</i>\n\n  🍽️ {reply_analysis}'
    # print(reply_json)
    # reply to user
    context.bot.send_message(chat_id=update.effective_chat.id, text=format_reply_message, parse_mode='HTML')

def recommendation_by_type_button(update, context):
    user_id = update.effective_chat.id
    query = update.callback_query
    query.answer()

    # get recipe type
    recipe_type_list = get_system_recipe_type()
    if recipe_type_list:
        keyboard = []
        for i in range(0, len(recipe_type_list), 3):
            slice = recipe_type_list[i:i + 3]
            row = [InlineKeyboardButton(f'{recipe_type[0]}. {recipe_type[1]}',
                                        callback_data=f"recipe_type_{recipe_type[0]}") for recipe_type in slice]
            keyboard.append(row)
        # keyboard = [
        #     [InlineKeyboardButton(f'{recipe_type[0]}. {recipe_type[1]}', callback_data=f"recipe_type_{recipe_type[0]}") for recipe_type in recipe_type_list]]

    reply_markup = InlineKeyboardMarkup(keyboard)

    format_reply_message = f'<strong> Selection </strong> \n   Please select the recipe type you want.😊'
    # print(reply_json)
    # reply to user
    query.edit_message_text(text=format_reply_message, reply_markup=reply_markup, parse_mode='HTML')

def select_type_recommendation_button(update, context):
    user_id = update.effective_chat.id
    query = update.callback_query
    query.answer()
    callback_data = query.data
    if callback_data.startswith("recipe_type_"):
        recipe_type_number = callback_data.split("_")[2]
        keyboard = [[InlineKeyboardButton("Nutritional Advice", callback_data='nutrition_advice')],
                    [InlineKeyboardButton("Back🔙", callback_data='main_rp')]]

        reply_markup = InlineKeyboardMarkup(keyboard)

        # get random recipe
        recipe_name = get_random_recipe_from_type(recipe_type_number)
        if recipe_name:
            recipe_name = recipe_name[1]
            system_command = f'Please recommend a dish randomly selected by the system, the name of this dish is {recipe_name}, please return it strictly in the following json format: {{"dish_name": {recipe_name}, "reason": the reason for recommending {recipe_name}, "steps": a brief description of the process of making {recipe_name}}}'
            # request chatgpt
            reply_message = send_system_command_to_chatgpt(system_command, user_id)
            # print(reply_message['content'])
            reply_json = reply_message['content']
            reply_json = json.loads(reply_json)
            reply_reason = reply_json['reason']
            reply_steps = reply_json['steps']
            format_reply_message = f' 🏷️ <strong>{recipe_name}</strong> \n  {reply_reason}\n<strong> 🏷️ Directions</strong> \n  {reply_steps}'
            # reply to user
            query.edit_message_text(text=format_reply_message, reply_markup=reply_markup, parse_mode='HTML')
        else:
            query.edit_message_text(text="recommendation error, please try again.", reply_markup=reply_markup)

def browse_by_type_button(update, context):
    user_id = update.effective_chat.id
    query = update.callback_query
    query.answer()

    # get recipe type
    recipe_type_list = get_system_recipe_type()
    # print(recipe_type_list)
    if recipe_type_list:
        keyboard = []
        for i in range(0, len(recipe_type_list), 3):
            slice = recipe_type_list[i:i + 3]
            row = [InlineKeyboardButton(f'{recipe_type[0]}. {recipe_type[1]}',
                                        callback_data=f"recipe_browse_type_{recipe_type[0]}") for recipe_type in slice]
            keyboard.append(row)
        # keyboard = [
        #     [InlineKeyboardButton(f'{recipe_type[0]}. {recipe_type[1]}', callback_data=f"recipe_browse_type_{recipe_type[0]}") for recipe_type in recipe_type_list]]

    reply_markup = InlineKeyboardMarkup(keyboard)

    format_reply_message = f'<strong> Selection </strong> \n   Please select the recipe type you want to browse.😊'
    # reply to user
    query.edit_message_text(text=format_reply_message, reply_markup=reply_markup, parse_mode='HTML')

def browse_by_type_select_button(update, context):
    user_id = update.effective_chat.id
    query = update.callback_query
    query.answer()
    callback_data = query.data

    if callback_data.startswith("recipe_browse_type_"):
        recipe_type_number = callback_data.split("_")[3]
        # print(callback_data.split("_"))
        # get random recipe list
        recipe_list = get_random_recipe_list_from_type(recipe_type_number)
        if recipe_list:
            keyboard = []
            for i in range(0, len(recipe_list), 3):
                slice = recipe_list[i:i + 3]
                row = [InlineKeyboardButton(f'{recipe_item[0]}',
                                            callback_data=f"rbo_{recipe_item[0]}_{recipe_item[1]}") for recipe_item in slice]
                keyboard.append(row)
            row = [InlineKeyboardButton(f'Next Group',
                                        callback_data=f"{callback_data}")]
            keyboard.append(row)
            # keyboard = [
            #     [InlineKeyboardButton(f'{recipe_item[0]}', callback_data=f"recipe_browse_one_{recipe_item[0]}_{recipe_item[1]}") for recipe_item in recipe_list]]

        reply_markup = InlineKeyboardMarkup(keyboard)

        format_reply_message = f'<strong> Selection </strong> \n   😊 Please select one recipe you like from this type. \n'
        for recipe_item in recipe_list:
            recipe_text = f'    - {recipe_item[0]}. {recipe_item[1]} \n'
            format_reply_message = format_reply_message + recipe_text
        # print(format_reply_message)
        # reply to user
        query.edit_message_text(text=format_reply_message, reply_markup=reply_markup, parse_mode='HTML')

def browse_one_recipe_button(update, context):
    user_id = update.effective_chat.id
    query = update.callback_query
    query.answer()
    callback_data = query.data
    if callback_data.startswith("rbo_"):
        recipe_type_number = callback_data.split("_")[1]
        keyboard = [[InlineKeyboardButton("Nutritional Advice", callback_data='nutrition_advice')],
                    [InlineKeyboardButton("Back🔙", callback_data='return_to_start_menu')]]

        reply_markup = InlineKeyboardMarkup(keyboard)

        # get recipe name
        recipe_name = callback_data.split("_")[2]
        if recipe_name:
            system_command = f'Please recommend a dish randomly selected by the system, the name of this dish is {recipe_name}, please return it strictly in the following json format: {{"dish_name": {recipe_name}, "reason": the reason for recommending {recipe_name}, "steps": a brief description of the process of making {recipe_name}}}'
            # request chatgpt
            reply_message = send_system_command_to_chatgpt(system_command, user_id)
            # print(reply_message['content'])
            reply_json = reply_message['content']
            reply_json = json.loads(reply_json)
            reply_reason = reply_json['reason']
            reply_steps = reply_json['steps']
            format_reply_message = f' 🏷️ <strong>{recipe_name}</strong> \n  {reply_reason}\n<strong> 🏷️ Directions</strong> \n  {reply_steps}'
            # reply to user
            query.edit_message_text(text=format_reply_message, reply_markup=reply_markup, parse_mode='HTML')
        else:
            query.edit_message_text(text="recommendation error, please try again.", reply_markup=reply_markup)

def user_upload_button(update, context):
    user_id = update.effective_chat.id
    query = update.callback_query
    query.answer()

    context.bot.send_message(chat_id=update.effective_chat.id, text='Hello, please enter the name of your recipe.')
    return "user_recipe_name"

def browse_user_recipe_button(update, context):
    user_id = update.effective_chat.id
    query = update.callback_query
    query.answer()
    callback_data = query.data
    page = 1
    items_per_page = 8
    user_recipes_list = get_user_recipe(page, items_per_page)
    if user_recipes_list:
        keyboard = []
        for i in range(0, len(user_recipes_list), 3):
            slice = user_recipes_list[i:i + 3]
            row = [InlineKeyboardButton(f'{recipe_item[0]}',
                                        callback_data=f"urbo_{recipe_item[0]}_{recipe_item[1]}") for recipe_item in slice]
            keyboard.append(row)
        # keyboard = [
        #     [InlineKeyboardButton(f'{recipe_item[0]}',
        #                           callback_data=f"user_recipe_browse_one_{recipe_item[0]}_{recipe_item[1]}") for recipe_item in user_recipes_list]]
        page_keyboard = [InlineKeyboardButton("next", callback_data=f'user_recipe_next_{page + 1}')]
        keyboard.append(page_keyboard)
        reply_markup = InlineKeyboardMarkup(keyboard)
        format_reply_message = f'<strong> Selection </strong> \n   😊 Please select one recipe you like from this page. \n'
        for recipe_item in user_recipes_list:
            recipe_text = f'    - {recipe_item[0]}. {recipe_item[1]} \n'
            format_reply_message = format_reply_message + recipe_text
        # print(format_reply_message)
        # reply to user
        query.edit_message_text(text=format_reply_message, reply_markup=reply_markup, parse_mode='HTML')

def browse_user_recipe_page_button(update, context):
    user_id = update.effective_chat.id
    query = update.callback_query
    query.answer()
    callback_data = query.data
    page = int(callback_data.split("_")[3])
    items_per_page = 8
    user_recipes_list = get_user_recipe(page, items_per_page)
    if user_recipes_list:
        keyboard = []
        for i in range(0, len(user_recipes_list), 3):
            slice = user_recipes_list[i:i + 3]
            row = [InlineKeyboardButton(f'{recipe_item[0]}',
                                        callback_data=f"urbo_{recipe_item[0]}_{recipe_item[1]}") for
                   recipe_item in slice]
            keyboard.append(row)
        # keyboard = [
        #     [InlineKeyboardButton(f'{recipe_item[0]}',
        #                           callback_data=f"user_recipe_browse_one_{recipe_item[0]}_{recipe_item[1]}") for recipe_item in user_recipes_list]]
        page_keyboard = []
        if(page > 1):
            page_keyboard.append(InlineKeyboardButton("prev", callback_data=f'user_recipe_prev_{page - 1}'))
        page_keyboard.append(InlineKeyboardButton("next", callback_data=f'user_recipe_next_{page + 1}'))
        keyboard.append(page_keyboard)
        reply_markup = InlineKeyboardMarkup(keyboard)
        format_reply_message = f'<strong> Selection </strong> \n   😊 Please select one recipe you like from this page. \n'
        for recipe_item in user_recipes_list:
            recipe_text = f'    - {recipe_item[0]}. {recipe_item[1]} \n'
            format_reply_message = format_reply_message + recipe_text
        # print(format_reply_message)
        # reply to user
        query.edit_message_text(text=format_reply_message, reply_markup=reply_markup, parse_mode='HTML')

def browse_one_user_recipe_button(update, context):
    user_id = update.effective_chat.id
    query = update.callback_query
    query.answer()
    callback_data = query.data
    if callback_data.startswith("urbo_"):
        recipe_number = callback_data.split("_")[1]
        user_recipe = get_one_user_recipe(recipe_number)
        if user_recipe:
            user_recipe_name = user_recipe[1]
            user_recipe_directions = user_recipe[2]
            user_recipe_rating = user_recipe[3]
            user_recipe_link = user_recipe[4]
            format_reply_message = f'<strong>{user_recipe_name}</strong> \n<strong> 🏷️ Directions</strong> \n  {user_recipe_directions} \n \n<strong> 🔗 Reference Link</strong> \n {user_recipe_link}'
            message_head = 'Here is the user_recipe information founded in the database:'
            context_message = message_head + format_reply_message
            add_system_information_to_chatgpt_context(context_message, user_id)
            keyboard = [[InlineKeyboardButton("Nutritional Advice", callback_data='nutrition_advice')],
                        [InlineKeyboardButton("Back🔙", callback_data='return_to_start_menu')]]

            reply_markup = InlineKeyboardMarkup(keyboard)

            query.edit_message_text(text=format_reply_message, reply_markup=reply_markup, parse_mode='HTML')
        else:
            keyboard = [
                        [InlineKeyboardButton("Back🔙", callback_data='main_rp')]]

            reply_markup = InlineKeyboardMarkup(keyboard)
            query.edit_message_text(text="browse error, please try again.", reply_markup=reply_markup)

