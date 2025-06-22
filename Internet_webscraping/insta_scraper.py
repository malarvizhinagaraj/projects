import instaloader

# Create instaloader instance
loader = instaloader.Instaloader()

# Get username from user
username = input("Enter Instagram username: ")

# Load profile
try:
    profile = instaloader.Profile.from_username(loader.context, username)

    print(f"\nName: {profile.full_name}")
    print(f"Username: {profile.username}")
    print(f"Bio: {profile.biography}")
    print(f"Followers: {profile.followers}")
    print(f"Following: {profile.followees}")
    print(f"Posts: {profile.mediacount}")
    print(f"Is Verified: {profile.is_verified}")
    print(f"Is Private: {profile.is_private}")

except Exception as e:
    print(f"Error: {e}")
