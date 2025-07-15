#1. Digital Visiting Card
from flask import Flask
app=Flask(__name__)
@app.route("/")
def home():
    return"""<h1>MALARVIZHI</h1>
    <p>Profession: DATA ANALYSIST</p>
    <p>Contact: nmalar2009@gmail.com | 9952161114</p>"""

@app.route("/about")
def about():
    return"""<h2>About Malarvizhi</h2>
    <p>Malarvizhi is a passionate software developer with 3 years of experience in Python and web development. 
    She loves building web apps and teaching programming to students.</p>
"""



from flask import Flask
from datetime import datetime

app = Flask(__name__)

# Home route: Shows open/closed based on server time
@app.route("/")
def home():
    now = datetime.now()
    current_hour = now.hour
    # Example: Open from 9 AM to 5 PM
    if 9 <= current_hour < 17:
        status = "<b>We are open!</b>"
    else:
        status = "<b>We are closed.</b>"
   
    return f"""
    <p>Current Server Time: {now.strftime('%Y-%m-%d %H:%M:%S')}</p>
    <hr>
    <p>{status}</p>
    """


@app.route("/contact")
def contact():
    return """
    <h2>Contact Us</h2>
    <p>Email: <b>info@mybusiness.com</b></p>
    <p>Phone: <b>9952161114</b></p>
    <hr>
    <p>We typically respond within 24 hours.</p>
    """



# 3. Simple Text Banner Generator
@app.route('/')
def index():
    return '<h2>Enter your banner text</h2><a href="/banner/Hello">Try Banner</a>'

@app.route('/banner/<text>')
def banner(text):
    return f'<h1>{text}</h1>'

@app.route('/banner/<text>/<size>')
def banner_with_size(text, size):
    if size not in ['h1', 'h2', 'h3', 'h4', 'h5', 'h6']:
        size = 'h1'
    return f'<{size}>{text}</{size}>'

# 4. Personalized Greeting App
@app.route('/hello/<name>')
def hello(name):
    return f'Hello, {name}!'

@app.route('/greet/<name>/<time>')
def greet(name, time):
    if time.lower() == 'morning':
        return f'Good Morning {name}'
    elif time.lower() == 'evening':
        return f'Good Evening {name}'
    return f'Hello {name}'

# 5. Daily Quote Viewer
quotes = [
    "Believe in yourself.",
    "Stay positive.",
    "Never give up.",
    "Be kind.",
    "Work hard.",
    "Stay humble.",
    "Dream big."
]

@app.route('/quote')
def today_quote():
    day = datetime.now().weekday()
    return f'<p style="color:blue;font-size:20px">{quotes[day]}</p>'

@app.route('/quote/<day>')
def quote_by_day(day):
    days = ['monday','tuesday','wednesday','thursday','friday','saturday','sunday']
    if day.lower() in days:
        return f'<p style="color:green">{quotes[days.index(day.lower())]}</p>'
    return 'Invalid day.'

# 6. BMI Calculator
@app.route('/bmi')
def bmi_info():
    return 'Usage: /bmi/<weight_kg>/<height_m>'

@app.route('/bmi/<float:weight>/<float:height>')
def calc_bmi(weight, height):
    bmi = weight / (height ** 2)
    category = ('Underweight' if bmi < 18.5 else 'Normal' if bmi < 25 else 'Overweight' if bmi < 30 else 'Obese')
    return f'BMI: {bmi:.2f}, Category: {category}'

# 7. Static Portfolio Page Generator
@app.route('/portfolio/<name>')
def portfolio(name):
    return f'<h2>Profile: {name}</h2>'

@app.route('/portfolio/<name>/skills')
def skills(name):
    skills = ['Python', 'Flask', 'SQL']
    return f'<h3>{name} s Skills:</h3><ul>' + ''.join(f'<li>{s}</li>' for s in skills) + '</ul>'

@app.route('/portfolio/<name>/projects')
def projects(name):
    projects = ['App1', 'App2', 'App3']
    return f'<h3>{name} s Projects:</h3><table border=1>' + ''.join(f'<tr><td>{p}</td></tr>' for p in projects) + '</table>'

# 8. Basic User Tracker
@app.route('/user/<name>')
def user(name):
    print(f"Accessed /user/{name}")
    return f'Welcome, {name}!'

@app.route('/user/<name>/location/<city>')
def user_location(name, city):
    print(f"Accessed /user/{name}/location/{city}")
    return f'Hi {name}, how is {city} today?'

# 9. Server Info Dashboard
@app.route('/server')
def server_info():
    return f'IP: localhost, Port: 8000, Env: development'

@app.route('/status')
def status():
    return 'Running in Debug Mode' if app.debug else 'Production Mode'

