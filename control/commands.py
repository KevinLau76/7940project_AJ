from telegram import InlineKeyboardButton, InlineKeyboardMarkup
from control import callbacks
def main_menu(update, context):
    keyboard = [[InlineKeyboardButton("🥧 Recipe Recommendations", callback_data='main_rp')],
                [InlineKeyboardButton("🌏 Recipe Browsing", callback_data='main_recipe_browse')],
                [InlineKeyboardButton("🧑‍🍳 User Recipe Browsing", callback_data='user_recipe_browse')],
                [InlineKeyboardButton("⬆️ Upload Recipe", callback_data='user_upload_start')]]

    reply_markup = InlineKeyboardMarkup(keyboard)
    update.message.reply_text(" 😎 <b>Hello!</b> \n     I'm your recipe and nutritional analysis assistant! \n      You can choose from the options below or ask me directly about recipes and nutritional analyses. \n     How can I help you ?", reply_markup=reply_markup, parse_mode='HTML')