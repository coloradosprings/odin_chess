require_relative '../lib/main'

describe Chess do
    describe '#make_move' do
        subject(:game){Chess.new}
        
        context 'when given a invalid move then a valid' do
            before do
                allow(game).to receive(:puts)
                allow(game).to receive(:gets).and_return('a342','a,2 a,3')
                game.instance_variable_set(:@currentplayer,'white')
            end
            it 'loops through then changes @board' do
                expect{game.make_move}.to change{game.instance_variable_get(:@board)[6][0]}.to eq(' ')
            end
        end
        context 'when input is "castle small" and @currentplayer = "white"' do
            before do
                allow(game).to receive(:puts)
                allow(game).to receive(:gets).and_return('castle small')
                game.instance_variable_set(:@currentplayer,'white')
            end
            it 'switches @kingwhite\'s position and rook\'s[7][7] when all condition are matched' do
                board = game.instance_variable_get(:@board)
                rook = board[7][7]
                board[7][5] = ' '
                board[7][6] = ' '
                king_white = game.instance_variable_get(:@king_white)
                expect{game.make_move}.to change{king_white.position}.to eq([7,6])
            end
        end
        context 'when input is "castle big" and @currentplayer = "black"' do
            before do
                allow(game).to receive(:puts)
                allow(game).to receive(:gets).and_return('castle big')
                game.instance_variable_set(:@currentplayer,'black')
            end
            it 'switches @kingwhite\'s and rook\'s([0][0]) position when all condition are matched' do
                board = game.instance_variable_get(:@board)
                rook = board[0][0]
                board[0][2] = ' '
                board[0][3] = ' '
                board[0][1] = ' '
                expect{game.make_move}.to change{rook.position}.to eq([0,3])
            end
        end
        context 'when input is "castle big" and one coordinate which "king" passes is "under attack"' do
            before do
                allow(game).to receive(:puts)
                allow(game).to receive(:gets).and_return('castle big','a,7 a,6')
                game.instance_variable_set(:@currentplayer,'black')
            end
            it 'loops through until a valid input is given' do
                board = game.instance_variable_get(:@board)
                queen = Queen.new('white',[4,3])
                rook = board[0][0]
                board[0][2] = ' '
                board[0][3] = ' '
                board[0][1] = ' '
                board[1][3] = ' '
                board[4][3] = queen
                expect{game.make_move}.not_to change{rook.position}
            end
        end
    end
    describe '#is_check' do
        subject(:game){Chess.new}
        context 'when "rook" is the next item in the same row as "king"' do
            it 'returns "true"' do
                king = King.new('black',[5,4])
                game.instance_variable_set(:@king_black,king)
                board = Array.new(8){Array.new(8,' ')}
                board[5][4] = king
                board[5][1] = Rook.new('white',[5,1])
                expect(game.is_check(board,'black')).to eq(true)
            end
        end
        context 'when "rook" is second next item and next item blocks the check' do
            it 'returns "false"' do
                king = King.new('black',[5,4])
                game.instance_variable_set(:@king_black,king)
                board = Array.new(8){Array.new(8,' ')}
                board[5][4] = king
                board[5][2] = PawnBlack.new('black',[5,2])
                board[5][1] = Rook.new('black',[5,1])
                expect(game.is_check(board,'black')).to eq(false)
            end
        end
    end
    describe '#is_checkmate' do
        subject(:game){Chess.new}
        context 'when King\'s #find_moves returns fields so that #is_check returns "false"' do

            it 'returns false' do
                game.instance_variable_set(:@board,Array.new(8){Array.new(8,' ')})
                king = game.instance_variable_get(:@king_black)
                board = game.instance_variable_get(:@board)
                king.position = [4,4]
                board[4][4] = king
                queen = Queen.new('white',[1,4])
                board[1][4] = queen
                expect(game.is_checkmate('black')).to eq(false)
            end
        end
        context 'when King\'s #find_moves returns fields so that #is_check returns "true"' do
            it 'returns true' do
                game.instance_variable_set(:@board,Array.new(8){Array.new(8,' ')})
                board = game.instance_variable_get(:@board)
            
                king = game.instance_variable_get(:@king_black)
                king.position = [4,4]
                board[4][4] = king
                board[3][6] = Rook.new('white',[3,6])
                board[5][7] = Rook.new('white',[5,7])
                queen = Queen.new('white',[4,0])
                board[4][0] = queen
                expect(game.is_checkmate('black')).to eq(true)
            end
        end
        context 'when "figure" with same color can block check' do
            it 'returns false' do
                game.instance_variable_set(:@board,Array.new(8){Array.new(8,' ')})
                board = game.instance_variable_get(:@board)
                
                king = game.instance_variable_get(:@king_black)
                king.position = [4,4]
                board[4][4] = king
                board[3][6] = Rook.new('white',[3,6])
                board[5][7] = Rook.new('white',[5,7])
                queen = Queen.new('white',[4,0])
                board[4][0] = queen
                board[0][3] = Queen.new('black',[0,3])
                expect(game.is_checkmate('black')).to eq(false)
            end
        end
        context 'when "figure" with same color can\'t block check' do
            it 'returns true' do
                game.instance_variable_set(:@board,Array.new(8){Array.new(8,' ')})
                board = game.instance_variable_get(:@board)
                king = game.instance_variable_get(:@king_black)
                king.position = [4,4]
                board[4][4] = king
                board[3][6] = Rook.new('white',[3,6])
                board[5][7] = Rook.new('white',[5,7])
                queen = Queen.new('white',[4,0])
                board[4][0] = queen
                board[0][3] = Knight.new('black',[0,3])
                expect(game.is_checkmate('black')).to eq(true)
            end
        end
        context 'when "figure" with same color could block check but it opens another check' do
            it 'returns true' do

                game.instance_variable_set(:@board,Array.new(8){Array.new(8,' ')})
                board = game.instance_variable_get(:@board)
                king = game.instance_variable_get(:@king_black)
                king.position = [4,4]
                board[4][4] = king
                board[3][6] = Rook.new('white',[3,6])
                board[5][7] = Rook.new('white',[5,7])
                board[0][4] = Rook.new('white',[0,4])
                board[4][0] = Queen.new('white',[4,0])
                board[1][4] = Queen.new('black',[1,4])
                board[0][3] = Knight.new('black',[0,3])
                expect(game.is_checkmate('black')).to eq(true)
        
            end
        end

        context 'when figure\'s position giving the check is in find_moves of "figure" with other color' do
            it 'returns false' do
                game.instance_variable_set(:@board,Array.new(8){Array.new(8,' ')})
                board = game.instance_variable_get(:@board)
                king = game.instance_variable_get(:@king_black)
                king.position = [4,4]
                board[4][4] = king
                board[3][6] = Rook.new('white',[3,6])
                board[5][7] = Rook.new('white',[5,7])
                board[4][0] = Queen.new('white',[4,0])
                board[2][1] = Knight.new('black',[2,1])
                expect(game.is_checkmate('black')).to eq(false)

            end
        end

        context 'when figure\'s position is in #find_moves(King.position) and given that position #is_check returns true' do
            it 'returns true'   do
                game.instance_variable_set(:@board,Array.new(8){Array.new(8,' ')})
                board = game.instance_variable_get(:@board)
                king = game.instance_variable_get(:@king_black)
                board[1][0] = PawnBlack.new('black',[1,0])
                king.position = [6,0]
                board[6][0] = king
                board[6][1] = Queen.new('white',[6,1])
                board[0][1] = Rook.new('white',[0,1])
                expect(game.is_checkmate('black')).to eq(true)
                
            end
        end
    end

    describe '#is_draw' do
        subject(:game){Chess.new}
       context 'when "King" is last figure and any coordinate in #find_moves handed to #is_check returns "true"' do
        it 'returns true' do 
            game.instance_variable_set(:@board,Array.new(8){Array.new(8,' ')})
            board = game.instance_variable_get(:@board)
            king = game.instance_variable_get(:@king_black)
            king.position = [6,0]
            board[6][0] = king
            board[7][2] = Queen.new('white',[7,2])
            board[0][1] = Rook.new('white',[0,1])
            expect(game.check_draw('black')).to eq(true)
            
        end
       end
       context 'when "King" has no field to move but there\'s another figure' do
        it 'returns false' do 
            game.instance_variable_set(:@board,Array.new(8){Array.new(8,' ')})
            board = game.instance_variable_get(:@board)
            king = game.instance_variable_get(:@king_black)
            board[1][0] = PawnBlack.new('black',[1,0])
            king.position = [6,0]
            board[6][0] = king
            board[7][2] = Queen.new('white',[7,2])
            board[0][1] = Rook.new('white',[0,1])
            queen = Queen.new('white',[7,2])
            expect(game.check_draw('black')).to eq(false)
        end
       end
    end
end
# [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], 
# [1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7],
# [2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [2, 5], [2, 6], [2, 7],
# [3, 0], [3, 1], [3, 2], [3, 3], [3, 4], [3, 5], [3, 6], [3, 7], 
# [4, 0], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6], [4, 7], 
# [5, 0], [5, 1], [5, 2], [5, 3], [5, 4], [5, 5], [5, 6], [5, 7], 
# [6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7], 
# [7, 0], [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7]]
