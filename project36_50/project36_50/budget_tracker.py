import json
import os
from datetime import datetime

DATA_FILE = "budget_data.json"

def load_data():
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, "r") as f:
            return json.load(f)
    return []

def save_data(data):
    with open(DATA_FILE, "w") as f:
        json.dump(data, f, indent=4)

def add_expense(data):
    date = input("Enter date (YYYY-MM-DD) [default today]: ").strip()
    if not date:
        date = datetime.today().strftime("%Y-%m-%d")
    try:
        datetime.strptime(date, "%Y-%m-%d")
    except ValueError:
        print("Invalid date format. Use YYYY-MM-DD.")
        return

    category = input("Enter category (e.g. Food, Transport): ").strip()
    try:
        amount = float(input("Enter amount spent: "))
    except ValueError:
        print("Invalid amount.")
        return

    data.append({"date": date, "category": category, "amount": amount})
    save_data(data)
    print("Expense added.\n")

def view_summary(data):
    current_month = datetime.today().strftime("%Y-%m")
    monthly_expenses = [d for d in data if d["date"].startswith(current_month)]

    if not monthly_expenses:
        print("No expenses recorded for this month.\n")
        return

    total = sum(item["amount"] for item in monthly_expenses)
    print(f"\nTotal expenses for {current_month}: {total:.2f}")

    category_totals = {}
    for item in monthly_expenses:
        category_totals[item["category"]] = category_totals.get(item["category"], 0) + item["amount"]

    print("Expenses by category:")
    for cat, amt in category_totals.items():
        print(f"  {cat}: {amt:.2f}")
    print()

def main():
    data = load_data()

    while True:
        print("Budget Tracker")
        print("1. Add Expense")
        print("2. View Summary")
        print("3. Exit")
        choice = input("Choose an option: ").strip()

        if choice == "1":
            add_expense(data)
        elif choice == "2":
            view_summary(data)
        elif choice == "3":
            print("Goodbye!")
            break
        else:
            print("Invalid choice, try again.\n")

if __name__ == "__main__":
    main()
