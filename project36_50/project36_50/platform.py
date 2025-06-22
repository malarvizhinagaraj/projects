import platform
import psutil

def get_cpu_info():
    cpu_count = psutil.cpu_count(logical=True)
    cpu_freq = psutil.cpu_freq()
    return f"CPU cores (logical): {cpu_count}\nCPU frequency: {cpu_freq.current:.2f} MHz"

def get_ram_info():
    ram = psutil.virtual_memory()
    total_gb = ram.total / (1024 ** 3)
    used_gb = ram.used / (1024 ** 3)
    free_gb = ram.available / (1024 ** 3)
    return f"RAM Total: {total_gb:.2f} GB\nRAM Used: {used_gb:.2f} GB\nRAM Available: {free_gb:.2f} GB"

def get_os_info():
    uname = platform.uname()
    return f"OS: {uname.system} {uname.release} ({uname.version})\nMachine: {uname.machine}\nProcessor: {uname.processor}"

def main():
    print("=== System Info ===")
    print(get_cpu_info())
    print()
    print(get_ram_info())
    print()
    print(get_os_info())

if __name__ == "__main__":
    main()
