import socket
import threading

HOST = '127.0.0.1'  # server IP
PORT = 5000

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((HOST, PORT))

def receive():
    while True:
        try:
            message = client.recv(1024).decode()
            if message:
                print("\n" + message)
        except:
            print("Disconnected from server.")
            break

def write():
    name = input("Enter your name: ")
    while True:
        msg = input()
        message = f"{name}: {msg}"
        client.send(message.encode())

# Run threads
threading.Thread(target=receive, daemon=True).start()
write()
