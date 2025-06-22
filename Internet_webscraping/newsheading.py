import requests

API_KEY = '58306fecb9054157b855a880c8aeb507'  # Replace with your NewsAPI key
BASE_URL = 'https://newsapi.org/v2/top-headlines'

# Country code (e.g., us, in, gb, ae, etc.)
country = input("Enter country code (e.g., us, in, ae): ").strip().lower()

params = {
    'apiKey': API_KEY,
    'country': country,
    'pageSize': 5  # Number of headlines to show
}

try:
    response = requests.get(BASE_URL, params=params)
    data = response.json()

    if response.status_code == 200 and data['status'] == 'ok':
        print(f"\nTop Headlines for country: {country.upper()}")
        for i, article in enumerate(data['articles'], start=1):
            print(f"{i}. {article['title']}")
    else:
        print("Error fetching news:", data.get('message', 'Unknown error'))

except Exception as e:
    print("An error occurred:", e)
