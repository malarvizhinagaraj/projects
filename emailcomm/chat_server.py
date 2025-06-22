import socket
import threading

HOST = '127.0.0.1'  # localhost (change to '' to accept any IP)
PORT = 5000

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((HOST, PORT))
server.listen()

clients = []

def broadcast(message, sender):
    for client in clients:
        if client != sender:
            client.sendall(message)

def handle_client(client):
    while True:
        try:
            message = client.recv(1024)
            if message:
                broadcast(message, client)
        except:
            clients.remove(client)
            client.close()
            break

print(f"Server started on {HOST}:{PORT}")

while True:
    client, address = server.accept()
    print(f"Connected with {address}")
    clients.append(client)
    thread = threading.Thread(target=handle_client, args=(client,))
    thread.start()
