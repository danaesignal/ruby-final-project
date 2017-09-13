class Board
  attr_reader :data
  def initialize
    @data = Hash.new
    @x_index = [nil,"a","b","c","d","e","f","g","h"]
  end

  def build_board
    8.times do |y|
      8.times do |x|
        @data[[x+1,y+1]] = { :proper_name => "#{@x_index[x+1]}#{y+1}"}
      end
    end
  end
end
