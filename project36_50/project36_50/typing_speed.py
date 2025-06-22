import time
import random

# Sample sentences
prompts = [
    "The quick brown fox jumps over the lazy dog.",
    "Python is a popular programming language for beginners.",
    "Artificial intelligence is transforming the world rapidly.",
    "Practice makes perfect, especially in coding.",
    "Typing fast and accurately is a useful skill."
]

def calculate_wpm(start_time, end_time, typed_text):
    time_taken = end_time - start_time  # in seconds
    word_count = len(typed_text.split())
    wpm = (word_count / time_taken) * 60
    return round(wpm, 2)

def calculate_accuracy(original, typed):
    original_words = original.split()
    typed_words = typed.split()
    correct = 0

    for o, t in zip(original_words, typed_words):
        if o == t:
            correct += 1

    total = len(original_words)
    accuracy = (correct / total) * 100
    return round(accuracy, 2)

def main():
    prompt = random.choice(prompts)
    print("⚡ Typing Speed Test ⚡\n")
    print("Type the following paragraph exactly:\n")
    print(f"👉 {prompt}\n")
    input("Press Enter when you're ready...")

    print("\nStart typing below:\n")
    start_time = time.time()
    typed_text = input()
    end_time = time.time()

    wpm = calculate_wpm(start_time, end_time, typed_text)
    accuracy = calculate_accuracy(prompt, typed_text)

    print("\n📝 Results:")
    print(f"Speed   : {wpm} WPM")
    print(f"Accuracy: {accuracy}%")

if __name__ == "__main__":
    main()
