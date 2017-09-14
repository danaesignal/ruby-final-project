require_relative "set"
# Controls the layout of the board, and what piece lies where
class Board
  attr_reader :data
  attr_reader :white_set
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
    end

    @black_set.data.each do |key, value|
      @data[key][:occupant] = value
    end
  end
end
