require "set"
describe Set do
  context "When created" do
    before(:each) do
      @white_set = Set.new(:white)
    end
    it "should create an empty Hash 'traits'" do
      expect(@white_set.traits.keys).to eql([])
      expect(@white_set.traits.values).to eql([])
    end

    context "should respond to" do
      it ":build_set" do
        expect(@white_set).to respond_to(:build_set)
      end

      it ":place_pawn" do
        expect(@white_set).to respond_to(:build_set)
      end

      it ":place_rook" do
        expect(@white_set).to respond_to(:build_set)
      end

      it ":place_bishop" do
        expect(@white_set).to respond_to(:build_set)
      end

      it ":place_knight" do
        expect(@white_set).to respond_to(:build_set)
      end

      it ":place_king" do
        expect(@white_set).to respond_to(:build_set)
      end

      it ":place_queen" do
        expect(@white_set).to respond_to(:build_set)
      end

      it ":capture_piece" do
        expect(@white_set).to respond_to(:build_set)
      end
    end
  end
end
