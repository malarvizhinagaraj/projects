import re

def parse_receipt(text):
    # Patterns for common fields
    date_pattern = r'(\d{2}[/-]\d{2}[/-]\d{4})'  # matches dates like 12/05/2023 or 12-05-2023
    total_pattern = r'(total|amount|balance)[^\d]*(\d+[\.,]?\d*)'  # find 'total' followed by amount
    vendor_pattern = r'(?<=Vendor:)(.*)'  # assume line starts with "Vendor:" 

    # Extract date
    dates = re.findall(date_pattern, text, re.IGNORECASE)
    date = dates[0] if dates else "Not found"

    # Extract total amount
    totals = re.findall(total_pattern, text, re.IGNORECASE)
    total = totals[-1][1] if totals else "Not found"  # take last total-like number

    # Extract vendor
    vendor_match = re.search(vendor_pattern, text, re.IGNORECASE)
    vendor = vendor_match.group(1).strip() if vendor_match else "Not found"

    return {
        "Date": date,
        "Total Amount": total,
        "Vendor": vendor,
    }

if __name__ == "__main__":
    print("Enter receipt text (paste your receipt text, then press Enter twice):")
    lines = []
    while True:
        line = input()
        if line == "":
            break
        lines.append(line)
    receipt_text = "\n".join(lines)

    parsed_data = parse_receipt(receipt_text)
    print("\nParsed Receipt Data:")
    for k, v in parsed_data.items():
        print(f"{k}: {v}")
