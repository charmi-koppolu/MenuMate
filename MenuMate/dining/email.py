import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from django.conf import settings

sender = getattr(settings, "SENDER_EMAIL")
password = getattr(settings, "PASSWORD")

def send_email(receiver_email, message_body, subject):
    msg = MIMEMultipart()
    msg['From'] = sender
    msg['To'] = receiver_email
    msg['Subject'] = subject

    msg.attach(MIMEText(message_body, 'plain'))

    try:
        s = smtplib.SMTP('smtp.gmail.com', 587)
        s.starttls()
        s.login(sender, password)
        s.sendmail(sender, receiver_email, msg.as_string())
        s.quit()
        return True
    except Exception as e:
        print(f"Email sending failed: {e}")
        return False

