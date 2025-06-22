import json
import os

# File where we’ll keep our tasks
TODO_FILE = 'todos.json'

# Load tasks from file
def load_tasks():
    if os.path.exists(TODO_FILE):
        with open(TODO_FILE, 'r') as file:
            return json.load(file)
    return []

# Save tasks to file
def save_tasks(tasks):
    with open(TODO_FILE, 'w') as file:
        json.dump(tasks, file, indent=2)

# Show all tasks
def list_tasks(tasks):
    if not tasks:
        print("📝 No tasks yet! Time to get productive.")
    else:
        print("📋 Here's your to-do list:")
        for number, task in enumerate(tasks, start=1):
            status = "✅" if task['done'] else "🔲"
            print(f"{number}. {status} {task['title']}")

# Add a new task
def add_task(tasks, title):
    tasks.append({'title': title, 'done': False})
    print(f"✨ Task added: {title}")

# Mark a task as done
def mark_done(tasks, task_number):
    if 0 <= task_number < len(tasks):
        tasks[task_number]['done'] = True
        print(f"🎉 Task marked done: {tasks[task_number]['title']}")
    else:
        print("⚠️ That task number doesn't exist!")

# Remove a task
def delete_task(tasks, task_number):
    if 0 <= task_number < len(tasks):
        removed = tasks.pop(task_number)
        print(f"🗑️ Deleted: {removed['title']}")
    else:
        print("⚠️ That task number doesn't exist!")

# Main loop
def main():
    tasks = load_tasks()
    print("👋 Welcome to your To-Do CLI!")
    while True:
        command = input("\nType a command (add/list/done/delete/exit): ").strip()

        if command == "list":
            list_tasks(tasks)
        elif command.startswith("add "):
            title = command[4:]
            add_task(tasks, title)
        elif command.startswith("done "):
            number = int(command[5:]) - 1
            mark_done(tasks, number)
        elif command.startswith("delete "):
            number = int(command[7:]) - 1
            delete_task(tasks, number)
        elif command == "exit":
            save_tasks(tasks)
            print("👋 Bye! Keep conquering your to-dos!")
            break
        else:
            print("🤔 Oops! Not sure what you meant. Try again.")

if __name__ == "__main__":
    main()
