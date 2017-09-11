
# Controls the definition and attributes of individual pieces
class Piece
  attr_accessor :traits
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
    @traits[:short_desc] = "#{@color.to_s} #{@type.to_s}"
    @traits[:can_move_to] = []
    @traits[:can_capture] = []
    self.send(@type)
  end

  # Contains attributes for pawns
  def pawn
    if @traits[:color] == :white
      @traits[:move_data] = [[0,1]]
      @traits[:capture_data] = [[-1,1],[1,1]]
    else
      @traits[:move_data] = [[0,-1]]
      @traits[:capture_data] = [[-1,-1],[1,-1]]
    end
    @traits[:has_moved] = false
  end

  # Contains attributes for kings
  def king
    @traits[:move_data] = [[0,1], [0,-1], [-1,1], [1,1], [-1,-1], [1,-1], [1,0], [-1,0]]
    @traits[:capture_data] = @traits[:move_data]
    @traits[:has_castled] = false
    @traits[:in_check] = false
  end

  # Contains attributes for queens
  def queen
    @traits[:move_data] = []
    # Cheaper than manually entering every permutation
    # Diagonal movement:
    for i in 1..7 do
      @traits[:move_data] << [i, i]
    end
    for i in 1..7 do
      @traits[:move_data] << [i, i * (-1)]
    end
    for i in 1..7 do
      @traits[:move_data] << [i * (-1), i]
    end
    for i in 1..7 do
      @traits[:move_data] << [i * (-1), i * (-1)]
    end

    # Vertical and horizontal movement
    for i in -7..7 do
      @traits[:move_data] << [0, i] unless i == 0
    end
    for i in -7..7 do
      @traits[:move_data] << [i, 0] unless i == 0
    end

    @traits[:capture_data] = @traits[:move_data]
  end

  # Contains attributes for rooks
  def rook
    # Vertical and horizontal movement
    for i in -7..7 do
      @traits[:move_data] << [0, i] unless i == 0
    end
    for i in -7..7 do
      @traits[:move_data] << [i, 0] unless i == 0
    end

    @traits[:capture_data] = @traits[:move_data]
    @traits[:has_castled] = false
  end

  # Contains attributes for bishops
  def bishop
    # Diagonal movement:
    for i in 1..7 do
      @traits[:move_data] << [i, i]
    end
    for i in 1..7 do
      @traits[:move_data] << [i, i * (-1)]
    end
    for i in 1..7 do
      @traits[:move_data] << [i * (-1), i]
    end
    for i in 1..7 do
      @traits[:move_data] << [i * (-1), i * (-1)]
    end
    @traits[:capture_data] = @traits[:move_data]
  end

  # Contains attributes for knights, saying "Ni" optional
  def knight
    @traits[:move_data] = [[1,2], [1,-2], [-1, 2], [-1,-2], [2,1], [2, -1], [-2, 1], [-2,-1]]
    @traits[:capture_data] = @traits[:move_data]
  end
end
