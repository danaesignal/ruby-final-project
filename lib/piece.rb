
# Controls the definition and attributes of individual pieces
class Piece
  attr_reader :color, :type, :owner, :short_desc, :move_data, :can_move_to, :can_capture, :capture_data, :has_moved, :has_castled, :in_check
  def initialize(color, type, owner)
    @color = color
    @type = type
    @owner = owner
    actualize
  end

  private

  # Builds the attributes of the piece based on type
  def actualize
    @short_desc = "#{@color.to_s} #{@type.to_s}"
    @move_data = {n: [], ne: [], e: [], se: [], s: [], sw: [], w: [], nw: []}
    @can_move_to = []
    @can_capture = []
    self.send(@type)
  end

  # Contains attributes for pawns
  def pawn
    @capture_data = Hash.new
    if @color == :white
      @move_data[:n] << [0,1]
      @capture_data[:nw] == [-1,1]
      @capture_data[:ne] == [1,1]
    else
      @move_data[:n] << [0,-1]
      @capture_data[:sw] == [-1,-1]
      @capture_data[:se] == [1,-1]
    end
    @has_moved = false
  end

  # Contains attributes for kings
  def king
    @move_data[:n] << [0,1]
    @move_data[:ne] << [1,1]
    @move_data[:e] << [1,0]
    @move_data[:se] << [1,-1]
    @move_data[:s] << [0,-1]
    @move_data[:sw] << [-1,-1]
    @move_data[:w] << [-1,0]
    @move_data[:nw] << [-1,1]

    @has_castled = false
    @in_check = false
  end

  # Contains attributes for queens
  def queen
    # Cheaper than manually entering every permutation
    # Diagonal movement:
    for i in 1..7 do
      @move_data[:ne] << [i, i]
    end
    for i in 1..7 do
      @move_data[:se] << [i, i * (-1)]
    end
    for i in 1..7 do
      @move_data[:nw] << [i * (-1), i]
    end
    for i in 1..7 do
      @move_data[:sw] << [i * (-1), i * (-1)]
    end

    # Vertical and horizontal movement
    for i in 1..7 do
      @move_data[:n] << [0, i]
    end
    for i in 1..7 do
      @move_data[:s] << [0, i * -1]
    end
    for i in 1..7 do
      next if i == 0
      @move_data[:e] << [i, 0]
    end
    for i in 1..7 do
      next if i == 0
      @move_data[:w] << [i * -1, 0]
    end
  end

  # Contains attributes for rooks
  def rook
    # Vertical and horizontal movement
    for i in 1..7 do
      @move_data[:n] << [0, i]
    end
    for i in 1..7 do
      @move_data[:s] << [0, i * -1]
    end
    for i in 1..7 do
      next if i == 0
      @move_data[:e] << [i, 0]
    end
    for i in 1..7 do
      next if i == 0
      @move_data[:w] << [i * -1, 0]
    end
    
    @has_castled = false
  end

  # Contains attributes for bishops
  def bishop
    # Diagonal movement:
    for i in 1..7 do
      @move_data[:ne] << [i, i]
    end
    for i in 1..7 do
      @move_data[:se] << [i, i * (-1)]
    end
    for i in 1..7 do
      @move_data[:nw] << [i * (-1), i]
    end
    for i in 1..7 do
      @move_data[:sw] << [i * (-1), i * (-1)]
    end
  end

  # Contains attributes for knights, saying "Ni" optional
  def knight
    @move_data = [[1,2], [1,-2], [-1, 2], [-1,-2], [2,1], [2, -1], [-2, 1], [-2,-1]]
  end
end
