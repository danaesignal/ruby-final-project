require_relative "set"
# Controls the layout of the board, and what piece lies where
class Board
  attr_reader :data, :white_set, :black_set

  def initialize
    @data = Hash.new
    @x_index = [nil,"a","b","c","d","e","f","g","h"]
  end

  # Contructs a hash with 64 definitions to serve as the board
  def build_board
    8.times do |y|
      8.times do |x|
        @data[[x+1,y+1]] = { :proper_name => "#{@x_index[x+1]}#{y+1}"}
      end
    end
  end

  # Calls :build_set from ::Set to build the list of pieces, then assigns them
  def populate_board
    @white_set = Set.new(:white, self)
    @black_set = Set.new(:black, self)

    @white_set.build_set
    @black_set.build_set

    @white_set.data.each do |key, value|
      @data[key][:occupant] = value
      value.type == :king ? @white_king = value : nil
    end

    @black_set.data.each do |key, value|
      @data[key][:occupant] = value
      value.type == :king ? @black_king = value : nil
    end
  end

  # Generates all legal moves and captures for non-pawn/knight pieces
  # Calls appropriate methods for pawns and knights
  def generate_moves(curr_piece)
    return generate_pawn_moves(curr_piece) if curr_piece.type == :pawn
    curr_piece.color == :white ? opposition = :black : opposition = :white
    curr_loc = curr_piece.owner.data.key(curr_piece)
    curr_piece.move_data.each do |k,v|
      v.each do |x|
        possible_move = [curr_loc[0] + x[0], curr_loc[1] + x[1]]
        next unless @data.keys.include?(possible_move)
        if @data[possible_move][:occupant] == nil
          curr_piece.can_move_to << possible_move
        elsif @data[possible_move][:occupant].color == opposition
          curr_piece.can_move_to << possible_move
          break
        else
          break
        end
      end
    end
  end

  # Generates the list of legal moves and captures for a pawn
  # Includes 'has-not-moved' bonus movement logic
  def generate_pawn_moves(curr_piece)
    curr_piece.color == :white ? opposition = :black : opposition = :white
    curr_loc = curr_piece.owner.data.key(curr_piece)
    curr_piece.can_move_to.clear
    # Copies pawn movement data to facilitate adding movement without modifying original data
    pawn_moves = curr_piece.move_data

    # Adds additional movement if pawn has not moved
    if curr_piece.has_moved == false
      curr_piece.color == :white ? pawn_moves[:n] << [0,2] : pawn_moves[:s] << [0,-2]
    end

    # Generates the list of allowable data
    pawn_moves.each do |k,v|
      v.each do |x|
        possible_move = [curr_loc[0] + x[0], curr_loc[1] + x[1]]
        next unless @data.keys.include?(possible_move)
        if @data[possible_move][:occupant] == nil
          curr_piece.can_move_to << possible_move
        else
          break
        end
      end
    end

    # Pawns have unique capture behavior
    curr_piece.capture_data.each do |k,v|
      # puts v.inspect
        possible_cap = [curr_loc[0] + v[0], curr_loc[1] + v[1]]
        next unless @data.keys.include?(possible_cap)
        next if @data[possible_cap][:occupant] == nil
        if @data[possible_cap][:occupant].color == opposition
          curr_piece.can_move_to << possible_cap
        end
    end

    # Needs to clear the movement data to ensure accuracy between iterations
    pawn_moves.clear
  end

  # Ensures that the kings cannot move into check, as per rules of chess
  def king_move_list_cleanup
    @white_set.data.each do |k,v|
      next if v.nil?
      v.can_move_to.each do |x|
        @black_king.can_move_to.delete(x)
      end
    end
    @black_set.data.each do |k,v|
      next if v.nil?
      v.can_move_to.each do |x|
        @white_king.can_move_to.delete(x)
      end
    end
  end
end
