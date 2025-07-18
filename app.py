from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/portfolio')
def portfolio():
    return render_template('portfolio.html', name="Malar", skills=["Python", "Flask", "HTML"], projects=["Project A", "Project B"], available=True)

@app.route('/books')
def books():
    books = [{"name": "Flask for Beginners", "author": "Jane"}, {"name": "Python Deep Dive", "author": "John"}]
    return render_template('books.html', books=books)

@app.route('/result')
def result():
    student = {
        "name": "Malar",
        "subjects": {"Math": 85, "Science": 78, "English": 92},
        "grade": "A"
    }
    return render_template('result.html', student=student)

@app.route('/weather')
def weather():
    weather_info = {"temperature": 35, "condition": "sun"}
    return render_template('weather.html', **weather_info)

if __name__ == "__main__":
    app.run(debug=True)
