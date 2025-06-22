from twilio.rest import Client

# Your Twilio credentials from https://www.twilio.com/console
account_sid = 'your_account_sid'
auth_token = 'your_auth_token'

client = Client(account_sid, auth_token)

# Send SMS
message = client.messages.create(
    body="🔔 This is your SMS notification!",
    from_='+971544462998',  # Twilio phone number
    to='+971543319445'     # Your phone number
)

print("Message sent! SID:", message.sid)

