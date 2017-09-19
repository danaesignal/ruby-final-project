require_relative "piece"
# Controls the creation and assignment of pieces in a complete set.
class Set
  attr_accessor :data, :captured

  def initialize(color, parent)
    @color = color
    @parent = parent
    @data = Hash.new
    @captured = []
  end

  # Populates the board, placing pieces based on color and type
  def build_set
    white_locs = [[1,1],[8,1],[2,1],[7,1],[3,1],[6,1],[4,1],[5,1],[1,2],[2,2],[3,2],[4,2],[5,2],[6,2],[7,2],[8,2]]
    black_locs = [[1,8],[8,8],[2,8],[7,8],[3,8],[6,8],[4,8],[5,8],[1,7],[2,7],[3,7],[4,7],[5,7],[6,7],[7,7],[8,7]]
    piece_order =[:rook,:rook,:knight,:knight,:bishop,:bishop,:queen,:king,:pawn,:pawn,:pawn,:pawn,:pawn,:pawn,:pawn,:pawn]

    active_locs = @color == :white ? white_locs : black_locs
    active_locs.each_with_index do |loc, index|
      place_piece(loc,@color,piece_order[index])
    end
  end

  # Method for placing new pieces; primarily used in building a set
  # But also used when promoting a pawn
  def place_piece(location, color, piece)
    @data[location] = Piece.new(color, piece, self)
  end

  # Method for removing a piece from active play; primary used during capture
  # But also used to remove a pawn after promotion
  def capture_piece(location, promotion=false)
    if @data[location]
      promotion == false ? @captured << @data[location] : nil
      @data.delete(location)
      return true
    else
      return false
    end
  end
end
