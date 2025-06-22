import requests

API_KEY = 'https://home.openweathermap.org '
BASE_URL = 'https://home.openweathermap.org/api_keys'

city = input("Enter city name: ")

params = {
    'q': city,
    'appid': API_KEY,
    'units': 'metric'
}

try:
    response = requests.get(BASE_URL, params=params)
    data = response.json()

    if response.status_code == 200:
        print(f"\nWeather in {data['name']}, {data['sys']['country']}:")
        print(f"Temperature: {data['main']['temp']}°C")
        print(f"Condition: {data['weather'][0]['description'].capitalize()}")
        print(f"Humidity: {data['main']['humidity']}%")
        print(f"Wind Speed: {data['wind']['speed']} m/s")
    else:
        print("City not found. Please check the name.")
except Exception as e:
    print("Error:", e)
