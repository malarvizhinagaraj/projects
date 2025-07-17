

from flask import Flask, request, redirect, url_for, render_template_string

app = Flask(__name__)

# --- 1. URL Routing and Dynamic Parameters (/<name>) ---

@app.route('/hello/<name>')
def hello(name):
    return f"Hello, {name}!"

@app.route('/square/<int:number>')
def square(number):
    return f"Square of {number} is {number**2}"

@app.route('/greet/<name>/<int:age>')
def greet(name, age):
    return f"Hi {name}, you are {age} years old."

@app.route('/status/<username>/<status>')
def status(username, status):
    return f"{username} is currently {status}."

@app.route('/price/<float:amount>')
def price(amount):
    return f"Price: ${amount:.2f}"

@app.route('/profile/<username>')
def profile(username):
    return f"<h2>Profile of {username}</h2><p>This is a basic user profile page.</p>"

@app.route('/math/<int:x>/<int:y>')
def math_ops(x, y):
    return f"Sum: {x+y}, Diff: {x-y}, Product: {x*y}"

@app.route('/file/<path:filename>')
def file_path(filename):
    return f"Requested file path: {filename}"

@app.route('/color/<string:color>')
def color_text(color):
    return f"<p style='color:{color}'>This is {color} text</p>"

@app.route('/language/<lang>')
def check_language(lang):
    supported = ['python', 'java', 'c++']
    if lang.lower() in supported:
        return f"{lang} is supported!"
    return f"{lang} is not supported."

@app.route('/user/<username>')
def find_user(username):
    valid_users = ['alice', 'bob', 'john']
    if username.lower() not in valid_users:
        return "User not found", 404
    return f"Welcome, {username}!"

@app.route('/country/<code>')
def country_name(code):
    countries = {'IN': 'India', 'US': 'United States', 'FR': 'France'}
    return countries.get(code.upper(), "Country not found")

@app.route('/debug/<param>')
def debug_print(param):
    print(f"Received: {param}")
    return f"Check console log. Received: {param}"

@app.route('/html/<item>')
def formatted_html(item):
    return f"""<html>
    <body>
        <h1>Item: {item}</h1>
        <p>This is a dynamic HTML response.</p>
    </body>
    </html>"""

@app.route('/error/<int:code>')
def error_code(code):
    return f"Error {code}: Something went wrong!", code


# --- 2. Handling GET & POST Requests ---

@app.route('/method-check', methods=["GET", "POST"])
def method_check():
    return f"HTTP Method: {request.method}"

@app.route('/submit', methods=["POST"])
def submit():
    return "Submitted successfully via POST."

@app.route('/both-methods', methods=["GET", "POST"])
def both_methods():
    return f"Used method: {request.method}"

