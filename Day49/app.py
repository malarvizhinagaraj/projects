from flask import Flask, render_template, redirect, request, flash, get_flashed_messages
from forms import UserForm
from flask_wtf.csrf import CSRFProtect


app = Flask(__name__)
app.secret_key = 'your_secret_key'
csrf = CSRFProtect(app)

@app.route('/', methods=['GET', 'POST'])
def index():
    form = UserForm()

    if request.method == 'POST':
        if form.validate_on_submit():
            # ✅ Success messages
            flash("Form submitted successfully!", "success")
            flash(f"Hello, {form.name.data}!", "info")
            if form.age.data > 60:
                flash("Senior citizen benefits may apply!", "warning")
            print("\n--- FORM SUBMITTED DATA ---")
            for field_name, field in form._fields.items():
                print(f"{field_name}: {field.data}")
            print("----------------------------\n")
            return render_template('success.html', name=form.name.data)
        else:
            flash("Please correct the errors in the form.", "error")
            print(f"Form errors: {form.errors}")
    return render_template('form.html', form=form)

@app.route('/success')
def success():
    return render_template('success.html')

if __name__ == '__main__':
    app.run(debug=True)
