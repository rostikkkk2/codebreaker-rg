module TextMessages

  WELCOM = (
    "Welcome to Codebreaker!" + "\n"
  )

  CHOOSE_OPTION = (
    "\n" + "Choose option one of several possible scenarios:" + "\n" +
    "start, rules, stats, exit." + "\n "
  )

  WRONG_INPUT_OPTION = (
    "You have passed unexpected command. Please choose one from listed commands" + "\n"
  )

  MESSAGE_RULES = (
      "\nCodebreaker is a logic game in which a code-breaker tries to break a secret code created by a code-maker. " + "\n" +
      "The codemaker, which will be played by the application we’re going to write," + "\n" +
      "creates a secret code of four numbers between 1 and 6." + "\n" +
      "The codebreaker gets some number of chances to break the code (depends on chosen difficulty)." + "\n" +
      "In each turn, the codebreaker makes a guess of 4 numbers." + "\n" +
      "The codemaker then marks the guess with up to 4 signs - + or - or empty spaces." + "\n" +
      "A + indicates an exact match: one of the numbers in the guess is the same as one of the numbers," + "\n" +
      "in the secret code and in the same position." + "\n" +
      "For example: " + "\n" +
      "Secret number - 1234 " + "\n" +
      "Input number - 6264 " + "\n" +
      "Number of pluses - 2 (second and fourth position)" + "\n" +
      "A - indicates a number match:" + "\n" +
      "one of the numbers in the guess is the same as one of the numbers, " + "\n" +
      "in the secret code but in a different position." + "\n" +
      "For example:" + "\n" +
      "Secret number - 1234" + "\n" +
      "Input number - 6462" + "\n" +
      "Number of minuses - 2 (second and fourth position)" + "\n" +
      "An empty space indicates that there is not a current digit in a secret number." + "\n" +
      "If codebreaker inputs the exact number as a secret number" + "\n" +
      "- codebreaker wins the game. If all attempts are spent - codebreaker loses." + "\n" +
      "Codebreaker also has some number of hints(depends on chosen difficulty)." + "\n" +
      "If a user takes a hint - he receives back a separate digit of the secret code." + "\n"
    )

    MESSAGE_CHOOSE_DIFFICULTY = (
      "\n" + "Choose your difficulty:" + "\n" +
      "Easy - 15 attempts. 2 hints" + "\n" +
      "Medium - 10 attempts. 1 hint" + "\n" +
      "Hell - 5 attempts. 1 hint" + "\n"
    )

    MESSAGE_GUESS_CODE = ("guess of secret code! You can take hint or exit" + "\n")

    GOODBYE_MESSAGE = ("goodbye")

end
