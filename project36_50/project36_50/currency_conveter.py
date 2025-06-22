import requests

API_URL = "https://api.exchangerate-api.com/v4/latest/{}"

def get_rates(base_currency):
    try:
        response = requests.get(API_URL.format(base_currency.upper()))
        response.raise_for_status()
        data = response.json()
        return data['rates']
    except Exception as e:
        print(f"Error fetching rates: {e}")
        return None

def convert_currency(amount, from_currency, to_currency, rates):
    if to_currency.upper() not in rates:
        print(f"Currency '{to_currency}' not found in rates.")
        return None
    rate = rates[to_currency.upper()]
    return amount * rate

def main():
    print("Currency Converter")
    base_currency = input("Enter base currency code (e.g. USD): ").strip().upper()
    rates = get_rates(base_currency)
    if rates is None:
        return

    while True:
        try:
            amount = float(input("Enter amount to convert: "))
        except ValueError:
            print("Invalid amount.")
            continue
        
        to_currency = input("Convert to currency code (e.g. EUR): ").strip().upper()

        result = convert_currency(amount, base_currency, to_currency, rates)
        if result is not None:
            print(f"{amount} {base_currency} = {result:.4f} {to_currency}\n")

        cont = input("Convert another amount? (y/n): ").strip().lower()
        if cont != 'y':
            break

if __name__ == "__main__":
    main()
