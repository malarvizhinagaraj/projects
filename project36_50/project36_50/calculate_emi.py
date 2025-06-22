def calculate_emi(principal, annual_interest_rate, tenure_years):
    monthly_rate = annual_interest_rate / (12 * 100)
    tenure_months = tenure_years * 12

    emi = (principal * monthly_rate * (1 + monthly_rate)**tenure_months) / ((1 + monthly_rate)**tenure_months - 1)
    return emi

def print_emi_schedule(principal, annual_interest_rate, tenure_years):
    emi = calculate_emi(principal, annual_interest_rate, tenure_years)
    monthly_rate = annual_interest_rate / (12 * 100)
    tenure_months = tenure_years * 12
    balance = principal

    print(f"Loan Amount: {principal}")
    print(f"Annual Interest Rate: {annual_interest_rate}%")
    print(f"Tenure: {tenure_years} years ({tenure_months} months)")
    print(f"Monthly EMI: {emi:.2f}\n")
    print("Month | EMI Amount | Interest Paid | Principal Paid | Remaining Balance")
    print("-" * 70)

    for month in range(1, tenure_months + 1):
        interest = balance * monthly_rate
        principal_paid = emi - interest
        balance -= principal_paid
        if balance < 0:
            balance = 0  # Avoid negative balance due to rounding

        print(f"{month:5} | {emi:10.2f} | {interest:13.2f} | {principal_paid:14.2f} | {balance:17.2f}")

if __name__ == "__main__":
    principal = float(input("Enter loan amount: "))
    annual_interest_rate = float(input("Enter annual interest rate (in %): "))
    tenure_years = int(input("Enter tenure (in years): "))

    print_emi_schedule(principal, annual_interest_rate, tenure_years)
