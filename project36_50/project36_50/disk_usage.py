import psutil

def get_size(bytes, suffix="B"):
    """
    Scale bytes to a proper readable format.
    """
    factor = 1024
    for unit in ["", "K", "M", "G", "T", "P"]:
        if bytes < factor:
            return f"{bytes:.2f} {unit}{suffix}"
        bytes /= factor

def show_disk_usage():
    print(f"{'Drive':<10}{'Total':<15}{'Used':<15}{'Free':<15}{'Usage %'}")
    print("-" * 60)
    partitions = psutil.disk_partitions()
    for part in partitions:
        try:
            usage = psutil.disk_usage(part.mountpoint)
            print(f"{part.device:<10}{get_size(usage.total):<15}{get_size(usage.used):<15}{get_size(usage.free):<15}{usage.percent}%")
        except PermissionError:
            # Some drives might be inaccessible due to permission issues
            continue

if __name__ == "__main__":
    show_disk_usage()
