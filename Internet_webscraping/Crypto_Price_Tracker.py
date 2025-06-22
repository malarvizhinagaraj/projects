import requests

def get_crypto_price(crypto_id="bitcoin", vs_currency="usd"):
    url = f"https://api.coingecko.com/api/v3/simple/price"
    params = {
        "ids": crypto_id,
        "vs_currencies": vs_currency
    }

    try:
        response = requests.get(url, params=params)
        response.raise_for_status()  # Raise exception for HTTP errors
        data = response.json()

        if crypto_id in data:
            price = data[crypto_id][vs_currency]
            print(f"💰 {crypto_id.capitalize()} price in {vs_currency.upper()}: {price}")
        else:
            print("❌ Invalid cryptocurrency ID. Try again.")
    except requests.exceptions.RequestException as e:
        print(f"⚠️ Error: {e}")

def main():
    print("📈 Welcome to the Crypto Price Tracker!")
    while True:
        crypto = input("Enter cryptocurrency (e.g., bitcoin, ethereum, dogecoin) or 'q' to quit: ").strip().lower()
        if crypto == 'q':
            break
        currency = input("Enter currency (default = usd): ").strip().lower()
        if not currency:
            currency = "usd"
        get_crypto_price(crypto, currency)

if __name__ == "__main__":
    main()
