from cryptography.fernet import Fernet
import json
import os
import getpass

# 🎯 Files for storing the key and the password data
KEY_FILE = 'key.key'
DATA_FILE = 'passwords.json'

# 🗝️ Load or generate an encryption key
def load_key():
    if not os.path.exists(KEY_FILE):
        key = Fernet.generate_key()
        with open(KEY_FILE, 'wb') as f:
            f.write(key)
        print("🔐 New key created and saved!")
    else:
        with open(KEY_FILE, 'rb') as f:
            key = f.read()
        print("🔑 Using existing key!")
    return key

# 💾 Save a new password securely
def save_password(service, username, password, cipher):
    data = {}

    # Load existing passwords if the file exists
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, 'r') as f:
            data = json.load(f)

    # Encrypt the password for safety
    encrypted = cipher.encrypt(password.encode()).decode()

    # Store the new entry
    data[service] = {'username': username, 'password': encrypted}

    with open(DATA_FILE, 'w') as f:
        json.dump(data, f, indent=2)

    print(f"✅ Password saved for '{service}' – safely tucked away!")

# 🔍 Retrieve and show a password
def retrieve_password(service, cipher):
    if not os.path.exists(DATA_FILE):
        print("📭 No passwords saved yet!")
        return

    with open(DATA_FILE, 'r') as f:
        data = json.load(f)

    if service in data:
        enc_pwd = data[service]['password']
        username = data[service]['username']
        dec_pwd = cipher.decrypt(enc_pwd.encode()).decode()

        print(f"📌 Details for {service}:")
        print(f"👤 Username: {username}")
        print(f"🔑 Password: {dec_pwd}")
    else:
        print(f"❌ Sorry, no entry found for '{service}'.")

# 🎬 Let's roll!
def main():
    print("🔐 Welcome to your Friendly Password Vault!")
    key = load_key()
    cipher = Fernet(key)

    while True:
        print("\nWhat would you like to do?")
        choice = input("(Type 'save', 'retrieve', or 'exit'): ").strip().lower()

        if choice == 'save':
            service = input("🌐 Service name (e.g., Gmail): ")
            username = input("👤 Username or email: ")
            password = getpass.getpass("🔒 Password (hidden while typing): ")
            save_password(service, username, password, cipher)

        elif choice == 'retrieve':
            service = input("🔎 Enter the service name to look up: ")
            retrieve_password(service, cipher)

        elif choice == 'exit':
            print("👋 Exiting... Your secrets are safe. Stay awesome!")
            break

        else:
            print("🤔 I didn’t catch that. Please choose: save, retrieve, or exit.")

if __name__ == "__main__":
    main()
