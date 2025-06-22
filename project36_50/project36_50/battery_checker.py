import psutil
import time

def check_battery():
    battery = psutil.sensors_battery()
    if battery is None:
        print("No battery information available.")
        return

    percent = battery.percent
    plugged = battery.power_plugged

    status = "Charging" if plugged else "Not Charging"
    print(f"Battery: {percent}% - {status}")

    if not plugged and percent < 20:
        print("⚠️ Warning: Battery low! Please plug in your charger.")

if __name__ == "__main__":
    check_battery()
