require_relative '../lib/figures'

describe PawnWhite do
    describe '#find_moves' do
        subject(:pawn){PawnWhite.new('white',[6,6])}
        context 'if position equals [1,1]' do
            it 'return [[2,1],[3,1]]' do
                board = Array.new(8){Array.new(8,' ')}
                #allow(find_moves).to receive(board)
                expect(pawn.find_moves(board)).to eq([[4,6],[5,6]])
                
            end
        end
        context 'when position[1] is equal to 3 and next item in the row is PawnBlack with @can_en_passent equal to true' do
            before do
                pawn.instance_variable_set(:@position,[3,3])
            end
            it 'returns coordinatens with [2,4] inlcuded' do
                board = Array.new(8){Array.new(8,' ')}
                board[3][3] = pawn
                board[3][4] = PawnBlack.new('black',[3,4])
                board[3][4].instance_variable_set(:@can_en_passent,true)
                expect(pawn.find_moves(board)).to eq([[2,3],[2,4]])
            end
        end
        context 'when position[1] is equal to 3 and previous item in the row is PawnBlack with @can_en_passent equal to true' do
            before do
                pawn.instance_variable_set(:@position,[3,3])
            end
            it 'returns coordinatens with [2,2] included' do
                board = Array.new(8){Array.new(8,' ')}
                board[3][3] = pawn
                board[3][2] = PawnBlack.new('black',[3,2])
                board[3][4] = PawnBlack.new('black',[3,4])
                board[3][4].instance_variable_set(:@can_en_passent,true)
                board[3][2].instance_variable_set(:@can_en_passent,true)
                expect(pawn.find_moves(board)).to eq([[2,2],[2,3],[2,4]])
            end
        end
        context 'when position[1] is equal to 3 and next item in the row is PawnBlack with @can_en_passent equal to false' do
            before do
                pawn.instance_variable_set(:@position,[3,3])
            end
            it 'returns coordinatens with [2,4] not included' do
                board = Array.new(8){Array.new(8,' ')}
                board[3][3] = pawn
                board[3][4] = PawnBlack.new('black',[3,4])
                board[3][4].instance_variable_set(:@can_en_passent,false)
                expect(pawn.find_moves(board)).to eq([[2,3]])
            end

        end

    end
    describe '#make_move' do
        subject(:pawn){PawnWhite.new('white',[1,1])}
        context 'when given a valid move [2,1]' do
            it 'sets board indices to new position [2,1]' do
                board = Array.new(8){Array.new(8,' ')}
                board[1][1] = pawn
                board_after =   Array.new(8){Array.new(8,' ')}
                board_after[2][1] = pawn
                expect(pawn.make_move(board,[2,1])).to eq(board_after)
                
            end
        end
    end   
end

describe PawnBlack do
    describe '#find_moves' do
        subject(:pawn){PawnBlack.new('white',[1,6])}
        context 'if position equals [1,1]' do
            it 'return [[2,6],[3,6]]' do
                board = Array.new(8){Array.new(8,' ')}
                #allow(find_moves).to receive(board)
                expect(pawn.find_moves(board)).to eq([[2,6],[3,6]])
                
            end
        end
        context 'when position[1] is equal to 4 and next item in the row is PawnBlack with @can_en_passent equal to true' do
            before do
                pawn.instance_variable_set(:@position,[4,3])
            end
            it 'returns coordinatens with [5,4] inlcuded' do
                board = Array.new(8){Array.new(8,' ')}
                board[4][3] = pawn
                board[4][4] = PawnWhite.new('black',[4,4])
                board[4][4].instance_variable_set(:@can_en_passent,true)
                expect(pawn.find_moves(board)).to eq([[5,3],[5,4]])
            end
        end
        context 'when position[1] is equal to 3 and previous item in the row is PawnBlack with @can_en_passent equal to true' do
            before do
                pawn.instance_variable_set(:@position,[4,3])
            end
            it 'returns coordinatens with [2,2] included' do
                board = Array.new(8){Array.new(8,' ')}
                board[4][3] = pawn
                board[4][2] = PawnWhite.new('black',[4,2])
                board[4][2].instance_variable_set(:@can_en_passent,true)
                expect(pawn.find_moves(board)).to eq([[5,2],[5,3]])
            end
        end
        context 'when position[1] is equal to 3 and next item in the row is PawnBlack with @can_en_passent equal to false' do
            before do
                pawn.instance_variable_set(:@position,[4,3])
            end
            it 'returns coordinatens with [5,4] not included' do
                board = Array.new(8){Array.new(8,' ')}
                board[4][3] = pawn
                board[4][4] = PawnWhite.new('black',[4,4])
                board[4][4].instance_variable_set(:@can_en_passent,false)
                expect(pawn.find_moves(board)).to eq([[5,3]])
            end

        end

    end
