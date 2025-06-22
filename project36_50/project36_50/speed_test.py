import speedtest

def test_network_speed():
    st = speedtest.Speedtest()

    print("Finding best server...")
    st.get_best_server()

    print("Testing download speed...")
    download_speed = st.download()  # returns bits per second

    print("Testing upload speed...")
    upload_speed = st.upload()  # returns bits per second

    print("Ping:", st.results.ping, "ms")

    # Convert bits per second to Mbps
    download_mbps = download_speed / 1_000_000
    upload_mbps = upload_speed / 1_000_000

    print(f"Download Speed: {download_mbps:.2f} Mbps")
    print(f"Upload Speed: {upload_mbps:.2f} Mbps")

if __name__ == "__main__":
    test_network_speed()
