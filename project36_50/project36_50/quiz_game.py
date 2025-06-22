import json

def load_questions(filename):
    with open(filename, 'r') as file:
        return json.load(file)

def run_quiz(questions):
    score = 0
    for i, q in enumerate(questions, 1):
        print(f"\nQuestion {i}: {q['question']}")
        for option in q['options']:
            print(option)
        
        answer = input("Your answer (A/B/C/D): ").strip().upper()
        if answer == q['answer']:
            print("Correct!")
            score += 1
        else:
            print(f"Wrong! The correct answer was {q['answer']}.")

    print(f"\nQuiz completed! Your score: {score} out of {len(questions)}")

if __name__ == "__main__":
    questions = load_questions('quiz_questions.json')
    run_quiz(questions)
