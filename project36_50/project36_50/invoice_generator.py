from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from reportlab.lib.units import mm
from datetime import datetime

def generate_invoice(customer_name, items, invoice_number):
    file_name = f"Invoice_{invoice_number}.pdf"
    c = canvas.Canvas(file_name, pagesize=A4)
    width, height = A4

    # Invoice title
    c.setFont("Helvetica-Bold", 20)
    c.drawString(30 * mm, height - 30 * mm, "INVOICE")

    # Invoice number and date
    c.setFont("Helvetica", 10)
    c.drawString(150 * mm, height - 30 * mm, f"Invoice #: {invoice_number}")
    c.drawString(150 * mm, height - 35 * mm, f"Date: {datetime.now().strftime('%Y-%m-%d')}")

    # Customer info
    c.setFont("Helvetica-Bold", 12)
    c.drawString(30 * mm, height - 45 * mm, "Bill To:")
    c.setFont("Helvetica", 12)
    c.drawString(30 * mm, height - 55 * mm, customer_name)

    # Table headers
    c.setFont("Helvetica-Bold", 12)
    c.drawString(30 * mm, height - 70 * mm, "Item")
    c.drawString(110 * mm, height - 70 * mm, "Qty")
    c.drawString(140 * mm, height - 70 * mm, "Price")
    c.drawString(170 * mm, height - 70 * mm, "Total")

    c.line(30 * mm, height - 72 * mm, 190 * mm, height - 72 * mm)

    # Table content
    c.setFont("Helvetica", 12)
    y = height - 80 * mm
    total_amount = 0

    for item, qty, price in items:
        total = qty * price
        total_amount += total
        c.drawString(30 * mm, y, item)
        c.drawString(110 * mm, y, str(qty))
        c.drawString(140 * mm, y, f"${price:.2f}")
        c.drawString(170 * mm, y, f"${total:.2f}")
        y -= 10 * mm

    c.line(30 * mm, y, 190 * mm, y)

    # Total amount
    c.setFont("Helvetica-Bold", 12)
    c.drawString(140 * mm, y - 10 * mm, "Total:")
    c.drawString(170 * mm, y - 10 * mm, f"${total_amount:.2f}")

    c.save()
    print(f"Invoice saved as {file_name}")

def main():
    print("Invoice Generator")
    customer_name = input("Enter customer name: ")

    items = []
    while True:
        item_name = input("Enter item description (or 'done' to finish): ")
        if item_name.lower() == 'done':
            break
        try:
            qty = int(input("Enter quantity: "))
            price = float(input("Enter price per item: "))
        except ValueError:
            print("Invalid input for quantity or price. Please try again.")
            continue
        items.append((item_name, qty, price))

    invoice_number = input("Enter invoice number: ")

    generate_invoice(customer_name, items, invoice_number)

if __name__ == "__main__":
    main()
