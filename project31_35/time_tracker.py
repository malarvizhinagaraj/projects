import time
import json
import os

log_file = "task_log.json"

def load_logs():
    if os.path.exists(log_file):
        with open(log_file, "r") as file:
            return json.load(file)
    return {}

def save_logs(logs):
    with open(log_file, "w") as file:
        json.dump(logs, file, indent=4)

def start_task(task_name):
    logs = load_logs()
    if task_name in logs and logs[task_name].get("start_time"):
        print(f"Task '{task_name}' is already running.")
    else:
        logs.setdefault(task_name, {})
        logs[task_name]["start_time"] = time.time()
        save_logs(logs)
        print(f"Started tracking task: {task_name}")

def stop_task(task_name):
    logs = load_logs()
    if task_name not in logs or not logs[task_name].get("start_time"):
        print(f"No active timer found for task '{task_name}'.")
    else:
        start_time = logs[task_name].pop("start_time")
        duration = time
