import re
import smtplib
import dns.resolver
from validate_email_address import validate_email

def is_valid_format(email):
    pattern = r'^[\w\.-]+@[\w\.-]+\.\w+$'
    return re.match(pattern, email)

def check_mx_record(domain):
    try:
        records = dns.resolver.resolve(domain, 'MX')
        return True if records else False
    except:
        return False

def smtp_check(email):
    try:
        domain = email.split('@')[1]
        records = dns.resolver.resolve(domain, 'MX')
        mx_record = str(records[0].exchange)
        
        server = smtplib.SMTP(timeout=10)
        server.connect(mx_record)
        server.helo(server.local_hostname)
        server.mail('test@example.com')  # fake sender
        code, _ = server.rcpt(email)
        server.quit()

        return code == 250 or code == 251
    except Exception as e:
        return False

def full_email_check(email):
    if not is_valid_format(email):
        return "❌ Invalid email format"
    
    domain = email.split('@')[1]

    if not check_mx_record(domain):
        return "❌ Domain has no MX record"

    if smtp_check(email):
        return "✅ Email likely exists (SMTP check passed)"
    else:
        return "⚠️ Format and domain are valid, but SMTP check failed or blocked"

# Example usage:
email = input("Enter email to validate: ")
result = full_email_check(email)
print(result)
