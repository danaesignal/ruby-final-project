require "piece"
describe Piece do
  context "when initialized" do
    context "with :white :queen" do
      before(:each) do
        @test = Piece.new(:white, :queen)
      end
      it "should include the movement [1,1]" do
        expect(@test.traits[:move]).to include([1,1])
      end
      it "should include the movement [3,-3]" do
        expect(@test.traits[:move]).to include([3,-3])
      end
      it "should include the movement [-5,5]" do
        expect(@test.traits[:move]).to include([-5,5])
      end
      it "should include the movement [-7,-7]" do
        expect(@test.traits[:move]).to include([-7,-7])
      end

      it "should not include the movement [8,8]" do
        expect(@test.traits[:move]).not_to include([8,8])
      end

      it "should include the movement [0,-7]" do
        expect(@test.traits[:move]).to include([0,-7])
      end

      it "should include the movement [0,3]" do
        expect(@test.traits[:move]).to include([0,3])
      end

      it "should include the movement [-3,0]" do
        expect(@test.traits[:move]).to include([-3,0])
      end

      it "should include the movement [7,0]" do
        expect(@test.traits[:move]).to include([7,0])
      end

      it "should not include the movement [0,0]" do
        expect(@test.traits[:move]).not_to include([0,0])
      end

      it "should not include the movement [1,3]" do
        expect(@test.traits[:move]).not_to include([1,3])
      end

      it "should not include the movement [0,9]" do
        expect(@test.traits[:move]).not_to include([0,9])
      end

      it "should correctly self-identify as a white queen" do
        expect(@test.traits[:short_desc]).to eql("white queen")
      end
    end
  end
end
