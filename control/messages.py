import json

from telegram import InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import ConversationHandler

from control import callbacks
from util import database

def user_upload_recipe_name(update, context):
    user_id = update.effective_chat.id
    name = update.message.text
    if name:
        context.user_data['name'] = name  # store recipe name
        update.message.reply_text("Thanks, now please input the exact directions to make it.")
        return "user_recipe_directions"
    else:
        return "user_recipe_name"

def user_upload_recipe_directions(update, context):
    user_id = update.effective_chat.id
    directions = update.message.text
    if directions:
        context.user_data['directions'] = directions  # store recipe name
        update.message.reply_text("Thank you, if there is a relevant link, now enter the relevant link.")
        return "user_recipe_link"
    else:
        return "user_recipe_directions"

def user_upload_recipe_link(update, context):
    user_id = update.effective_chat.id
    link = update.message.text
    if not link:
        link = "null"

    name = context.user_data['name']
    directions = context.user_data['directions']
    system_command = f'Please help me to verify if the content entered by the following user is related to cooking and if there is any harmful information, if the content is related to cooking and there is no harmful information and there is no harmful link(normal link is accepted) it will return true, if the content is not related or contains harmful information or harmful link it will return false, please strictly follow the following json format to return:{{"verification": true of false}}, The content entered by this user is. "recipe": {name}, "directions": {directions}, "link":{link}.'
    # request chatgpt to verify
    reply_message = callbacks.send_system_command_to_chatgpt(system_command, user_id)
    print(reply_message['content'])
    reply_json = reply_message['content']
    reply_json = json.loads(reply_json)
    reply_verification = reply_json['verification']
    if reply_verification == True:
        upload = database.upload_user_recipe(name, directions, link, user_id)
        if upload:
            format_reply_message = f' 🎉 <strong>Congratulations</strong> \n  Your recipe has been uploaded successfully.'
            update.message.reply_text(text=format_reply_message, parse_mode='HTML')
        else:
            format_reply_message = f' <strong>Sorry</strong> \n  Please try again.'
            update.message.reply_text(text=format_reply_message, parse_mode='HTML')
    else:
        format_reply_message = f' <strong>Sorry</strong> \n  Your input information is not verified.'
        update.message.reply_text(text=format_reply_message, parse_mode='HTML')
    return ConversationHandler.END

def cancel(update, context):
    update.message.reply_text("Upload conversation cancelled")
    return ConversationHandler.END
