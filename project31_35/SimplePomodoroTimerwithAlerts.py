import time
import os
import platform

# Settings
work_duration = 25 * 60  # 25 minutes
short_break = 5 * 60     # 5 minutes
long_break = 15 * 60     # 15 minutes
cycles = 4               # Pomodoros before long break

def alert(message):
    # Terminal alert + optional beep
    print("\n" + "=" * 40)
    print(f"🔔 {message}")
    print("=" * 40)
    if platform.system() == "Windows":
        os.system('echo \a')  # Beep sound
    else:
        print('\a')  # Terminal bell on Unix/Linux/macOS

def countdown(seconds):
    while seconds:
        mins, secs = divmod(seconds, 60)
        print(f"\r⏳ {mins:02d}:{secs:02d} remaining", end="")
        time.sleep(1)
        seconds -= 1
    print("\r⏳ 00:00 remaining", end="")

def pomodoro():
    session = 1
    while True:
        print(f"\n🍅 Pomodoro Session #{session} - Work Time!")
        countdown(work_duration)
        alert("Time for a break!")

        if session % cycles == 0:
            print("💤 Long Break")
            countdown(long_break)
        else:
            print("☕ Short Break")
            countdown(short_break)

        alert("Back to work?")
        session += 1

        user_input = input("Press [Enter] to continue or type 'q' to quit: ")
