import os
from datetime import datetime

# Folder to store diary entries
diary_folder = "diary_entries"

# Create the folder if it doesn't exist
os.makedirs(diary_folder, exist_ok=True)

def write_entry():
    print("\n📝 Write your diary entry. Type 'END' on a new line to finish.")
    lines = []
    while True:
        line = input()
        if line.strip().upper() == "END":
            break
        lines.append(line)

    if lines:
        entry_text = "\n".join(lines)
        timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        filename = f"{diary_folder}/entry_{timestamp}.txt"

        with open(filename, "w", encoding="utf-8") as f:
            f.write(f"Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write("-" * 40 + "\n")
            f.write(entry_text)
        
        print(f"\n✅ Entry saved to '{filename}'")
    else:
        print("❌ No entry written.")

def list_entries():
    print("\n📚 Saved Entries:")
    files = sorted(os.listdir(diary_folder))
    if not files:
        print("No entries found.")
    else:
        for i, file in enumerate(files, 1):
            print(f"{i}. {file}")

def read_entry():
    list_entries()
    files = sorted(os.listdir(diary_folder))
    if not files:
        return
    try:
        choice = int(input("Enter the number of the entry to read: "))
        if 1 <= choice <= len(files):
            with open(f"{diary_folder}/{files[choice - 1]}", "r", encoding="utf-8") as f:
                print("\n" + f.read())
        else:
            print("Invalid choice.")
    except ValueError:
        print("Please enter a valid number.")

def main():
    while True:
        print("\n=== Personal Diary ===")
        print("1. Write New Entry")
        print("2. View Entries")
        print("3. Read an Entry")
        print("4. Exit")

        choice = input("Choose an option: ")

        if choice == "1":
            write_entry()
        elif choice == "2":
            list_entries()
        elif choice == "3":
            read_entry()
        elif choice == "4":
            print("👋 Exiting diary. Have a good day!")
            break
        else:
            print("Invalid choice. Try again.")

if __name__ == "__main__":
    main()
