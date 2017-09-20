require "board"
describe Board do
  before(:each) do
    @gameboard = Board.new
  end

  context "should respond to" do
    it ":build_board" do
      expect(@gameboard).to respond_to(:build_board)
    end
    it ":populate_board" do
      expect(@gameboard).to respond_to(:populate_board)
    end
    it ":generate_moves" do
      expect(@gameboard).to respond_to(:generate_moves)
    end
    it ":remove_piece" do
      expect(@gameboard).to respond_to(:remove_piece).with(1).argument
    end
    it ":move_piece" do
      expect(@gameboard).to respond_to(:move_piece).with(2).argument
    end
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

  context ":populate_board" do
    before(:each) do
      @gameboard.build_board
      @gameboard.populate_board
    end
    it "should place a white rook on a1" do
      expect(@gameboard.data[[1,1]][:occupant].type).to eql(:rook)
      expect(@gameboard.data[[1,1]][:occupant].color).to eql(:white)
    end
    it "should place a black rook on h8" do
      expect(@gameboard.data[[8,8]][:occupant].type).to eql(:rook)
      expect(@gameboard.data[[8,8]][:occupant].color).to eql(:black)
    end
    it "should place a white knight on b1" do
      expect(@gameboard.data[[2,1]][:occupant].type).to eql(:knight)
      expect(@gameboard.data[[2,1]][:occupant].color).to eql(:white)
    end
    it "should place a black knight on g8" do
      expect(@gameboard.data[[7,8]][:occupant].type).to eql(:knight)
      expect(@gameboard.data[[7,8]][:occupant].color).to eql(:black)
    end
    it "should place a white bishop on b1" do
      expect(@gameboard.data[[3,1]][:occupant].type).to eql(:bishop)
      expect(@gameboard.data[[3,1]][:occupant].color).to eql(:white)
    end
    it "should place a black bishop on g8" do
      expect(@gameboard.data[[6,8]][:occupant].type).to eql(:bishop)
      expect(@gameboard.data[[6,8]][:occupant].color).to eql(:black)
    end
    it "should place a white queen on d1" do
      expect(@gameboard.data[[4,1]][:occupant].type).to eql(:queen)
      expect(@gameboard.data[[4,1]][:occupant].color).to eql(:white)
    end
    it "should place a black king on e8" do
      expect(@gameboard.data[[5,8]][:occupant].type).to eql(:king)
      expect(@gameboard.data[[5,8]][:occupant].color).to eql(:black)
    end

    it "should place 16 pawns" do
      placed_pieces = @gameboard.data.select{|k,v| v.include?(:occupant)}
      expect(placed_pieces.select{|k,v| v[:occupant].type==:pawn}.count).to eql(16)
    end
  end

  describe ":generate_moves" do
    before(:each) do
      @gameboard = Board.new
      @gameboard.build_board
      @gameboard.populate_board
    end
    context "for pawns" do
      it "should identify if it is a pawn" do
        expect(@gameboard).to receive(:generate_pawn_moves)
        @gameboard.generate_moves(@gameboard.data[[2,2]][:occupant])
      end
      it "should add [2,3] to the pawn's list" do
        @gameboard.generate_pawn_moves(@gameboard.data[[2,2]][:occupant])
        expect(@gameboard.data[[2,2]][:occupant].can_move_to).to include([2,3])
      end
      it "should add [2,4] to the pawn's list if it hasn't moved" do
        @gameboard.generate_pawn_moves(@gameboard.data[[2,2]][:occupant])
        expect(@gameboard.data[[2,2]][:occupant].can_move_to).to include([2,4])
      end
      it "should not add [2,4] to the pawn's list if it has moved" do
        @gameboard.generate_pawn_moves(@gameboard.data[[2,2]][:occupant])
        @gameboard.data[[2,2]][:occupant].has_moved = true
        @gameboard.generate_pawn_moves(@gameboard.data[[2,2]][:occupant])
        expect(@gameboard.data[[2,2]][:occupant].can_move_to).to_not include([2,4])
      end
      it "should add [1,3] to the pawn's list to capture an enemy" do
        pawn = double("Piece", type: :pawn, color: :black)
        @gameboard.data[[1,3]][:occupant] = pawn
        @gameboard.generate_pawn_moves(@gameboard.data[[2,2]][:occupant])
        expect(@gameboard.data[[2,2]][:occupant].can_move_to).to include([1,3])
      end

      it "should not add [1,3] to the pawn's list to capture an ally" do
        pawn = double("Piece", :type => :pawn, :color => :white)
        @gameboard.data[[1,3]][:occupant] = pawn
        @gameboard.generate_pawn_moves(@gameboard.data[[2,2]][:occupant])
        expect(@gameboard.data[[2,2]][:occupant].can_move_to).to_not include([1,3])
      end
    end

    context "for knights" do
      it "should identify the piece as a knight" do
        expect(@gameboard).to receive(:generate_knight_moves)
        @gameboard.generate_moves(@gameboard.data[[2,1]][:occupant])
      end
      context "a white knight in B1" do
        it "should generate two legal moves with all pieces at default" do
          @gameboard.generate_moves(@gameboard.data[[2,1]][:occupant])
          expect(@gameboard.data[[2,1]][:occupant].can_move_to.length).to eql(2)
        end
        it "should be able to capture a black pawn in C3" do
          @gameboard.move_piece([1,7],[3,3])
          @gameboard.generate_moves(@gameboard.data[[2,1]][:occupant])
          expect(@gameboard.data[[2,1]][:occupant].can_move_to).to include([3,3])
        end
        it "should not be able to move to C3 if a white pawn is there" do
          @gameboard.move_piece([1,2],[3,3])
          @gameboard.generate_moves(@gameboard.data[[2,1]][:occupant])
          expect(@gameboard.data[[2,1]][:occupant].can_move_to).to_not include([3,3])
        end
      end
    end
    context "for rooks" do
      it "should not add moves to a blocked rook's list" do
        @gameboard.generate_moves(@gameboard.data[[1,1]][:occupant])
        expect(@gameboard.data[[1,1]][:occupant].can_move_to).to_not include([1,2])
      end
      it "should add [1,2] to a1 rook if a2 pawn removed" do
        @gameboard.data[[1,2]][:occupant] = nil
        @gameboard.generate_moves(@gameboard.data[[1,1]][:occupant])
        expect(@gameboard.data[[1,1]][:occupant].can_move_to).to include([1,2])
      end
      it "shoud allow a1 rook to capture a7 if not blocked" do
        @gameboard.data[[1,2]][:occupant] = nil
        @gameboard.generate_moves(@gameboard.data[[1,1]][:occupant])
        expect(@gameboard.data[[1,1]][:occupant].can_move_to).to include([1,7])
      end
      it "shoud allow a1 rook to capture a2 if enemy pawn present" do
        pawn = double("Piece", :type => :pawn, :color => :black)
        @gameboard.data[[1,2]][:occupant] = pawn
        @gameboard.generate_moves(@gameboard.data[[1,1]][:occupant])
        expect(@gameboard.data[[1,1]][:occupant].can_move_to).to include([1,2])
      end
      it "shoud not allow a1 rook to capture a7 if enemy pawn present at a2" do
        pawn = double("Piece", :type => :pawn, :color => :black)
        @gameboard.data[[1,2]][:occupant] = pawn
        @gameboard.generate_moves(@gameboard.data[[1,1]][:occupant])
        expect(@gameboard.data[[1,1]][:occupant].can_move_to).to_not include([1,7])
      end
    end
  end

  describe ":king_move_list_cleanup" do
    before(:each) do
      @gameboard.build_board
      @gameboard.populate_board
    end
    context "with white king b1 and black rook a2" do
      it "should remove b2 from the king's allowable moves" do
        #Moving rook
        @gameboard.data[[4,4]][:occupant] = @gameboard.data[[1,8]][:occupant]
        @gameboard.data[[1,8]][:occupant] = nil
        @gameboard.black_set.data[[4,4]] = @gameboard.black_set.data[[1,8]]
        @gameboard.black_set.data[[1,8]] = nil

        #Moving king
        @gameboard.data[[5,3]][:occupant] = @gameboard.data[[5,1]][:occupant]
        @gameboard.data[[5,1]][:occupant] = nil
        @gameboard.white_set.data[[5,3]] = @gameboard.white_set.data[[5,1]]
        @gameboard.white_set.data[[5,1]] = nil

        @gameboard.generate_moves(@gameboard.data[[4,4]][:occupant])
        @gameboard.generate_moves(@gameboard.data[[5,3]][:occupant])

        @gameboard.king_move_list_cleanup

        expect(@gameboard.data[[5,3]][:occupant].can_move_to).to_not include([5,4])
      end
    end
  end

  describe ":remove_piece" do
    before(:each) do
      @gameboard.build_board
      @gameboard.populate_board
    end
    context "when called on a location" do
      it "empties the square if occupied" do
        @gameboard.remove_piece([1,1])
        expect(@gameboard.data[[1,1]][:occupant]).to eql(nil)
        expect(@gameboard.white_set.data.keys).to_not include([1,1])
        expect(@gameboard.white_set.captured.length).to eql(1)
      end
      it "returns nil if already empty" do
        expect(@gameboard.remove_piece([4,4])).to eql(nil)
      end
      it "returns 'out of bounds' if location is out of bounds" do
        expect(@gameboard.remove_piece([10,10])).to eql("out of bounds")
      end
    end
  end

  describe ":move_piece" do
    before(:each) do
      @gameboard.build_board
      @gameboard.populate_board
    end
    context "when called on a location and destination" do
      it "returns 'out of bounds' if the starting location is off-board" do
        expect(@gameboard.move_piece([10,10],[4,4])).to eql('out of bounds')
      end
      it "returns 'out of bounds' if the destination is off-board" do
        expect(@gameboard.move_piece([1,1],[40,40])).to eql('out of bounds')
      end
    end
    context "when called on a empty location" do
      it "returns nil" do
        expect(@gameboard.move_piece([4,4],[5,5])).to eql(nil)
      end
    end
    context "when called on an occupied location" do
      it "moves the piece to the destination if empty" do
        @gameboard.move_piece([1,1],[5,5])
        expect(@gameboard.data[[1,1]][:occupant]).to eql(nil)
        expect(@gameboard.data[[5,5]][:occupant]).to_not eql(nil)
        expect(@gameboard.data[[5,5]][:occupant].type).to eql(:rook)
        expect(@gameboard.white_set.data[[1,1]]).to eql(nil)
        expect(@gameboard.white_set.data[[5,5]].type).to eql(:rook)
      end
      it "returns false if the destination is occupied by an ally" do
        expect(@gameboard.move_piece([1,1],[2,2])).to eql(false)
      end
      it "captures an enemy piece if the destination is occupied by one" do
        @gameboard.move_piece([1,1],[8,8])
        expect(@gameboard.data[[1,1]][:occupant]).to eql(nil)
        expect(@gameboard.data[[8,8]][:occupant]).to_not eql(nil)
        expect(@gameboard.data[[8,8]][:occupant].type).to eql(:rook)
        expect(@gameboard.white_set.data[[1,1]]).to eql(nil)
        expect(@gameboard.white_set.data[[8,8]].type).to eql(:rook)

        expect(@gameboard.black_set.data[[8,8]]).to eql(nil)
        expect(@gameboard.black_set.data.keys.length).to eql(15)
        expect(@gameboard.black_set.captured.length).to eql(1)
      end
    end
  end
end
