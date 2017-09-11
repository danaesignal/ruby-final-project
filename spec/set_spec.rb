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
    end
    it "should place 16 pieces" do
      expect(@white_set.data.keys.length).to eql(16)
    end
    it "should place eight pawns" do
      expect(@white_set.data.values.count{|x| x.traits[:type] == :pawn}).to eql(8)
    end
    it "should place two rooks" do
      expect(@white_set.data.values.count{|x| x.traits[:type] == :rook}).to eql(2)
    end
    it "should place two bishops" do
      expect(@white_set.data.values.count{|x| x.traits[:type] == :bishop}).to eql(2)
    end
    it "should place two knights" do
      expect(@white_set.data.values.count{|x| x.traits[:type] == :knight}).to eql(2)
    end
    it "should place one king" do
      expect(@white_set.data.values.count{|x| x.traits[:type] == :king}).to eql(1)
    end
    it "should place one queen" do
      expect(@white_set.data.values.count{|x| x.traits[:type] == :queen}).to eql(1)
    end
  end
end
