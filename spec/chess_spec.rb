require "chess.rb"
describe Chess do
  context "should respond to" do
    let(:game) {Chess.new}
    it ":end_of_turn" do
      expect(game).to respond_to(:end_of_turn)
    end
    it ":title_screen" do
      expect(game).to respond_to(:title_screen)
    end
    it ":load_game" do
      expect(game).to respond_to(:load_game)
    end
    it ":save_game" do
      expect(game).to respond_to(:save_game)
    end
  end

  describe ":load_game" do
    let(:game) {Chess.new}
    context "when no saved game exists" do
      it "should return false" do
        expect(game.load_game).to eql(false)
      end
    end
  end

  describe ":end_of_turn" do
    let(:game) {Chess.new}
    context "at the start of the game" do
      it "should populate the board" do
        game.end_of_turn
        expect(game.gameboard.white_set.data.keys.count).to eql(16)
        expect(game.gameboard.black_set.data.keys.count).to eql(16)
        expect(game.gameboard.black_set.data.values.count{|x| x.type == :pawn}).to eql(8)
        expect(game.gameboard.white_set.data.values.count{|x| x.type == :pawn}).to eql(8)
      end
      it "should set the current turn to :white" do
        game.end_of_turn
        expect(game.current_turn).to eql(:white)
      end
    end
    context "at the end of :white turn" do
      it "should set the turn to :black" do
        # Start the game and set the turn to :white
        game.end_of_turn
        # This should set it to black
        game.end_of_turn
        expect(game.current_turn).to eql(:black)
      end
    end
  end
end
