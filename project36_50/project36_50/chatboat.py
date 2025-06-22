def rule_based_bot(user_input):
    user_input = user_input.lower()
    
    if "hello" in user_input or "hi" in user_input:
        return "Hello! How can I help you today?"
    elif "your name" in user_input:
        return "I am ChatCLI, your terminal chatbot!"
    elif "bye" in user_input:
        return "Goodbye! Have a nice day!"
    elif "help" in user_input:
        return "Sure! You can ask me simple questions like time, greeting, or about me."
    else:
        return "I'm not sure how to respond to that."

def main():
    print("🤖 Welcome to ChatCLI! (type 'exit' to quit)\n")
    while True:
        user_input = input("You: ")
        if user_input.lower() == 'exit':
            print("ChatCLI: Bye! 👋")
            break
        response = rule_based_bot(user_input)
        print(f"ChatCLI: {response}")

if __name__ == "__main__":
    main()
