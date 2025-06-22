import json
import random

def load_flashcards(filename):
    with open(filename, 'r') as file:
        return json.load(file)

def flashcard_review(flashcards):
    print("Welcome to Flashcard Review! Type 'q' anytime to quit.\n")
    random.shuffle(flashcards)
    for card in flashcards:
        print(f"Q: {card['question']}")
        user_input = input("Press Enter to see the answer or 'q' to quit: ").strip().lower()
        if user_input == 'q':
            print("Exiting flashcards. Happy learning!")
            break
        print(f"A: {card['answer']}\n")
        input("Press Enter to continue...\n")

if __name__ == "__main__":
    flashcards = load_flashcards('flashcards.json')
    flashcard_review(flashcards)
