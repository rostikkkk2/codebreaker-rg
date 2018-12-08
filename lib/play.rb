class Play
  include Validation
  include ConsoleHelps

  def initialize(user_data)
    @secret_code = generate_secrete_code
    @secret_code_for_hints = @secret_code.clone
    @user = user_data
  end

  def play_game
    show_info(:message_guess_code)
    guess_code = gets.chomp.capitalize
    bye(guess_code)
    check_hint if guess_code == 'Hint'
    if validate_value_right_range?(guess_code, 1, 6) && validate_right_length?(guess_code, 4)
      result_compare = compare_guess_and_secret_codes(guess_code)
      show_info_without_i18(result_compare)
      play_game unless check_win(result_compare)
    else
      show_info(:unexpected_command)
      play_game
    end
  end

  def check_hint
    @user[:hints_used] != @user[:hints_total] ? show_hint : show_info(:used_all_hints)
  end

  def show_hint
    @user[:hints_used] += 1
    rand_elem = @secret_code_for_hints.sample
    show_info_without_i18(rand_elem)
    @secret_code_for_hints.delete_at(@secret_code_for_hints.index(rand_elem))
  end

  def check_win(compare_func)
    compare_func == '++++' ? win : check_lose
  end

  def win
    show_info_without_i18(I18n.t(:win) + "#{@secret_code.join} \n")
    db = Db.new(@user)
    db.save
    restart?
  end

  def restart?
    show_info(:restart)
    answer = gets.chomp.capitalize
    Console.new.check_option if answer == 'Yes'
    true
  end

  def check_lose
    @user[:attempts_used] += 1
    if @user[:attempts_used] == @user[:attempts_total]
      @user[:attempts_used] = 0
      @user[:hints_used] = 0
      show_info_without_i18(I18n.t(:lose) + "#{@secret_code.join} \n")
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
