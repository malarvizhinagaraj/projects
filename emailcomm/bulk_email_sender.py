import smtplib, ssl
import csv
from email.message import EmailMessage

def read_contacts(filename):
    with open(filename, newline='', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        return [row for row in reader]

def read_template(filename):
    with open(filename, 'r', encoding='utf-8') as file:
        return file.read()

def send_email(to_email, subject, body, sender_email, password):
    msg = EmailMessage()
    msg['From'] = sender_email
    msg['To'] = to_email
    msg['Subject'] = subject
    msg.set_content(body)

    context = ssl.create_default_context()
    with smtplib.SMTP_SSL('smtp.gmail.com', 465, context=context) as server:
        server.login(sender_email, password)
        server.send_message(msg)

def main():
    sender_email = input("Enter your email: ")
    password = input("Enter your app password (Gmail): ")

    contacts = read_contacts('contacts.csv')
    template = read_template('template.txt')

    subject = "Test Bulk Email"

    for person in contacts:
        personalized = template.replace("{{name}}", person['name'])
        send_email(person['email'], subject, personalized, sender_email, password)
        print(f"✅ Sent to {person['name']} <{person['email']}>")

if __name__ == "__main__":
    main()
