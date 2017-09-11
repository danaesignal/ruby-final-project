require "piece"
class Set
  attr_accessor :traits

  def initialize(color)
    @color = color
    @traits = Hash.new
  end

  def build_set
  end

  def place_pawn
  end

  def place_rook
  end

  def place_bishop
  end

  def place_knight
  end

  def place_king
  end

  def place_queen
  end

  def capture_piece
  end
end
