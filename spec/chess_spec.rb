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
    it ":start_of_turn" do
      expect(game).to respond_to(:start_of_turn)
    end
    it ":translate" do
      expect(game).to respond_to(:translate)
    end
  end

  describe ":title_screen" do
    let(:game) {Chess.new}
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

  describe ":start_of_turn" do
    let(:game){Chess.new}
    context "during :white turn" do
      it "should ask :white to select a piece" do
        expect(game).to receive(:puts).with("White, select a piece to move.\nYou may also [s]ave, s[a]ve and exit, or e[x]it without saving.")
        allow(game).to receive(:loop).and_yield
        game.end_of_turn
        game.start_of_turn
      end
    end
    context "when the user inputs s" do
      it "should save the game" do
        expect(File).to receive(:open)
        allow(game).to receive(:loop).and_yield
        allow(game).to receive(:gets){"s"}
        allow(game).to receive(:puts)
        game.end_of_turn
        game.start_of_turn
      end
    end
    context "when the user inputs a" do
      it "should save the game and exit" do
        expect(File).to receive(:open)
        expect(game).to receive(:exit)
        allow(game).to receive(:loop).and_yield
        allow(game).to receive(:gets){"a"}
        allow(game).to receive(:puts)
        game.end_of_turn
        game.start_of_turn
      end
    end
    context "when the user inputs x" do
      it "should exit" do
        expect(game).to receive(:exit)
        allow(game).to receive(:loop).and_yield
        allow(game).to receive(:gets){"x"}
        allow(game).to receive(:puts)
        game.end_of_turn
        game.start_of_turn
      end
    end
    context "when the user inputs b1" do
      it "and c3 it moves a knight" do
        game.end_of_turn
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return("b1","c3")
        game.start_of_turn
        expect(game.gameboard.data[[3,3]][:occupant].type).to eql(:knight)
      end
      it "and c4 it doesn't move a knight" do
        game.end_of_turn
        allow(game).to receive(:puts)        
        allow(game).to receive(:gets).and_return("b1","c4")
        allow(game).to receive(:loop).and_yield
        game.start_of_turn
        expect(game.gameboard.data[[2,1]][:occupant].type).to eql(:knight)
      end
    end
  end

  describe ":translate" do
    let(:game) {Chess.new}
    it "takes a1 and returns [1,1]" do
      game.end_of_turn
      expect(game.translate("a1")).to eql([1,1])
    end
    it "takes z11 and returns false" do
      game.end_of_turn
      expect(game.translate("z11")).to eql(false)
    end
  end

  describe ":movement" do
    let(:game) {Chess.new}
    context "a white knight on b1" do
      it "can move to empty square c3" do
        game.end_of_turn
        allow(game).to receive(:puts)
        allow(game).to receive(:gets){"c3"}
        game.movement([2,1])
        expect(game.gameboard.data[[3,3]][:occupant].type).to eql(:knight)
      end
      it "cannot move to a white pawn occupied c3" do
        game.end_of_turn
        game.gameboard.move_piece([2,2],[3,3])
        game.end_of_turn
        game.end_of_turn
        allow(game).to receive(:loop).and_yield
        allow(game).to receive(:puts)
        allow(game).to receive(:gets){"c3"}
        game.movement([2,1])
        expect(game.gameboard.data[[3,3]][:occupant].type).to eql(:pawn)
      end
      it "can capture a black pawn in c3" do
        game.end_of_turn
        game.gameboard.move_piece([7,7],[3,3])
        game.end_of_turn
        game.end_of_turn
        allow(game).to receive(:puts)
        allow(game).to receive(:gets){"c3"}
        game.movement([2,1])
        expect(game.gameboard.data[[3,3]][:occupant].type).to eql(:knight)
      end
      it "cannot move to empty square d3" do
        game.end_of_turn
        allow(game).to receive(:puts)
        allow(game).to receive(:gets){"d3"}
        allow(game).to receive(:loop).and_yield
        game.movement([2,1])
        expect(game.gameboard.data[[4,3]][:occupant]).to eql(nil)
      end
    end

    context "a black pawn on b7" do
      it "can move to empty square b6" do
        game.end_of_turn
        game.end_of_turn
        allow(game).to receive(:puts)
        allow(game).to receive(:gets){"b6"}
        game.movement([2,7])
        expect(game.gameboard.data[[2,6]][:occupant]).to_not eql(nil)
      end
      it "cannot move to a white pawn occupied b6" do
        game.end_of_turn
        game.gameboard.move_piece([2,2],[2,6])
        game.end_of_turn

        allow(game).to receive(:puts)
        allow(game).to receive(:gets){"b6"}
        game.movement([2,7])
        expect(game.gameboard.data[[2,6]][:occupant].color).to eql(:white)
      end
      it "can capture a white pawn in c6" do
        game.end_of_turn
        game.gameboard.move_piece([2,2],[3,6])
        game.end_of_turn

        allow(game).to receive(:puts)
        allow(game).to receive(:gets){"c6"}
        game.movement([2,7])
        expect(game.gameboard.data[[3,6]][:occupant].color).to eql(:black)
      end
      it "cannot move to empty square b3" do
        game.end_of_turn
        game.end_of_turn
        allow(game).to receive(:puts)
        allow(game).to receive(:gets){"b3"}
        allow(game).to receive(:loop).and_yield
        game.movement([2,7])
        expect(game.gameboard.data[[3,3]][:occupant]).to eql(nil)
      end
    end
  end
end