end

describe Rook do
    describe '#find_moves' do
        subject(:rook){Rook.new('white',[3,3])}
        context 'when cross axis are empty' do
            it 'returns every coordinate on the cross except @position' do
                board = Array.new(8){Array.new(8,' ')}
                board[3][3] = rook
                fields = []
                for i in 0..7
                    fields.push([3,i])                    
                end
                for i in 0..7
                    fields.push([i,3])                   
                end
                fields.delete [3,3]
                expect(rook.find_moves(board).sort).to eq(fields.sort)
                rook.find_moves(board)
            end
        end
        context 'when a figure with same color is in the next item in the column' do
            it 'returns every coordinate up to the item' do
                board = Array.new(8){Array.new(8,' ')}
                board[3][3] = rook
                board[1][3] = PawnWhite.new('white',[1,3])
                fields = []
                for i in 0..7
                    fields.push([3,i])                    
                end
                for i in 0..7
                    fields.push([i,3])                   
                end
                fields.delete [3,3]
                fields.delete [1,3]
                fields.delete [0,3]
                expect(rook.find_moves(board).sort).to eq(fields.sort)

            end
        end
        context 'when a figure with same color is in the next item in the row' do
            it 'returns every coordinate up to the item' do
                board = Array.new(8){Array.new(8,' ')}
                board[3][3] = rook
                board[3][5] = PawnWhite.new('white',[3,5])
                fields = []
                for i in 0..7
                    fields.push([3,i])                    
                end
                for i in 0..7
                    fields.push([i,3])                   
                end
                fields.delete [3,3]
                fields.delete [3,5]
                fields.delete [3,6]
                fields.delete [3,7]
                expect(rook.find_moves(board).sort).to eq(fields.sort)
               rook.find_moves(board)

            end
        end
        context 'when a figure with unequal color is in the next item in the column' do
            it 'returns every coordinate including the item' do
                board = Array.new(8){Array.new(8,' ')}
                board[3][3] = rook
                board[3][5] = Rook.new('black',[3,5])
                fields = []
                for i in 0..7
                    fields.push([3,i])                    
                end
                for i in 0..7
                    fields.push([i,3])                   
                end
                fields.delete [3,3]
                fields.delete [3,6]
                fields.delete [3,7]
                expect(rook.find_moves(board).sort).to eq(fields.sort)
               rook.find_moves(board)

            end
        end
        context 'when object with different is in the same column' do
            it 'returns every coordinate object position including' do
                board = Array.new(8){Array.new(8,' ')}
                board[5][5] = rook
                rook.instance_variable_set(:@position,[5,5])
                board[3][5] = Bishop.new('black',[3,5])
                fields = [[5, 0], [5, 1], [5, 2], [5, 3], [5, 4], [5, 6], [5, 7], [6, 5], [7, 5],[3, 5],[4, 5]].sort
                expect(rook.find_moves(board).sort).to eq(fields)
            end
        end
    end
    describe '#make_move' do
        subject(:rook){Rook.new('white',[1,1])}
        context 'when given a valid value' do
            before do
                allow(rook).to receive(:find_moves).and_return([[4,1]])
            end
            # it 'changes position to equal [4,1]' do
            #     board = Array.new(8){Array.new(8,' ')}
            #     board[1][1] = rook
            #     expect{rook.make_move(board,[4,1])}.to change{rook.position}.to eq([4,1])
                               
            # end
            it 'returns board with changed position' do
                board = Array.new(8){Array.new(8,' ')}
                board[1][1] = rook
                board_after = Array.new(8){Array.new(8,' ')}
                board_after[4][1] = rook
                expect(rook.make_move(board,[4,1])).to eq(board_after)
                
            end
        end
    end
end

