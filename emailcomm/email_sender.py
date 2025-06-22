import csv
import smtplib

def read_contacts(filename):
    with open(filename, newline='', encoding='utf-8') as f:
        return list(csv.DictReader(f))

def read_template(path):
    with open(path, 'r', encoding='utf-8') as f:
        return f.read()

def send_email(to_email, subject, body, from_email, app_password):
    try:
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(from_email, app_password)
        message = f"Subject: {subject}\n\n{body}"
        server.sendmail(from_email, to_email, message)
        print(f"Sent to {to_email}")
        server.quit()
    except Exception as e:
        print(f"Failed to send to {to_email}: {e}")

def fill_template(template, data):
    for key, value in data.items():
        template = template.replace(f"{{{{{key}}}}}", value)
    return template

def main():
    contacts = read_contacts('contacts.csv')
    template = read_template('email_template.txt')
    
    from_email = input("Enter your Gmail address: ")
    app_password = input("Enter your app password: ")

    for contact in contacts:
        filled = fill_template(template, contact)
        subject, body = filled.split('\n', 1)
        send_email(contact['email'], subject.replace("Subject: ", ""), body, from_email, app_password)

if __name__ == "__main__":
    main()
