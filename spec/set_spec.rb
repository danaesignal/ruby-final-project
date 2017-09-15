require "set"
describe Set do
  describe "#initialize" do
    it "should create an empty Hash 'data'" do
      @white_set = Set.new(:white, self)
      expect(@white_set.data.keys).to eql([])
      expect(@white_set.data.values).to eql([])
    end
  end
  context "should respond to" do
    before(:all) do
      @white_set = Set.new(:white, self)
    end
    it ":build_set" do
      expect(@white_set).to respond_to(:build_set)
    end

    it ":place_piece" do
      expect(@white_set).to respond_to(:place_piece)
    end

    it ":capture_piece" do
      expect(@white_set).to respond_to(:capture_piece)
    end
  end

  describe "#build_set" do
    before(:all) do
      @white_set = Set.new(:white, self)
      @white_set.build_set
      @black_set = Set.new(:black, self)
      @black_set.build_set
    end
    it "should place 16 white pieces" do
      expect(@white_set.data.keys.length).to eql(16)
    end
    it "should place eight black pawns" do
      expect(@black_set.data.values.count{|x| x.type == :pawn}).to eql(8)
    end
    it "should place two white rooks" do
      expect(@white_set.data.values.count{|x| x.type == :rook}).to eql(2)
    end
    it "should place two black bishops" do
      expect(@black_set.data.values.count{|x| x.type == :bishop}).to eql(2)
    end
    it "should place two white knights" do
      expect(@white_set.data.values.count{|x| x.type == :knight}).to eql(2)
    end
    it "should place one black king" do
      expect(@black_set.data.values.count{|x| x.type == :king}).to eql(1)
    end
    it "should place one white queen" do
      expect(@white_set.data.values.count{|x| x.type == :queen}).to eql(1)
    end
    it "should place a black queen on d8" do
      expect(@black_set.data[[4,8]].type).to eql(:queen)
    end
    it "should place a white queen on d1" do
      expect(@white_set.data[[4,1]].type).to eql(:queen)
    end
  end
  describe "#capture_piece" do
    before(:each) do
      @white_set = Set.new(:white, self)
      @white_set.build_set
    end
    it "should remove a piece from a valid location" do
      expect(@white_set.capture_piece([1,1])).to eql(true)
      expect(@white_set.data.keys.count).to eql(15)
      expect(@white_set.captured.count).to eql(1)
    end
    it "should return false when trying to capture an empty square" do
      expect(@white_set.capture_piece([8,8])).to eql(false)
      expect(@white_set.data.keys.count).to eql(16)
    end
  end
end
