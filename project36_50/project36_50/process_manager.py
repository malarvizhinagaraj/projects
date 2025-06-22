import psutil

def list_processes():
    print(f"{'PID':<10} {'Name':<25} {'Status':<10}")
    print("-" * 50)
    for proc in psutil.process_iter(['pid', 'name', 'status']):
        try:
            print(f"{proc.info['pid']:<10} {proc.info['name'][:25]:<25} {proc.info['status']:<10}")
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            continue

def kill_process(pid):
    try:
        p = psutil.Process(pid)
        p.terminate()
        p.wait(timeout=3)
        print(f"Process {pid} terminated successfully.")
    except psutil.NoSuchProcess:
        print("No such process.")
    except psutil.AccessDenied:
        print("Permission denied to terminate this process.")
    except Exception as e:
        print(f"Error: {e}")

def main():
    while True:
        print("\n--- Process Manager ---")
        print("1. View Running Processes")
        print("2. Kill a Process")
        print("3. Exit")

        choice = input("Enter your choice: ")

        if choice == '1':
            list_processes()
        elif choice == '2':
            try:
                pid = int(input("Enter the PID of the process to kill: "))
                kill_process(pid)
            except ValueError:
                print("Please enter a valid numeric PID.")
        elif choice == '3':
            print("Exiting Process Manager.")
            break
        else:
            print("Invalid choice. Try again.")

if __name__ == "__main__":
    main()
