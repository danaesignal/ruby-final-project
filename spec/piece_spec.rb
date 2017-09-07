require "piece"
describe Piece do
  context "when initialized" do
    it "should call the correct method" do
      @test = Piece.new
      expect(@test).to receive(:test)
      @test.fake_init(:test)
    end
  end
end
