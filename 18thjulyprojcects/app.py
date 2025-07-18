from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

# 1. Simple Portfolio Generator
@app.route('/portfolio', methods=['GET', 'POST'])
def portfolio():
    if request.method == 'POST':
        name = request.form['name']
        skills = request.form['skills']
        bio = request.form['bio']
        return render_template('portfolio.html', name=name, skills=skills, bio=bio)
    return render_template('portfolio_form.html')

# 2. Greeting App
@app.route('/greet/<name>')
def greet(name):
    lang = request.args.get('lang', 'en')
    return render_template('greet.html', name=name, lang=lang)

# 3. Feedback Collector
@app.route('/feedback', methods=['GET', 'POST'])
def feedback():
    if request.method == 'POST':
        fb = request.form['feedback']
        return redirect(url_for('thank_feedback', fb=fb))
    return render_template('feedback_form.html')

@app.route('/thank-feedback')
def thank_feedback():
    fb = request.args.get('fb')
    return render_template('thank_feedback.html', fb=fb)

# 4. Mini Contact Form App
@app.route('/contact', methods=['GET', 'POST'])
def contact():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        msg = request.form['message']
        return render_template('thank_contact.html', name=name, email=email, msg=msg)
    return render_template('contact_form.html')

# 5. Simple Calculator
@app.route('/calculator', methods=['GET', 'POST'])
def calculator():
    result = None
    if request.method == 'POST':
        num1 = float(request.form['num1'])
        num2 = float(request.form['num2'])
        operation = request.form['operation']
        if operation == 'add':
            result = num1 + num2
        elif operation == 'subtract':
            result = num1 - num2
        elif operation == 'multiply':
            result = num1 * num2
        elif operation == 'divide':
            result = num1 / num2 if num2 != 0 else 'Error: Divide by zero'
    return render_template('calculator.html', result=result)

# 6. Student Introduction Page
@app.route('/student/<name>')
def student(name):
    age = request.args.get('age')
    course = request.args.get('course')
    return render_template('student.html', name=name, age=age, course=course)

# 7. Color Picker Preview
@app.route('/colorpicker', methods=['GET', 'POST'])
def colorpicker():
    color = '#ffffff'
    if request.method == 'POST':
        color = request.form['color']
    return render_template('colorpicker.html', color=color)

# 8. Book Recommendation Page
@app.route('/books', methods=['GET', 'POST'])
def books():
    if request.method == 'POST':
        genre = request.form['genre']
        return redirect(url_for('book_list', genre=genre))
    return render_template('books_form.html')

@app.route('/books/<genre>')
def book_list(genre):
    books = {'fiction': ['Book A', 'Book B'], 'nonfiction': ['Book C']}
    recommended = books.get(genre, [])
    return render_template('books_list.html', genre=genre, recommended=recommended)

# 9. User Bio Card Generator
@app.route('/biocard', methods=['GET', 'POST'])
def biocard():
    if request.method == 'POST':
        name = request.form['name']
        age = request.form['age']
        hobbies = request.form['hobbies'].split(',')
        return render_template('biocard.html', name=name, age=age, hobbies=hobbies)
    return render_template('biocard_form.html')

# 10. City Weather Display (Static Simulation)
@app.route('/weather/<city>')
def weather(city):
    unit = request.args.get('unit', 'celsius')
    weather_data = {'temp': '25', 'condition': 'Sunny'}
    return render_template('weather.html', city=city, unit=unit, weather=weather_data)

# 11. Quiz Question Preview
@app.route('/quiz/<int:question_id>')
def quiz(question_id):
    question = {'text': 'Sample Question?', 'options': ['A', 'B', 'C']}
    return render_template('quiz.html', question=question, id=question_id)

# 12. Survey Voting Page
@app.route('/survey', methods=['GET', 'POST'])
def survey():
    if request.method == 'POST':
        vote = request.form['vote']
        return render_template('survey_result.html', vote=vote)
    return render_template('survey_form.html')

# 13. News Category Reader
@app.route('/news/<category>')
def news(category):
    articles = {'tech': ['Tech News 1'], 'sports': ['Sports News 1']}
    return render_template('news.html', category=category, articles=articles.get(category, []))

# 14. Simple Login Page
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        return render_template('welcome.html', username=username)
    return render_template('login_form.html')

# 15. Time-Based Greeting App
@app.route('/greettime')
def greettime():
    hour = int(request.args.get('hour', 12))
    if hour < 12:
        greeting = 'Good Morning'
    elif hour < 18:
        greeting = 'Good Afternoon'
    else:
        greeting = 'Good Evening'
    return render_template('greettime.html', greeting=greeting)

# 16. Movie Picker
@app.route('/moviepicker', methods=['GET', 'POST'])
def moviepicker():
    if request.method == 'POST':
        genre = request.form['genre']
        return redirect(url_for('movies', genre=genre))
    return render_template('moviepicker_form.html')

@app.route('/movies/<genre>')
def movies(genre):
    movies = {'action': ['Action Movie'], 'comedy': ['Comedy Movie']}
    return render_template('movies_list.html', genre=genre, movies=movies.get(genre, []))

# 17. Resume Formatter
@app.route('/resume', methods=['GET', 'POST'])
def resume():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        exp = request.form['experience']
        return render_template('resume.html', name=name, email=email, exp=exp)
    return render_template('resume_form.html')

# 18. Live Polling Form
@app.route('/poll', methods=['GET', 'POST'])
def poll():
    if request.method == 'POST':
        choice = request.form['choice']
        return render_template('poll_result.html', choice=choice)
    return render_template('poll_form.html')

# 19. HTML Email Template Previewer
@app.route('/emailpreview', methods=['GET', 'POST'])
def emailpreview():
    if request.method == 'POST':
        title = request.form['title']
        body = request.form['body']
        return render_template('email_preview.html', title=title, body=body)
    return render_template('email_form.html')

# 20. Multi-Page Static Site
@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/services')
def services():
    return render_template('services.html')

@app.route('/')
def home():
    return render_template('home.html')

if __name__ == '__main__':
    app.run(debug=True)