describe Knight do
    describe '#find_moves' do
        subject(:knight){Knight.new('white',[2,2])}
        context 'when coordinates are empty' do
            it 'returns every possible coordinate' do
                board = Array.new(8){Array.new(8,' ')}
                board[2][2] = knight
                fields = [[0,1],[1,0],[3,4],[4,3],[3,0],[4,1],[0,3],[1,4]]
                expect(knight.find_moves(board).sort).to eq(fields.sort)
            end
        end
        context 'when color is white and there is one object with color "white",one object with color "black"' do
            it 'returns coordinates with first included second excluded' do
                board = Array.new(8){Array.new(8,' ')}
                board[2][2] = knight
                board[0][1] = King.new('white',[0,1])
                board[3][4] = Rook.new('black',[3,4])
                fields = [[1,0],[3,4],[4,3],[3,0],[4,1],[0,3],[1,4]]
                expect(knight.find_moves(board).sort).to eq(fields.sort)
            end
        end
    end
end

describe Bishop do
   describe '#find_moves' do
        subject(:bishop){Bishop.new('white',[3,3])}
        context 'when coordinates are empty' do
            it 'returns every possible coordinate on the cross diagonal' do
                board = Array.new(8){Array.new(8,' ')}
                board[3][3] = bishop
                fields = [[2,2],[1,1],[0,0],[4,4],[5,5],[6,6],[7,7],[4,2],[5,1],[6,0],[2,4],[1,5],[0,6]]
                expect(bishop.find_moves(board).sort).to eq(fields.sort)

            end
        end
        context 'when color is white and there is one object with color "white",one object with color "black" on the cross diagonal' do
            it 'returns coordinates up till first,second with object coordinates included,excluded' do
                board = Array.new(8){Array.new(8,' ')}
                board[3][3] = bishop
                board[1][1] = Knight.new('white',[1,1])
                board[4][2] = Knight.new('black',[4,2])
                fields = [[2,2],[4,4],[5,5],[6,6],[7,7],[4,2],[2,4],[1,5],[0,6]]
                expect(bishop.find_moves(board).sort).to eq(fields.sort)

            end
        end
        context 'test as previous different diagonals' do
            it 'returns coordinates up till first,second with object coordinates included,excluded' do
                board = Array.new(8){Array.new(8,' ')}
                board[3][3] = bishop
                board[5][5] = Knight.new('white',[5,5])
                board[2][4] = Knight.new('black',[2,4])
                fields = [[2,2],[1,1],[0,0],[4,4],[4,2],[5,1],[6,0],[2,4]]
                expect(bishop.find_moves(board).sort).to eq(fields.sort)
            end
        end
   end
end

describe King do
    describe '#find_moves' do
        subject(:king){King.new('black',[2,3])}
        context 'when surrounding coordinates are empty' do
            it 'returns every surrounding coordinate' do
                board = Array.new(8){Array.new(8,' ')}
                board[2][3] = king
                fields = [[1,3],[1,2],[1,4],[2,2],[2,4],[3, 2], [3, 3], [3, 4]]
                expect(king.find_moves(board).sort).to eq(fields.sort)
            end
        end
        context 'when color is white and there is one object with color "white",one object with color "black" on the cross diagonal' do
            it 'returns coordinates up till first,second with object coordinates included,excluded' do
                board = Array.new(8){Array.new(8,' ')}
                board[2][3] = king
                board[1][3] = Rook.new('black',[1,3])
                board[3][4] = PawnWhite.new('white',[3,4])
                fields = [[1,2],[1,4],[2,2],[3, 2],[2,4],[3,3],[3,4]]
                expect(king.find_moves(board).sort).to eq(fields.sort) 
            end
        end
        # context 'when two objects possible fields include King\'s possible coordinate' do
        #     it 'returns coordinates without these' do
        #         board = Array.new(8){Array.new(8,' ')}
        #         board[2][3] = king
        #         rook = Rook.new('white',[5,4])
        #         board[5][4] = rook
        #         board[7][2] = Rook.new('white',[7,2])
        #         fields = [[1,3],[3, 3]]
        #         expect(king.find_moves(board).sort).to eq(fields.sort) 
        #     end
        # end
    end
end

