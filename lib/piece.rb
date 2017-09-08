
# Controls the definition and attributes of individual pieces
class Piece
  attr_accessor :color, :traits
  def initialize(color, type)
    @color = color
    @type = type
    actualize
  end

  private

  # Builds the attributes of the piece based on type
  def actualize
    @traits = Hash.new
    @traits[:color] = @color
    @traits[:type] = @type
    self.send(@type)
  end

  # Contains attributes for pawns
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

  # Contains attributes for kings
  def king
    @traits[:move] = [[0,1], [0,-1], [-1,1], [1,1], [-1,-1], [1,-1], [1,0], [-1,0]]
    @traits[:capture] = @traits[:move]
    @traits[:has_castled] = false
  end

  # Contains attributes for queens
  def queen
    @traits[:move] = []
    # Cheaper than manually entering every permutation
    # Diagonal movement:
    for i in 1..7 do
      @traits[:move] << [i, i]
    end
    for i in 1..7 do
      @traits[:move] << [i, i * (-1)]
    end
    for i in 1..7 do
      @traits[:move] << [i * (-1), i]
    end
    for i in 1..7 do
      @traits[:move] << [i * (-1), i * (-1)]
    end

    # Vertical and horizontal movement
    for i in -7..7 do
      @traits[:move] << [0, i] unless i == 0
    end
    for i in -7..7 do
      @traits[:move] << [i, 0] unless i == 0
    end

    @traits[:capture] = @traits[:move]
  end

  # Contains attributes for rooks
  def rook
    # Vertical and horizontal movement
    for i in -7..7 do
      @traits[:move] << [0, i] unless i == 0
    end
    for i in -7..7 do
      @traits[:move] << [i, 0] unless i == 0
    end

    @traits[:capture] = @traits[:move]
    @traits[:has_castled] = false
  end

  # Contains attributes for bishops
  def bishop
    # Diagonal movement:
    for i in 1..7 do
      @traits[:move] << [i, i]
    end
    for i in 1..7 do
      @traits[:move] << [i, i * (-1)]
    end
    for i in 1..7 do
      @traits[:move] << [i * (-1), i]
    end
    for i in 1..7 do
      @traits[:move] << [i * (-1), i * (-1)]
    end
    @traits[:capture] = @traits[:move]
  end
end
