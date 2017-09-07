# Controls the definition and attributes of individual pieces
class Piece
  attr_accessor :color, :traits
  def initialize(color, type)
    @color = color
    @type = type
    self.actualize
  end

  private

# Builds the attributes of the piece based on type
  def actualize
    @traits = Hash.new
    @traits[:color] = @color
    @traits[:type] = @type
    self.send(@type)
  end

  def pawn
    if @traits[:color] == :white
      @traits[:move] = [[0,1]]
      @traits[:capture] = [[-1,1],[1,1]]
    else
      @traits[:move] = [[0,-1]]
      @traits[:capture] = [[-1,-1],[1,-1]]
    end
    @traits[:has_moved] = false
  end

  def king
    @traits[:move] = [[0,1], [0,-1], [-1,1], [1,1], [-1,-1], [1,-1], [1,0], [-1,0]]
    @traits[:capture] = @traits[:move]
    @traits[:has_castled] = false
  end
end