@app.route('/login', methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form.get("username", "")
        return f"Welcome {username}"
    return '''
    <form method="POST">
        Username: <input name="username">
        <input type="submit">
    </form>
    '''

@app.route('/admin', methods=["GET", "POST"])
def admin():
    if request.method == "POST":
        return "POST not allowed on /admin", 405
    return "Welcome to Admin Panel"

@app.before_request
def log_method():
    print(f"HTTP method: {request.method}")

@app.route('/feedback', methods=["GET", "POST"])
def feedback():
    if request.method == "POST":
        fb = request.form.get("feedback", "")
        return f"Feedback received: {fb}"
    return '''
    <form method="POST">
        Feedback: <textarea name="feedback"></textarea>
        <input type="submit">
    </form>
    '''

@app.route('/post-button')
def post_button():
    return '''
    <form action="/submit" method="POST">
        <input type="submit" value="Submit POST">
    </form>
    '''

@app.route('/get-post-form')
def get_post_form():
    return '''
    <form action="/method-check" method="GET">
        <input type="submit" value="GET Request">
    </form>
    <form action="/method-check" method="POST">
        <input type="submit" value="POST Request">
    </form>
    '''


# --- 3. Using request.args for Query Parameters ---

@app.route('/search')
def search():
    keyword = request.args.get("keyword")
    if keyword:
        return f"Searching for: {keyword}"
    return "No keyword found"

@app.route('/filter')
def filter_items():
    type_ = request.args.get("type", "any")
    color = request.args.get("color", "any")
    size = request.args.get("size", "any")
    return f"Filter: Type={type_}, Color={color}, Size={size}"

@app.route('/all-params')
def all_params():
    if not request.args:
        return "No parameters found"
    items = "".join(f"<li>{k}: {v}</li>" for k, v in request.args.items())
    return f"<ul>{items}</ul>"

@app.route('/greet-query')
def greet_query():
    name = request.args.get("name", "Guest")
    return f"Hello, {name}!"

@app.route('/profile')
def optional_profile():
    mode = request.args.get("mode", "guest")
    return f"Profile Mode: {mode}"

@app.route('/args-count')
def args_count():
    return f"Total Query Params: {len(request.args)}"

@app.route('/args-table')
def args_table():
    rows = "".join(f"<tr><td>{k}</td><td>{v}</td></tr>" for k, v in request.args.items())
    return f"<table border='1'>{rows}</table>"

@app.route('/debug-mode')
def debug_mode():
    if request.args.get("debug") == "true":
        return "Debug mode is ON"
    return "Debug mode is OFF"

@app.route('/display/<name>')
def display_combined(name):
    lang = request.args.get("lang", "none")
    return f"User: {name} | Language: {lang}"

# ---- URL Routing and Dynamic Parameters ----
@app.route('/hello/<name>')
def hello(name):
    return f"Hello, {name}!"

@app.route('/square/<int:number>')
def square(number):
    return f"Square of {number} is {number ** 2}"

@app.route('/greet/<name>/<int:age>')
def greet(name, age):
    return f"Hi {name}, you are {age} years old."

@app.route('/status/<username>/<status>')
def status(username, status):
    return f"{username} is currently {status}."

@app.route('/price/<float:amount>')
def price(amount):
    return f"Price: ${amount:.2f}"

@app.route('/profile/<username>')
def profile(username):
    return f"<h2>Profile of {username}</h2><p>This is a basic user profile page.</p>"

@app.route('/math/<int:x>/<int:y>')
def math_ops(x, y):
    return f"Sum: {x+y}, Diff: {x-y}, Product: {x*y}"

@app.route('/file/<path:filename>')
def file_path(filename):
    return f"Requested file path: {filename}"

@app.route('/color/<string:color>')
def color_text(color):
    return f"<p style='color:{color}'>This is {color} text</p>"

@app.route('/language/<lang>')
def check_language(lang):
    supported = ['python', 'java', 'c++']
    return f"{lang} is supported!" if lang in supported else f"{lang} is not supported."

@app.route('/user/<username>')
def find_user(username):
    valid_users = ['alice', 'bob', 'john']
    return f"Welcome, {username}!" if username in valid_users else "User not found"

@app.route('/country/<code>')
def country_name(code):
    countries = {'IN': 'India', 'US': 'United States', 'FR': 'France'}
    return countries.get(code.upper(), "Country not found")

@app.route('/debug/<param>')
def debug_print(param):
    print(f"Received: {param}")
    return f"Check console log. Received: {param}"

@app.route('/html/<item>')
def formatted_html(item):
    return f"""<html><body><h1>Item: {item}</h1><p>This is a dynamic HTML response.</p></body></html>"""

@app.route('/error/<int:code>')
def error_code(code):
    return f"Error {code}: Something went wrong!", code

# ---- Handling GET & POST Requests ----
@app.route('/method-check', methods=['GET', 'POST'])
def method_check():
    return f"HTTP Method: {request.method}"

@app.route('/submit', methods=['POST'])
def submit():
    return "Submitted successfully via POST."

@app.route('/both-methods', methods=['GET', 'POST'])
def both_methods():
    return f"Used method: {request.method}"

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        return f"Welcome {username}"
    return '''<form method="POST">Username: <input name="username"><input type="submit"></form>'''

@app.route('/admin', methods=['GET', 'POST'])
def admin():
    if request.method == 'POST':
        return "POST not allowed", 405
    return "Admin panel (GET only)"

@app.before_request
def log_method():
    print(f"Method used: {request.method}")

@app.route('/feedback', methods=['GET', 'POST'])
def feedback():
    if request.method == 'POST':
        fb = request.form.get('feedback')
        return f"Feedback received: {fb}"
    return '''<form method="POST"><textarea name="feedback"></textarea><input type="submit"></form>'''

@app.route('/post-button')
def post_button():
    return '''<form action="/submit" method="POST"><input type="submit" value="Submit"></form>'''

@app.route('/get-post-form')
def get_post_form():
    return '''<form action="/method-check" method="GET"><input type="submit" value="GET"></form>
              <form action="/method-check" method="POST"><input type="submit" value="POST"></form>'''

# ---- Using request.args for Query Parameters ----
@app.route('/search')
def search():
    keyword = request.args.get('keyword')
    return f"Searching for: {keyword}" if keyword else "No keyword found"

@app.route('/filter')
def filter_items():
    return f"Type={request.args.get('type')}, Color={request.args.get('color')}, Size={request.args.get('size')}"

@app.route('/all-params')
def all_params():
    return "<ul>" + "".join(f"<li>{k}: {v}</li>" for k, v in request.args.items()) + "</ul>"

@app.route('/greet-query')
def greet_query():
    return f"Hello, {request.args.get('name', 'Guest')}!"

@app.route('/args-count')
def args_count():
    return f"Total query params: {len(request.args)}"

@app.route('/args-table')
def args_table():
    rows = "".join(f"<tr><td>{k}</td><td>{v}</td></tr>" for k, v in request.args.items())
    return f"<table border='1'>{rows}</table>"

@app.route('/debug-mode')
def debug_mode():
    return "Debug ON" if request.args.get("debug") == "true" else "Debug OFF"

@app.route('/display/<name>')
def display_combined(name):
    lang = request.args.get("lang", "none")
    return f"User: {name} | Language: {lang}"

# ---- Redirects and URL Building ----
@app.route('/home')
def home():
    return "Welcome to Home Page"

@app.route('/start')
def start():
    return redirect(url_for('home'))

@app.route('/dashboard')
def dashboard():
    logged_in = False
    return redirect(url_for('login')) if not logged_in else "Dashboard"

@app.route('/profile-link')
def profile_link():
    return f'<a href="{url_for("profile", username="malar")}">Mahesh Profile</a>'

@app.route('/link-page')
def link_page():
    return f'<a href="{url_for("home")}">Home</a> | <a href="{url_for("login")}">Login</a>'

@app.route('/contact', methods=['GET', 'POST'])
def contact():
    if request.method == 'POST':
        name = request.form.get('name', '')
        message = request.form.get('message', '')
        if not name or not message:
            return "Both fields are required", 400
        return redirect(url_for('thankyou'))
    return '''
    <form method="POST">
        Name: <input name="name"><br>
        Message: <textarea name="message"></textarea><br>
        <input type="submit">
    </form>'''

@app.route('/thankyou')
def thankyou():
    return "Thank you for your submission!"


#Mini projects

feedbacks = []
applications = []
rsvps = []
votes = []
contacts = []
bookings = []
registrations = []
bug_reports = []
warranty_data = {}
mood_logs = []
quiz_scores = []
greetings = []
recommendations = []
donations = []
fitness_goals = []
complaints = []
certificates = []
subscribers = []
weather_reports = []
ratings = []

@app.route('/feedback-form')
def feedback_form():
    return render_template_string('''
        <form method="POST" action="/submit-feedback">
            Name: <input name="name"><br>
            Email: <input name="email"><br>
            Message: <textarea name="message"></textarea><br>
            <input type="submit">
        </form>
    ''')

@app.route('/submit-feedback', methods=['POST'])
def submit_feedback():
    name = request.form['name']
    email = request.form['email']
    message = request.form['message']
    feedbacks.append({'name': name, 'email': email, 'message': message})
    return redirect('/thank-you')

@app.route('/thank-you')
def thank_you():
    return "<h3>Thank you for your submission!</h3>"

@app.route('/feedbacks')
def feedbacks_list():
    user = request.args.get('user')
    filtered = [f for f in feedbacks if f['name'].lower() == user.lower()] if user else feedbacks
    return "<br>".join([f"{f['name']} ({f['email']}): {f['message']}" for f in filtered])

@app.route('/user/<username>')
def user_feedback(username):
    user_data = [f for f in feedbacks if f['name'].lower() == username.lower()]
    return f"<h2>Feedbacks by {username}</h2>" + "<br>".join([f"{f['message']}" for f in user_data])

@app.route('/rate')
def rate():
    return render_template_string('''
        <form method="POST" action="/submit-rating">
            Name: <input name="name"><br>
            Movie Title: <input name="title"><br>
            Rating: <input type="number" name="rating" min="1" max="5"><br>
            <input type="submit">
        </form>
    ''')

@app.route('/submit-rating', methods=['POST'])
def submit_rating():
    name = request.form.get('name')
    title = request.form.get('title')
    rating = request.form.get('rating')
    ratings.append({'name': name, 'title': title, 'rating': rating})
    return redirect(url_for('thank_you_name', name=name))

@app.route('/thank-you/<name>')
def thank_you_name(name):
    return f"<h3>Thank you, {name}, for rating the movie!</h3>"

@app.route('/ratings')
def view_ratings():
    movie_filter = request.args.get('movie')
    filtered = [r for r in ratings if r['title'].lower() == movie_filter.lower()] if movie_filter else ratings
    output = "<h2>Movie Ratings</h2>"
    for r in filtered:
        output += f"<p>{r['name']} rated '{r['title']}' - {r['rating']}/5</p>"
    return output or "<p>No ratings found</p>"

@app.route('/movie/<title>')
def movie_info(title):
    related = [r for r in ratings if r['title'].lower() == title.lower()]
    if not related:
        return f"<h3>No ratings found for '{title}'</h3>"
    return f"<h2>{title} Ratings</h2>" + "<br>".join([f"{r['name']} rated {r['rating']}" for r in related])


# Run the app
if __name__ == '__main__':
    app.run(debug=True)