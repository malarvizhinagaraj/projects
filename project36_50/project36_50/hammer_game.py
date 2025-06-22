import random

# List of words to guess
word_list = ["python", "developer", "hangman", "algorithm", "function", "variable"]

def get_valid_word(words):
    word = random.choice(words)
    while '-' in word or ' ' in word:
        word = random.choice(words)
    return word.upper()

def hangman():
    word = get_valid_word(word_list)
    word_letters = set(word)  # Unique letters in the word
    guessed_letters = set()
    alphabet = set("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    lives = 6

    print("🕹️ Welcome to Hangman!\n")

    while len(word_letters) > 0 and lives > 0:
        print(f"You have {lives} lives left.")
        print("Guessed letters:", " ".join(sorted(guessed_letters)))

        # Display current word status
        display_word = [letter if letter in guessed_letters else '_' for letter in word]
        print("Word: ", " ".join(display_word))

        user_guess = input("Guess a letter: ").upper()
        if user_guess in alphabet - guessed_letters:
            guessed_letters.add(user_guess)
            if user_guess in word_letters:
                word_letters.remove(user_guess)
                print("✅ Good guess!")
            else:
                lives -= 1
                print("❌ Incorrect.")
        elif user_guess in guessed_letters:
            print("⚠️ You already guessed that letter.")
        else:
            print("🚫 Invalid input.")

        print()

    # Game end
    if lives == 0:
        print(f"😵 You died! The word was: {word}")
    else:
        print(f"🎉 Congrats! You guessed the word: {word}")

if __name__ == "__main__":
    hangman()
