import random
import psycopg2
import configparser
import json
from datetime import datetime, timedelta, timezone


def get_db_connection():
    config = configparser.ConfigParser()
    config.read('config.ini')
    return psycopg2.connect(
        host=config['AZURE_DATABASE']['HOST'],
        user=config['AZURE_DATABASE']['USER'],
        password=config['AZURE_DATABASE']['PASSWORD'],
        port=config['AZURE_DATABASE']['PORT'],
        dbname=config['AZURE_DATABASE']['DBNAME']
    )


def get_user_context(user_id):
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT context, last_update FROM chat_history WHERE user_id = %s;
            """, (user_id,))
            row = cur.fetchone()

            if row:
                context, last_update = row
                # if the context is not older than 20 minutes, return history context
                if datetime.now(timezone.utc) - last_update <= timedelta(minutes=20):
                    return json.loads(context)
                else:
                    # clear history context
                    cur.execute("""
                     UPDATE chat_history SET context = %s, last_update = %s WHERE user_id = %s;
                    """, ("", datetime.now(), user_id))
                    return [{"role": "user", "content": " "}]
            else:
                return [{"role": "user", "content": " "}]


def update_user_context(user_id, new_context):
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            # Check if the user already has a context
            cur.execute("""
                SELECT 1 FROM chat_history WHERE user_id = %s;
            """, (user_id,))
            exists = cur.fetchone() is not None

            if exists:
                # Update existing context
                cur.execute("""
                    UPDATE chat_history SET context = %s, last_update = %s WHERE user_id = %s;
                """, (new_context, datetime.now(), user_id))
            else:
                # Insert new context
                cur.execute("""
                    INSERT INTO chat_history (user_id, context, last_update) VALUES (%s, %s, %s);
                """, (user_id, new_context, datetime.now()))


def get_random_system_recipe():
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT id FROM system_recipe;
                """)
                recipe_ids = cur.fetchall()
                print(recipe_ids)

                if recipe_ids:
                    random_id = random.choice(recipe_ids)[0]
                    cur.execute("SELECT * FROM system_recipe WHERE id = %s", (random_id,))
                    recipe_info = cur.fetchone()
                    return recipe_info
                else:
                    return False
    except psycopg2.Error as e:
        print(f"Database error: {e}")


def get_system_recipe_type():
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT * FROM recipe_type;
                """)
                recipe_type = cur.fetchall()
                print(recipe_type)

                if recipe_type:
                    return recipe_type
                else:
                    return False
    except psycopg2.Error as e:
        print(f"Database error: {e}")


def get_random_recipe_list_from_type(type_id):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT * FROM system_recipe where type = %s;
                """, (type_id,))
                recipe_list = cur.fetchall()
                print(recipe_list)

                if recipe_list:
                    selected_recipes = random.sample(recipe_list, 9)
                    return selected_recipes
                else:
                    return False
    except psycopg2.Error as e:
        print(f"Database error: {e}")


def get_random_recipe_from_type(type_id):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT * FROM system_recipe where type = %s;
                """, (type_id,))
                recipe_list = cur.fetchall()
                print(recipe_list)

                if recipe_list:
                    selected_recipe = random.choice(recipe_list)
                    return selected_recipe
                else:
                    return False
    except psycopg2.Error as e:
        print(f"Database error: {e}")


def upload_user_recipe(recipe_name, directions, link, user_id):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                sql = "INSERT INTO user_recipe (recipe_name, directions, link, rating, user_id) VALUES (%s, %s, %s, 5, %s)"
                cur.execute(sql, (recipe_name, directions, link, user_id))

                if cur.rowcount:
                    return True
                else:
                    return False
    except psycopg2.Error as e:
        print(f"Database error: {e}")


def get_user_recipe(page, items_per_page):
    offset = (int(page) - 1) * items_per_page
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT * FROM user_recipe ORDER BY id LIMIT %s OFFSET %s;
                """, (items_per_page, offset))
                recipe_list = cur.fetchall()
                print(recipe_list)

                if recipe_list:
                    return recipe_list
                else:
                    return False
    except psycopg2.Error as e:
        print(f"Database error: {e}")


def get_one_user_recipe(recipe_id):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT * FROM user_recipe where id = %s;
                """, (recipe_id,))
                recipe_item = cur.fetchone()
                print(recipe_item)

                if recipe_item:
                    return recipe_item
                else:
                    return False
    except psycopg2.Error as e:
        print(f"Database error: {e}")
