require_relative "piece"
# Controls the creation and assignment of pieces in a complete set.
class Set
  attr_reader :data, :captured

  def initialize(color, parent)
    @color = color
    @parent = parent
    @data = Hash.new
    @captured = []
  end

  # Populates the board, placing pieces based on color and type
  def build_set
    if @color == :black
      # Rooks
      place_piece([1,8],@color, :rook)
      place_piece([8,8],@color, :rook)
      # Knights
      place_piece([2,8],@color, :knight)
      place_piece([7,1],@color, :knight)
      # Bishops
      place_piece([3,8],@color, :bishop)
      place_piece([6,8],@color, :bishop)
      # King
      place_piece([4,8],@color, :king)
      # Queen
      place_piece([5,8],@color, :queen)
      # Pawns
      place_piece([1,7],@color,:pawn)
      place_piece([2,7],@color,:pawn)
      place_piece([3,7],@color,:pawn)
      place_piece([4,7],@color,:pawn)
      place_piece([5,7],@color,:pawn)
      place_piece([6,7],@color,:pawn)
      place_piece([7,7],@color,:pawn)
      place_piece([8,7],@color,:pawn)
    else
      # Rooks
      place_piece([1,1],@color, :rook)
      place_piece([8,1],@color, :rook)
      # Knights
      place_piece([2,1],@color, :knight)
      place_piece([7,1],@color, :knight)
      # Bishops
      place_piece([3,1],@color, :bishop)
      place_piece([6,1],@color, :bishop)
      # King
      place_piece([4,1],@color, :king)
      # Queen
      place_piece([5,1],@color, :queen)
      # Pawns
      place_piece([1,2],@color,:pawn)
      place_piece([2,2],@color,:pawn)
      place_piece([3,2],@color,:pawn)
      place_piece([4,2],@color,:pawn)
      place_piece([5,2],@color,:pawn)
      place_piece([6,2],@color,:pawn)
      place_piece([7,2],@color,:pawn)
      place_piece([8,2],@color,:pawn)
    end
  end

  def place_piece(location, color, piece)
    @data[location] = Piece.new(color, piece, self)
  end

  def capture_piece(location)
    if @data[location]
      @captured << @data[location]
      @data.delete(location)
      return true
    else
      return false
    end
  end
end
#
# white_set = Set.new(:white, self)
#
# white_set.build_set
#
# puts white_set.data
