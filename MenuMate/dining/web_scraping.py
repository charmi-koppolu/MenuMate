
import requests
from bs4 import BeautifulSoup
from datetime import datetime

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