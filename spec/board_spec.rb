require "board"
describe Board do
  before(:each) do
    @gameboard = Board.new
  end
  it "should respond to :build_board" do
    expect(@gameboard).to respond_to(:build_board)
  end
  context ":build_board" do
    before(:each) do
      @gameboard.build_board
    end
    it "should create 64 squares" do
      expect(@gameboard.data.keys.count).to eql(64)
    end
    it "should assign coordinates as keys" do
      expect(@gameboard.data.keys.include?([1,1])).to eql(true)
      expect(@gameboard.data.keys.include?([2,2])).to eql(true)
      expect(@gameboard.data.keys.include?([3,3])).to eql(true)
      expect(@gameboard.data.keys.include?([4,4])).to eql(true)
      expect(@gameboard.data.keys.include?([5,5])).to eql(true)
      expect(@gameboard.data.keys.include?([6,6])).to eql(true)
      expect(@gameboard.data.keys.include?([7,7])).to eql(true)
      expect(@gameboard.data.keys.include?([8,8])).to eql(true)
    end
    it "should associate coordinates with string names" do
      expect(@gameboard.data[[1,1]][:proper_name]).to eql("a1")
      expect(@gameboard.data[[2,2]][:proper_name]).to eql("b2")
      expect(@gameboard.data[[3,3]][:proper_name]).to eql("c3")
      expect(@gameboard.data[[4,4]][:proper_name]).to eql("d4")
      expect(@gameboard.data[[5,5]][:proper_name]).to eql("e5")
      expect(@gameboard.data[[6,6]][:proper_name]).to eql("f6")
      expect(@gameboard.data[[7,7]][:proper_name]).to eql("g7")
      expect(@gameboard.data[[8,8]][:proper_name]).to eql("h8")
    end
  end
end
