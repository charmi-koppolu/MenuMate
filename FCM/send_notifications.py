from zoneinfo import ZoneInfo
from test import send_push_notification

import requests
from bs4 import BeautifulSoup
from datetime import datetime

from FCM.database_connection import SQLClient

dining_hall_urls = {"Akers": "https://eatatstate.msu.edu/menu/The%20Edge%20at%20Akers/all/",
                    "Brody": "https://eatatstate.msu.edu/menu/Brody%20Square/all/",
                    "Case": "https://eatatstate.msu.edu/menu/South%20Pointe%20at%20Case/all/",
                    "Holden": "https://eatatstate.msu.edu/menu/Holden%20Dining%20Hall/all/",
                    "Holmes": "https://eatatstate.msu.edu/menu/Holmes%20Dining%20Hall/all/",
                    "Landon": "https://eatatstate.msu.edu/menu/Heritage%20Commons%20at%20Landon/all/",
                    "Owen": "https://eatatstate.msu.edu/menu/Thrive%20at%20Owen/",
                    "Shaw": "https://eatatstate.msu.edu/menu/The%20Vista%20at%20Shaw/all/",
                    "Snyder Phillips": "https://eatatstate.msu.edu/menu/The%20Gallery%20at%20Snyder%20Phillips/all/"
                    }

def get_dining_format(dining_hall_name, dining_hall_menu, today):
    dining_hall_info = {'name': dining_hall_name, 'sections': {}, 'menu_items': {}, 'date': today}
    for venue in dining_hall_menu["venues"]:
        section_name = venue["name"]
        section_description = venue["description"]
        dining_hall_info["sections"][section_name] = section_description
        dining_hall_info["menu_items"][section_name] = []
        for item in venue['meals'][0]['items']:
            dining_hall_info["menu_items"][section_name].append(item['name'])
    return dining_hall_info

def get_dining_hall_menu(date=None, meal_filter=None, dining_hall_url=None):

    #dining_hall_url = "https://eatatstate.msu.edu/menu/Brody%20Square/all/"

    if date is None:
        date = datetime.now().strftime("%Y-%m-%d")

    url = f"{dining_hall_url}{date}"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    }

    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')

        menu_data = {
            "date": date,
            "venues": []
        }

        venue_groups = soup.find_all(class_="eas-view-group")

        for venue in venue_groups:
            venue_info = {
                "name": venue.find(class_="venue-title").get_text(strip=True),
                "description": venue.find(class_="venue-description").get_text(strip=True) if venue.find(
                    class_="venue-description") else "",
                "meals": []
            }

            meal_lists = venue.find_all(class_="eas-list")

            for meal in meal_lists:
                meal_time = meal.find(class_="meal-time").get_text(strip=True) if meal.find(
                    class_="meal-time") else "Unknown"


                if meal_filter and meal_time.lower() != meal_filter.lower():
                    continue

                meal_info = {
                    "time": meal_time,
                    "items": []
                }

                menu_items = meal.find_all(class_="menu-item")

                for item in menu_items:
                    item_name = item.find(class_="meal-title").get_text(strip=True) if item.find(
                        class_="meal-title") else "Unknown"

                    dietary = [tag.get_text(strip=True) for tag in item.find_all(class_=["vegetarian", "vegan"])]
                    allergens = [tag.get_text(strip=True) for tag in item.find_all(class_="allergen")]

                    meal_info["items"].append({
                        "name": item_name,
                        "dietary": dietary,
                        "allergens": allergens
                    })

                venue_info["meals"].append(meal_info)

            if venue_info["meals"]:
                menu_data["venues"].append(venue_info)

        return menu_data

    except Exception as e:
        print(f"Error fetching menu: {e}")
        return None

def get_menu_items(dining_hall_name):
    url = dining_hall_urls[dining_hall_name]
    today = datetime.now(ZoneInfo("America/Detroit")).strftime("%Y-%m-%d")
    print(today)
    today_url = url
    print(today_url)
    now = datetime.now()
    hour = now.hour
    minute = now.minute

    if 0 <= hour < 11:
        meal_filter = "Breakfast"
    elif (hour == 11 and minute == 0) or (11 < hour < 15):
        meal_filter = "Lunch"
    elif (hour == 16 and minute >= 30) or (hour == 20 and minute == 0):
        meal_filter = "Dinner"
    else:
        meal_filter = "Dinner"
        #return None

    menu = get_dining_hall_menu(today, meal_filter, today_url)
    print(menu)
    return get_dining_format(dining_hall_name, menu, today)

def get_menu_list(section_menu):
    menu_list = []
    for section in section_menu:
        menu_list.extend(section_menu.get(section))
    return menu_list

def get_dining_hall(name):
    menu_items = get_menu_items(name)
    print(menu_items)
    menu_list = get_menu_list(menu_items["menu_items"])
    return menu_list

def get_users_by_favorites(client, menu_items):
    """
    Get all users who have favorited any item in menu_items.
    Returns: list of dicts with {uid, fname, fcm_token, uname}
    """
    if not menu_items:
        return []

    for i in range(len(menu_items)):
        menu_items[i] = menu_items[i].lower()
    placeholders = ",".join(["%s"] * len(menu_items))
    query = f"""
        SELECT u.uid, u.uname, u.fcm_token, f.fname
        FROM dining_favorites f
        JOIN dining_users u ON f.user_id = u.uid
        WHERE f.fname IN ({placeholders})
    """
    return client.execute(query, menu_items)

def get_tokens_list(users_who_favorited):
    tokens = []
    for entry in users_who_favorited:
        tokens.append(entry["fcm_token"])
    return tokens

def send_notifs_from_dh():
    dining_halls = ['Akers', 'Brody', 'Case', 'Holden', 'Holmes', 'Landon', 'Shaw', 'Snyder Phillips']
    #dining_halls = ['Case']
    sql_client = SQLClient("localhost", "root", "password", "dining_information")
    for dining_hall in dining_halls:
        menu = get_dining_hall(dining_hall)
        #print(menu["menu_items"])
        #print(menu)
        users_who_favorited = get_users_by_favorites(sql_client, menu)
        print(users_who_favorited)
        tokens = get_tokens_list(users_who_favorited)
        print(tokens)
        sent = send_push_notification(tokens, dining_hall, "food item detected")
        print(sent)
        print("####################################################################")


send_notifs_from_dh()