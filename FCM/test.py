import firebase_admin
from firebase_admin import messaging, credentials

cred = credentials.Certificate("/Users/kgsko/Documents/MenuMate/FCM/msu-menumate-firebase-adminsdk-fbsvc-9a7c068771.json")
firebase_admin.initialize_app(cred)

def send_push_notification(tokens, title, body, data=None):
    if not tokens:
        return {"success": 0, "failure": 0, "errors": []}

    message = messaging.MulticastMessage(
        notification=messaging.Notification(title=title, body=body),
        data=data or {},
        tokens=tokens,
    )

    response = messaging.send_each_for_multicast(message)
    return {
        "success": response.success_count,
        "failure": response.failure_count,
        "errors": [resp.exception for resp in response.responses if not resp.success],
    }

# token = ["f-DBHabLTJm_w7r0MAH1ud:APA91bFPGApbMJ7iSwHyiJENzn5HUiqFxJWPjf7_KxLNmxZ-t_h4jwCjcnhYJAl7rFxLOPR7yDf3F11l8oOwat0aK8eWDjStQekEhq-LJYdmdEEwOGw9OfY"]
#
# print(send_push_notification(token, "MenuMate ", "Favorite menu item detected."))