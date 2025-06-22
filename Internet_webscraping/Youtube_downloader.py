from pytube import YouTube

# Get URL from user
url = input("Enter the YouTube video URL: ")

# Create YouTube object
yt = YouTube(url)

# Download the highest resolution video
yt.streams.get_highest_resolution().download()

print("Download completed!")
