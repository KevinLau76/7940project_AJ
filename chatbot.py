import json
import re
from telegram import Update
from telegram.ext import (Updater, CommandHandler, MessageHandler, Filters, CallbackContext, CallbackQueryHandler,
                          ConversationHandler)
from ChatGPT_HKBU import HKBU_ChatGPT
import configparser
import logging
import copy
from control import commands, callbacks, messages
from util.database import (get_user_context, update_user_context)


def main():
    # Load your token and create an Updater for your Bot
    config = configparser.ConfigParser()
    config.read('config.ini')
    updater = Updater(token=(config['TELEGRAM']['ACCESS_TOKEN']), use_context=True)
    dispatcher = updater.dispatcher

    logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                        level=logging.INFO)

    dispatcher.add_handler(CommandHandler("help", help_command))
    dispatcher.add_handler(CommandHandler("hello", hello))
    # main menu handler
    dispatcher.add_handler(CommandHandler("start", commands.main_menu))

    # recommendations menu handler
    dispatcher.add_handler(CallbackQueryHandler(callbacks.recommendations_button, pattern='^main_rp$'))
    dispatcher.add_handler(CallbackQueryHandler(callbacks.browse_by_type_button, pattern='^main_recipe_browse$'))
    dispatcher.add_handler(CallbackQueryHandler(callbacks.random_recommendation_button, pattern='^today_rr$'))
    dispatcher.add_handler(CallbackQueryHandler(callbacks.nutritional_analysis_button, pattern='^nutrition_advice$'))
    dispatcher.add_handler(CallbackQueryHandler(callbacks.main_menu, pattern='^return_to_start_menu$'))
    dispatcher.add_handler(
        CallbackQueryHandler(callbacks.recommendation_by_type_button, pattern='^recommendation_type$'))
    dispatcher.add_handler(
        CallbackQueryHandler(callbacks.select_type_recommendation_button, pattern=re.compile(r'^recipe_type_.+$')))
    dispatcher.add_handler(
        CallbackQueryHandler(callbacks.browse_by_type_select_button, pattern=re.compile(r'^recipe_browse_type_.+$')))
    dispatcher.add_handler(
        CallbackQueryHandler(callbacks.browse_one_recipe_button, pattern=re.compile(r'^rbo_[^_]+_[^_]+$')))

    # user recipe browse handler
    dispatcher.add_handler(CallbackQueryHandler(callbacks.browse_user_recipe_button, pattern='^user_recipe_browse$'))
    dispatcher.add_handler(CallbackQueryHandler(callbacks.browse_user_recipe_page_button,
                                                pattern=re.compile(r'^user_recipe_(prev|next)_\d+$')))
    dispatcher.add_handler(
        CallbackQueryHandler(callbacks.browse_one_user_recipe_button, pattern=re.compile(r'^urbo_[^_]+_[^_]+$')))

    # user upload handler
    conv_handler = ConversationHandler(
        entry_points=[CallbackQueryHandler(callbacks.user_upload_button, pattern='^user_upload_start$')],
        states={
            "user_recipe_name": [MessageHandler(Filters.text & ~Filters.command, messages.user_upload_recipe_name)],
            "user_recipe_directions": [
                MessageHandler(Filters.text & ~Filters.command, messages.user_upload_recipe_directions)],
            "user_recipe_link": [MessageHandler(Filters.text & ~Filters.command, messages.user_upload_recipe_link)],
        },
        fallbacks=[CommandHandler('cancel', messages.cancel)]
    )
    dispatcher.add_handler(conv_handler)
    # dispatcher for chatgpt
    global chatgpt
    chatgpt = HKBU_ChatGPT()
    chatgpt_handler = MessageHandler(Filters.text & (~Filters.command), chatgpt_echo_with_context)
    dispatcher.add_handler(chatgpt_handler)

    # To start the bot:
    updater.start_polling()
    updater.idle()


def echo(update, context):
    reply_message = update.message.text.upper()
    logging.info("Update: " + str(update))
    logging.info("context: " + str(context))
    context.bot.send_message(chat_id=update.effective_chat.id, text=reply_message)


def hello(update, context):
    reply_message = "Good day, " + update.message.text + "!"
    logging.info("Update: " + str(update))
    logging.info("context: " + str(context))
    context.bot.send_message(chat_id=update.effective_chat.id, text=reply_message)


def help_command(update: Update, context: CallbackContext) -> None:
    """Send a message when the command /help is issued."""
    update.message.reply_text('Helping you helping you.')


def equiped_chatgpt(update, context):
    global chatgpt
    reply_message = chatgpt.submit(update.message.text)
    logging.info("Update: " + str(update))
    logging.info("context: " + str(context))
    context.bot.send_message(chat_id=update.effective_chat.id, text=reply_message)


def chatgpt_echo_with_context(update, context):
    global chatgpt
    user_message_head = 'You are currently a Recipe and Nutritional Analysis Assistant,you need to reply user about the recipe above in your conversation context. please reply with advice based on the content of the user enquiry,  The content of the user enquiry is:'
    user_content = user_message_head + update.message.text
    user_message = {'role': 'user', 'content': user_content}
    user_id = update.effective_chat.id

    # get history context from postgreSQL
    current_context = get_user_context(user_id)

    current_context_update = copy.deepcopy(current_context)

    # add user context
    current_context_update.append(user_message)

    # submit to chatgpt
    reply_message = chatgpt.submit_with_context(user_content, current_context)
    # reply to user
    context.bot.send_message(chat_id=update.effective_chat.id, text=reply_message['content'])

    current_context_update.append(reply_message)
    update_context = current_context_update
    update_context = json.dumps(update_context)
    # update user's context with reply in database
    update_user_context(user_id, update_context)


if __name__ == '__main__':
    main()