# 10. Motivational Message Rotator
messages = ["You can do it!", "Keep going!", "Stay focused!", "Be amazing!"]
msg_index = 0

@app.route('/message')
def rotate_message():
    global msg_index
    msg = messages[msg_index % len(messages)]
    msg_index += 1
    return f'<p style="color:purple">{msg}</p>'

@app.route('/message/<int:index>')
def message_by_index(index):
    if 0 <= index < len(messages):
        return f'<p style="color:orange">{messages[index]}</p>'
    return 'Invalid index.'

# 11. Age Checker App
@app.route('/age/<name>/<int:year>')
def age_checker(name, year):
    current_year = datetime.now().year
    if year >= current_year:
        return 'Year must be less than current year.'
    return f"""
    <h2>Hi {name}</h2>
    <p>You are {current_year - year} years old</p>
    """

# 12. Simple Product Info Page
products = {
    1: {"name": "Laptop", "price": 50000, "stock": True},
    2: {"name": "Mouse", "price": 500, "stock": False},
    3: {"name": "Monitor", "price": 12000, "stock": True}
}

@app.route('/product/<int:id>')
def product_info(id):
    if id in products:
        p = products[id]
        return f"Name: {p['name']}, Price: {p['price']}, Stock: {'Yes' if p['stock'] else 'No'}"
    return 'Product not found.'

@app.route('/products')
def list_products():
    return '<table border=1>' + ''.join(f'<tr><td>{pid}</td><td>{p["name"]}</td></tr>' for pid, p in products.items()) + '</table>'

# 13. Zodiac Sign Generator
@app.route('/zodiac/help')
def zodiac_help():
    return 'Use /zodiac/YYYY-MM-DD format'

@app.route('/zodiac/<date>')
def zodiac(date):
    try:
        year, month, day = map(int, date.split('-'))
        sign = 'Capricorn'  # Dummy logic for simplicity
        return f'<h3><strong>Zodiac Sign</strong>: <i>{sign}</i></h3><hr>'
    except:
        return 'Invalid format. Use YYYY-MM-DD.'

# 14. Word Counter App
@app.route('/wordcount/help')
def wordcount_help():
    return 'Use /wordcount/your+text+here'

@app.route('/wordcount/<text>')
def wordcount(text):
    count = len(text.split())
    return f'<h3>Word Count</h3><p>{count} words</p>'

# 15. Text Mirror Tool
@app.route('/mirror/<text>')
def mirror(text):
    reversed_text = text[::-1]
    return f'''<pre>
Original : {text}
Reversed : {reversed_text}
Length   : {len(text)}
</pre>'''

# 16. Day/Night Greeter
@app.route('/greet/<int:hour>')
def day_night(hour):
    if 5 <= hour < 12:
        return 'Good Morning'
    elif 12 <= hour < 18:
        return 'Good Afternoon'
    elif 18 <= hour <= 23:
        return 'Good Night'
    return 'Invalid hour'

@app.route('/greet/info')
def greet_info():
    return 'Hour must be between 0 and 23.'

# 17. Simple Calculator
@app.route('/calc/<op>/<int:num1>/<int:num2>')
def calc(op, num1, num2):
    if op == 'add': return f'<h2>{num1 + num2}</h2>'
    if op == 'sub': return f'<h2>{num1 - num2}</h2>'
    if op == 'mul': return f'<h2>{num1 * num2}</h2>'
    if op == 'div':
        if num2 == 0: return 'Cannot divide by zero'
        return f'<h2>{num1 / num2:.2f}</h2>'
    return 'Invalid operation'

@app.route('/ops')
def ops():
    return 'Valid ops: add, sub, mul, div'

# 18. URL Short Previewer
@app.route('/preview/<site>')
def preview(site):
    return f'<h1>Preview of {site}.com</h1><p>This is {site}.com website.</p>'

# 19. Fun Fact Generator by Animal
facts = {
    "dog": "Dogs can smell disease.",
    "cat": "Cats sleep 70% of their lives.",
    "elephant": "Elephants remember everything."
}

@app.route('/fact/<animal>')
def animal_fact(animal):
    return f'<ul><li>{facts.get(animal, "No fact available.")}</li></ul>'

@app.route('/fact/list')
def animal_list():
    return '<ul>' + ''.join(f'<li>{animal}</li>' for animal in facts) + '</ul>'

# 20. Health Reminder Display
reminders = ["Drink water!", "Take a deep breath!", "Stretch your legs!", "Blink and look away!"]

@app.route('/reminder/<int:hour>')
def reminder(hour):
    return reminders[hour % len(reminders)]

@app.route('/reminder/help')
def reminder_help():
    return 'Use /reminder/<hour> to get a health tip.'

if __name__ == '__main__':
    app.run(debug=True)
