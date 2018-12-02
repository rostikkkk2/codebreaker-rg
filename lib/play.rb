require_relative 'autoload'

class Play
  include TextMessages
  include Validation
  include ConsoleHelps

  def initialize(user_data)
    @secret_code = generate_secrete_code
    @secret_code_for_hints = @secret_code.clone
    @user = {
      name: user_data[:name],
      difficulty: user_data[:difficulty],
      attempts_total: user_data[:attempts_total],
      attempts_used: user_data[:attempts_used],
      hints_total: user_data[:hints_total],
      hints_used: user_data[:hints_used]
    }
    play_game
  end

  def play_game
    show_info(MESSAGE_GUESS_CODE)
    guess_code = gets.chomp.capitalize
    bye(guess_code)
    check_hint if guess_code == 'Hint'
    if is_valid_guess_code(guess_code)
      result_compare = compare_guess_and_secret_codes(guess_code)
      show_info(result_compare)
      play_game unless check_win(result_compare)
    else
      show_info('Unexpected command')
      play_game
    end
  end

  def check_hint
    @user[:hints_used] != @user[:hints_total] ? show_hint : show_info('You used all hints')
  end

  def show_hint
    @user[:hints_used] += 1
    rand_elem = @secret_code_for_hints.sample
    show_info(rand_elem)
    @secret_code_for_hints.delete_at(@secret_code_for_hints.index(rand_elem))
  end

  def check_win(compare_func)
    compare_func == '++++' ? win : check_lose
  end

  def win
    show_info("You win \nSecret_code is: #{@secret_code.join} \n")
    Db.new(@user)
    restart?
  end

  def restart?
    show_info('Do you want to restart game?')
    answer = gets.chomp.capitalize
    answer == 'Yes' ? Game.new : true
  end

  def check_lose
    @user[:attempts_used] += 1
    if @user[:attempts_used] == @user[:attempts_total]
      @user[:attempts_used] = 0
      @user[:hints_used] = 0
      show_info("You lose \nSecret_code is: #{@secret_code.join} \n")
      restart?
    end
  end

  def compare_guess_and_secret_codes(code)
    pluses = []
    minuses = []
    changed_s_code = @secret_code.clone
    code_arr = code.split('').map(&:to_i)
    changed_code_arr = code_arr
    code_arr.each_index do |i|
      next unless code_arr[i] == @secret_code[i]
      pluses.push('+')
      changed_s_code[i] = '+'
      changed_code_arr[i] = '-'
    end
    changed_code_arr.each_index do |i|
      changed_s_code.each_index do |j|
        next unless changed_code_arr[i] == changed_s_code[j]
        minuses.push('-')
        changed_s_code[j] = '+'
        changed_code_arr[i] = '-'
      end
    end
    p @secret_code
    (pluses + minuses).join('')
  end

  def generate_secrete_code
    4.times.map { rand(1..6) }
  end
end
