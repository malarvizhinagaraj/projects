from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, TextAreaField, RadioField, SelectField, BooleanField, DateField, IntegerField, SubmitField
from wtforms.validators import DataRequired, Email, Length, EqualTo, NumberRange, Regexp, Optional, ValidationError

def block_test_domain(form, field):
    if field.data.endswith('@test.com'):
        raise ValidationError("Emails from 'test.com' are not allowed.")

class UserForm(FlaskForm):
    name = StringField('Name', validators=[
        DataRequired(message="Name is required."),
        Length(min=3, message="Name must be at least 3 characters."),
        Regexp('^[A-Za-z]+$', message="Name must contain only letters.")
    ])
    email = StringField('Email', validators=[
        DataRequired(), Email(), block_test_domain
    ])
    password = PasswordField('Password', validators=[DataRequired()])
    confirm_password = PasswordField('Confirm Password', validators=[
        DataRequired(), EqualTo('password', message="Passwords must match.")
    ])
    gender = RadioField('Gender', choices=[('M', 'Male'), ('F', 'Female')], validators=[DataRequired()])
    country = SelectField('Country', choices=[('IN', 'India'), ('US', 'USA'), ('AE', 'UAE')], validators=[DataRequired()])
    terms = BooleanField('I accept Terms', validators=[DataRequired(message="You must accept terms.")])
    comment = TextAreaField('Comments', validators=[Optional()])
    dob = DateField('Date of Birth', validators=[DataRequired()], format='%Y-%m-%d')
    age = IntegerField('Age', validators=[
        DataRequired(), NumberRange(min=18, max=60, message="Age must be between 18 and 60.")
    ])
    submit = SubmitField('Submit')
