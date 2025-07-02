from datetime import datetime, timedelta
import jwt
from django.http import JsonResponse
import json

expiry_time = 3600
secret_key = "354585d63c57b6b81e1f4ed1e3095f03ce0f521b81b525f12c22693c3a862a22"

def create_jwt(user_id):
    payload = {
        'user_id': str(user_id),
        'exp': datetime.utcnow() + timedelta(seconds=expiry_time),
        'iat': datetime.utcnow()
    }
    token = jwt.encode(payload, secret_key, algorithm="HS256")
    return token

def decode_jwt(token):
    try:
        payload = jwt.decode(token, secret_key, algorithms="HS256")
        return payload
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None

from functools import wraps

def jwt_required(view_func):
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):
        print("hi")
        auth_header = request.headers.get('Authorization')

        if not auth_header:
            return JsonResponse({"status": "Error", "message": "Missing Authorization header"}, status=401)

        try:
            token = auth_header.split(" ")[1]  # Expecting 'Bearer <token>'
        except IndexError:
            return JsonResponse({"status": "Error", "message" : "Invalid jwt"}, status=403)
        payload = decode_jwt(token)
        if not payload:
            return JsonResponse({"status": "Error", "message": "Invalid or expired token"}, status=401)
        print(payload)
        request.user_id = payload['user_id']  # Add user_id to request object
        return view_func(request, *args, **kwargs)

    return _wrapped_view