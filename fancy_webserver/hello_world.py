import time

def main():
    current_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    with open(f"/Users/Shared/Desktop/hello_world_{current_time}.txt", "w") as f:
        f.write(f"hello world from launchd at {current_time}!")

main()
