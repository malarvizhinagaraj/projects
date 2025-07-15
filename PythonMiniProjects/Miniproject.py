
# os – Directory Organizer
import os
from pathlib import Path

def organize_directory(folder_path):
    for file in os.listdir(folder_path):
        full_path = os.path.join(folder_path, file)
        if os.path.isfile(full_path):
            ext = file.split('.')[-1]
            new_folder = os.path.join(folder_path, ext.upper() + "_Files")
            os.makedirs(new_folder, exist_ok=True)
            os.rename(full_path, os.path.join(new_folder, file))

organize_directory("C:\Users\HP\OneDrive\Desktop\sunrise")


# json – Todo App with JSON Storage
import json

FILENAME = "todos.json"

def load_tasks():
    try:
        with open(FILENAME, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        return []

def save_tasks(tasks):
    with open(FILENAME, 'w') as f:
        json.dump(tasks, f, indent=4)

def add_task(task):
    tasks = load_tasks()
    tasks.append({"task": task, "done": False})
    save_tasks(tasks)

def show_tasks():
    tasks = load_tasks()
    for i, t in enumerate(tasks, 1):
        print(f"{i}. [{'✓' if t['done'] else ' '}] {t['task']}")

add_task("Learn Python")
show_tasks()


# requests – Weather CLI App
import requests

API_KEY = "your_api_key_here"
city = input("Enter city name: ")

url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric"
response = requests.get(url)

if response.status_code == 200:
    data = response.json()
    print(f"Weather in {city}: {data['weather'][0]['description']}")
    print(f"Temperature: {data['main']['temp']}°C")
else:
    print("City not found or API error.")


#re – Email Extractor
import re

with open("sample.txt", "r") as file:
    content = file.read()

emails = re.findall(r"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+", content)
print("Emails found:")
print("\n".join(emails))


#jinja2 – Invoice Generator
from jinja2 import Template

invoice_template = """
<html>
<body>
<h2>Invoice for {{ name }}</h2>
<p>Amount: {{ amount }}</p>
<p>Due Date: {{ due_date }}</p>
</body>
</html>
"""

data = {
    "name": "John Doe",
    "amount": "$300",
    "due_date": "2025-07-20"
}

template = Template(invoice_template)
output = template.render(data)

with open("invoice.html", "w") as f:
    f.write(output)



#sqlite3 – Simple Notes App
import sqlite3

conn = sqlite3.connect("notes.db")
cur = conn.cursor()

cur.execute('''CREATE TABLE IF NOT EXISTS notes (id INTEGER PRIMARY KEY, content TEXT)''')

def add_note(content):
    cur.execute("INSERT INTO notes (content) VALUES (?)", (content,))
    conn.commit()

def show_notes():
    cur.execute("SELECT * FROM notes")
    for row in cur.fetchall():
        print(f"{row[0]}: {row[1]}")

add_note("Learn SQLite with Python")
show_notes()



#werkzeug – Password Hashing Tool
from werkzeug.security import generate_password_hash, check_password_hash

password = input("Enter a password: ")
hashed = generate_password_hash(password)
print("Hashed password:", hashed)

verify = input("Re-enter to verify: ")
if check_password_hash(hashed, verify):
    print("✅ Password verified")
else:
    print("❌ Password mismatch")
