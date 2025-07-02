from .models import *
import json
from datetime import datetime
from .web_scraping import *
from .dining_information import *
from zoneinfo import ZoneInfo

def update_user_info(request, uid):
    data = json.loads(request.body)
    username = data.get("username")
    password = data.get("password")
    fcm_token = data.get("fcm_token")
    email = data.get("email")
    age = data.get("age")
    user = Users.objects.get(uid=uid)

    if username is not None:
        user.uname = username
    if password is not None:
        user.password = password
    if fcm_token is not None:
        user.fcm_token = fcm_token
    if email is not None:
        user.email = email
    if age is not None:
        user.age = age

    user.save()

    return user

dining_hall_urls = {"Akers": "https://eatatstate.msu.edu/menu/The%20Edge%20at%20Akers/all/",
                    "Brody": "https://eatatstate.msu.edu/menu/Brody%20Square/all/",
                    "Case": "https://eatatstate.msu.edu/menu/South%20Pointe%20at%20Case/all/",
                    "Holden": "https://eatatstate.msu.edu/menu/Holden%20Dining%20Hall/all/",
                    "Holmes": "https://eatatstate.msu.edu/menu/Holmes%20Dining%20Hall/all/",
                    "Landon": "https://eatatstate.msu.edu/menu/Heritage%20Commons%20at%20Landon/all/",
                    "Owen": "https://eatatstate.msu.edu/menu/Thrive%20at%20Owen",
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

def get_menu_items(dining_hall_name):
    url = dining_hall_urls[dining_hall_name]
    today = datetime.now(ZoneInfo("America/Detroit")).strftime("%Y-%m-%d")
    print(today)
    today_url = url
    print(today_url)
    now = datetime.now()
    hour = now.hour
    minute = now.minute

    if 7 <= hour < 11:
        meal_filter = "Breakfast"
    elif (hour == 11 and minute == 0) or (11 < hour < 15):
        meal_filter = "Lunch"
    elif (hour == 16 and minute >= 30) or (17 <= hour < 21) or (hour == 21 and minute == 0):
        meal_filter = "Dinner"
    else:
        #return {}
        meal_filter = "Dinner"
        pass

    menu = get_dining_hall_menu(today, meal_filter, today_url)
    print(menu)
    return get_dining_format(dining_hall_name, menu, today)