describe Queen do
    subject(:queen){Queen.new('black',[3,3])}
    context 'when coordinates are empty' do
        it 'returns every possible coordinate on the cross diagonal aswell as horizontal and vertical direction' do
            board = Array.new(8){Array.new(8,' ')}
            board[3][3] = queen
            fields = []
            for i in 0..7
                fields.push([3,i])                    
            end
            for i in 0..7
                fields.push([i,3])                   
            end
            fields.delete [3,3]
            fields += [[2,2],[1,1],[0,0],[4,4],[5,5],[6,6],[7,7],[4,2],[5,1],[6,0],[2,4],[1,5],[0,6]]
            expect(queen.find_moves(board).sort).to eq(fields.sort)
        end
    end
    context 'when objects are on possible coordinates' do
        it 'returns coordinates up to the object including when other color excluding when same' do
            board = Array.new(8){Array.new(8,' ')}
            board[5][5] = queen
            queen.instance_variable_set(:@position,[5,5])
            board[5][2] = PawnBlack.new('black',[5,2])
            board[3][3] = Queen.new('white',[3,3])
            board[4][6] = PawnWhite.new('white',[4,6])
            board[6][5] = Bishop.new('black',[6,5])
            board[3][5] = Bishop.new('white',[3,5])
            fields = [[5, 3],[5,4],[5,6],[4,6],[5,7],[6,4],[7,3],[4,5],[3,5],[6,6],[7,7],[4,4],[3,3]]
            expect(queen.find_moves(board).sort).to eq(fields.sort)
            queen.find_moves(board)

        end
    end
    context 'when queen position [5,5] else @board is in beginning state' do
        it 'returns array of coordinates' do
            board = [[Rook.new('black',[0,0]),Knight.new('black',[0,1]),Bishop.new('black',[0,2]),Queen.new('black',[0,3]),@king_black,Bishop.new('black',[0,5]),Knight.new('black',[0,6]),Rook.new('black',[0,7])],
                [PawnBlack.new('black',[1,0]),PawnBlack.new('black',[1,1]),PawnBlack.new('black',[1,2]),PawnBlack.new('black',[1,3]),PawnBlack.new('black',[1,4]),PawnBlack.new('black',[1,5]),PawnBlack.new('black',[1,6]),PawnBlack.new('black',[1,7])],
                Array.new(1){Array.new(8,' ')}[0],Array.new(1){Array.new(8,' ')}[0],Array.new(1){Array.new(8,' ')}[0],Array.new(1){Array.new(8,' ')}[0],
                [PawnWhite.new('white',[6,0]),PawnWhite.new('white',[6,1]),PawnWhite.new('white',[6,2]),PawnWhite.new('white',[6,3]),PawnWhite.new('white',[6,4]),PawnWhite.new('white',[6,5]),PawnWhite.new('white',[6,6]),PawnWhite.new('white',[6,7])],
                [Rook.new('white',[7,0]),Knight.new('white',[7,1]),Bishop.new('white',[7,2]),Queen.new('white',[7,3]),@king_white,Bishop.new('white',[7,5]),Knight.new('white',[7,6]),Rook.new('white',[7,7])]]
                
            queen.position = [5,5]
            board[5][5] = queen
            expect(queen.find_moves(board).sort).to eq([[5, 0], [5, 1], [5, 2], [5, 3], [5, 4],[5, 6], [5, 7],[6, 5], [4, 5], [3, 5], [2, 5], [4, 6], [3, 7], [4, 4], [3, 3], [2, 2],[6,4],[6,6]].sort)

        end
    end
    context 'when queen\'s coordinate is [1,4] else @board is empty'  do
        it 'returns possible coordinates' do
            board = Array.new(8){Array.new(8,' ')}
            board[1][4] = queen
            queen.instance_variable_set(:@position,[1,4])
            fields = [[2, 3],[3, 2], [4, 1],[5, 0],[0,4],[1, 0], [1, 1], [1, 2], [1, 3], [1, 5], [1, 6], [1, 7],[7, 4], [6, 4], [5, 4], [4, 4], [3, 4], [2, 4], [0, 3], [0, 5], [2, 5], [3, 6], [4, 7]]
            expect(queen.find_moves(board).sort).to eq(fields.sort)
            queen.find_moves(board)

        end
    end
    
    
end

[[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], 
 [1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7],
 [2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [2, 5], [2, 6], [2, 7],
 [3, 0], [3, 1], [3, 2], [3, 3], [3, 4], [3, 5], [3, 6], [3, 7], 
 [4, 0], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6], [4, 7], 
 [5, 0], [5, 1], [5, 2], [5, 3], [5, 4], [5, 5], [5, 6], [5, 7], 
 [6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7], 
 [7, 0], [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7]]