require_relative "board.rb"
require "yaml"
require "colorize"

class Chess
  attr_reader :gameboard, :current_turn

  def initialize
    @gameboard = Board.new
    @current_turn = :new_game
  end

  # Displays introductory screen and game options.
  def title_screen
    puts "Welcome to Chess!"
    valid_in = false

    while valid_in == false
      puts "[N]ew Game, or [C]ontinue?"
      u_input = gets.chomp.downcase
      if u_input == "c"
        puts "Loading game.."
        valid_in = true
        load_game
      else
        puts "New game!"
        valid_in = true
        end_of_turn
      end
    end
  end

  def save_game
    save_state = {
      board_state: @gameboard,
      curr_player: @current_turn
    }

    File.open("saved_game.yml", "w") {|f| f.write(save_state.to_yaml)}
  end

  def load_game
    unless File.exists?("saved_game.yml")
      puts "No saved game found. Starting new game!"
      end_of_turn
    else
      load_state = YAML.load(File.open("saved_game.yml"))

      @gameboard = load_state[:board_state]
      @current_turn = load_state[:curr_player]

      start_of_turn
    end
  end

  def start_of_turn
    # Call a method that displays the board here
    move_on = false

    @gameboard.print_board

    loop do
      break if move_on == true
      puts "#{current_turn.to_s.capitalize}, select a piece to move.\nYou may also [s]ave, s[a]ve and exit, or e[x]it without saving."

      u_input = gets.chomp

      case u_input
      when "s"
        # Save and then present choice again
        save_game
      when "a"
        # Save and exit
        save_game
        exit
      when "x"
        # Just exit
        exit
      else
        # Call a method that translates chess coords (i.e. 'a1')
        # If the coordinate is valid, call the method to start moving pieces
        # Otherwise, tell them it's invalid and present choice again

        translated_coords = translate(u_input)

        if translated_coords == false
          next
        else
          # Call the command to start movement
          movement_happened = movement(translated_coords)
          if movement_happened == false
            next
          else
            move_on = true
          end
        end
      end
    end
    @gameboard.print_board
    end_of_turn
  end

  def translate(u_input)
    x_index = ["INVALID","a","b","c","d","e","f","g","h"]
    translated_coords = Array.new
    translated_coords[0] = x_index.find_index(u_input[0])
    translated_coords[1] = u_input[1].to_i
    return translated_coords if @gameboard.data.keys.include?(translated_coords)
    return false
  end

  def movement(coords)
    if @gameboard.data[coords][:occupant].color == @current_turn
      if @gameboard.data[coords][:occupant].can_move_to.count > 0
        loop do
          puts "Please enter a destination."
          u_input = gets.chomp
          @destination = translate(u_input)
          if @destination == false
            puts "That location is invalid."
            next
          end
          unless @gameboard.data[coords][:occupant].can_move_to.include?(@destination)
            puts "That piece cannot reach that destination."
            next
          end
          @gameboard.move_piece(coords,@destination)
          return true
        end
      else
        return false
      end
    else
      return false
    end
  end

  def end_of_turn
    if @current_turn == :new_game
      @gameboard.build_board
      @gameboard.populate_board
    end

    @gameboard.white_set.data.each_value {|piece| @gameboard.generate_moves(piece)}
    @gameboard.black_set.data.each_value {|piece| @gameboard.generate_moves(piece)}
    @gameboard.king_move_list_cleanup

    @current_turn == :white ? @current_turn = :black : @current_turn = :white
  end
end
