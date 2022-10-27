require_relative 'figures'
require 'json'

class Chess
    def initialize
        @king_white = King.new('white',[7,4])
        @king_black = King.new('black',[0,4])
        @board = [[Rook.new('black',[0,0]),Knight.new('black',[0,1]),Bishop.new('black',[0,2]),Queen.new('black',[0,3]),@king_black,Bishop.new('black',[0,5]),Knight.new('black',[0,6]),Rook.new('black',[0,7])],
                [PawnBlack.new('black',[1,0]),PawnBlack.new('black',[1,1]),PawnBlack.new('black',[1,2]),PawnBlack.new('black',[1,3]),PawnBlack.new('black',[1,4]),PawnBlack.new('black',[1,5]),PawnBlack.new('black',[1,6]),PawnBlack.new('black',[1,7])],
                Array.new(1){Array.new(8,' ')}[0],Array.new(1){Array.new(8,' ')}[0],Array.new(1){Array.new(8,' ')}[0],Array.new(1){Array.new(8,' ')}[0],
                [PawnWhite.new('white',[6,0]),PawnWhite.new('white',[6,1]),PawnWhite.new('white',[6,2]),PawnWhite.new('white',[6,3]),PawnWhite.new('white',[6,4]),PawnWhite.new('white',[6,5]),PawnWhite.new('white',[6,6]),PawnWhite.new('white',[6,7])],
                [Rook.new('white',[7,0]),Knight.new('white',[7,1]),Bishop.new('white',[7,2]),Queen.new('white',[7,3]),@king_white,Bishop.new('white',[7,5]),Knight.new('white',[7,6]),Rook.new('white',[7,7])]]
        @rendered_board = []
        4.times do 
            @rendered_board.push([" ","\u2591"," ","\u2591"," ","\u2591"," ","\u2591"," ","\u2591"])
            @rendered_board.push(["\u2591"," ","\u2591"," ","\u2591"," ","\u2591"," ","\u2591"," "])
        end
        @castle_bool = [[true,true,true],[true,true,true]] #[black,white]
    end

    def check_board
        @white_ischecked = is_check(@board,'white')
        @black_ischecked = is_check(@board,'black')
        puts "check" if @white_ischecked || @black_ischecked
        update_castle
        if @white_ischecked
            @game_over = true if is_checkmate('white') 
        elsif @black_ischecked
            @game_over = true if is_checkmate('black') 
        end 
        if check_draw(@currentplayer)
            @game_over = true
            puts 'draw'
        end 
    end
    def check_draw(color)
        figures_to_check = []
        @board.each do |row|
            row.each{|item| if item != ' '
                            item.color == color ? figures_to_check.push(item) : false
                    end}
        end

        figures_to_check.each do |figure|
            fields = figure.find_moves(@board)
            previous_position = figure.position
            fields.each do |field|
                figure.make_move(@board,field)
                unless is_check(@board,color)
                    figure.return_move(@board)
                    return false
                end
                figure.return_move(@board)
            end
        end
        return true
            
    end
    def is_check(board,color,position = color == 'white' ? @king_white.position : @king_black.position)
        figures_to_check = []
        board.each do |row|
                    row.each{|item| if item != ' '
                                    item.color != color ? figures_to_check.push(item) : false
                            end}
                end
        figures_to_check.any?{|item| item.find_moves(board).include?(position)}
    end

    def is_checkmate(color)
        board = @board.clone
        king_map = {'black' => @king_black,'white' => @king_white}
        king = king_map[color]
        figures_to_check = []

        board.each do |row|
            row.each do |item| 
                if item != ' '
                    if item.color != color
                        if item.find_moves(board).include?(king.position)
                            figures_to_check.push(item)
                        end
                    end
                end
            end
        end
        sort_dict = {PawnBlack => 5,PawnWhite => 5,Knight => 4,Bishop => 4,Rook => 3,Queen => 3,King => 1}
        figures = []
        board.each{|row| row.filter{|item| item != ' ' ? (figures.push(item) if item.color == color) : false}}
        figures.sort_by!{|figure| sort_dict[figure.class]}
        
        king.find_moves(@board).each do |position|
            previous_position = king.position
            king.make_move(@board,position)
            unless is_check(@board,color)
                king.return_move(@board)
                return false
            end
            king.return_move(@board)
        end

        figures[1..].each do |figure|
            possible_fields = figure.find_moves(@board)
            possible_fields = possible_fields.sort_by{|field| (king.position[0] - field[0]).abs + (king.position[1] - field[1]).abs}
            possible_fields.each do |field|
                figure.make_move(@board,field)
                unless is_check(@board,color)
                    figure.return_move(@board)
                    return false
                end
                figure.return_move(@board)
            end
            
        end


        return true
        
    end

    # def get_rounds
    #     rounds = gets.chomp.to_i
    #     until rounds.is_a? Integer && rounds > 0
    #         puts 'Input a natural number greater than 0'
    #         rounds = gets.chomp.to_i
    #     end
    # end

    def display_board
        print "___________________\n"
        for i in 1..8 
            print "|",9 - i," "
            index1 = i - 1
            for index2 in 0..7 
                item = @board[index1][index2]
                if item != " "
                    print item.utf_8,"|"
                else
                    print @rendered_board[index1][index2],"|"
                end
            end
            print "\u23B8\n"
        end
        print "|  a b c d e f g h|\u23B8\n"
        19.times{print "\u203E"}   
        print "\n"
    end
    def update_castle
        case @board
        when @board[7][0] == ' '
            @castle_bool[0][0] = false
        when @board[7][4] == ' '
            @castle_bool[0][1] = false
        when @board[7][7] == ' '
            @castle_bool[0][2] = false
        when @board[0][0] == ' '
            @castle_bool[1][0] = false
        when @board[0][4] == ' '
            @castle_bool[1][1] = false
        when @board[0][7] == ' '
            @castle_bool[1][2] = false
        end
    end

    def castle(side,row)
        lambda_check = -> (fields) do
                                check = true
                                fields.each do |field| unless field[1] == 4
                                                            if @board[field[0]][field[1]] != ' '
                                                                check == false
                                                            end
                                                        end
                                                    end
                                 if check
                                    fields_to_check = fields[0..2]
                                    figures_to_check = []
                                    @board.each do |row|
                                                row.each do |item| if item != ' '
                                                                item.color != @currentplayer ? figures_to_check.push(item) : false
                                                            end
                                                        end
                                                end
                                    
                                    figures_to_check.any? do |item| 
                                        coordinates = item.find_moves(@board)
                                        if fields_to_check.any?{|field| coordinates.include?(field)}
                                            check = false
                                        end
                                        
                                    end
                                end
                                return check
                            end        
        row == 7 ? bool_index = 1 : bool_index = 0
        case side
        when 'big'          
            if @castle_bool[bool_index][0] == true && @castle_bool[bool_index][1] == true
                fields = [[row,4],[row,3],[row,2],[row,1]]
                if lambda_check.call(fields)
                    @board[row][4],@board[0][2] = @board[row][2],@board[row][4]
                    @board[row][0],@board[0][3] = @board[row][3],@board[row][0]
                    update_positions
                    true
                else
                    false
                end
            end
        when 'small'
            if @castle_bool[bool_index][1] == true && @castle_bool[bool_index][2] == true
                fields = [[row,4],[row,5],[row,6]]
                if lambda_check.call(fields)
                    @board[row][4],@board[row][6] = @board[row][6],@board[row][4]
                    @board[row][7],@board[row][5] = @board[row][5],@board[row][7]
                    update_positions
                    true
                else
                    false
                end
            end
        else
            false
        end
    end
    
    def update_positions
        @board.each_with_index do |row,index|
            row.each_with_index{|item,i| item != ' ' ? item.position = [index,i] : nil}
        end
    end

    def make_move()
        puts 'what\'s your next move'
        row_trans = {'a' => 0 ,'b'=> 1,'c'=>  2,'d'=>  3,'e'=>  4,'f'=>  5,'g'=>  6,'h'=>  8}
        loop do
            move = gets.chomp
            move = move.split(' ')
            move.map!{|item| item.split(',')}
            case move
                in [[col1,row1],[col2,row2]] if row_trans.key?(col1) && row_trans.key?(col2) && row1.to_i.between?(1,8) && row2.to_i.between?(1,8)
                    col1 = row_trans[col1]
                    row1 = 8 - row1.to_i 
                    col2 = row_trans[col2]
                    row2 = 8 - row2.to_i 
                    check_item = @board[row1][col1]
                    if check_item == ' ' || check_item.color != @currentplayer || !(check_item.find_moves(@board).include?([row2,col2]))
                        puts "invalid input";next
                        
                    end

                    check_item.make_move(@board,[row2,col2])
                    if is_check(@board,@currentplayer)
                        check_item.return_move(@board)
                        puts 'invalid input'
                        next
                    end
                    break
                in [['save']]
                    save_game
                    break
                in [['castle'],[*a]]
                    row = {'black' => 0,'white' => 7}
                    unless castle(a[0],row[@currentplayer])
                        puts "invalid input";next
                    end
                    break
                in [['info']]
                    print_info
                    puts 'what\'s your next move'
                    next
                in [['quit']]
                    @game_over = true
                    break
                else
                    puts "invalid input";next
            end
            
        end
    end
    def save_game
        puts 'type in the name of the game'
        name = gets.chomp
        board_to_save = @board.map do |row| 
                            row = row.map{|field| field != ' ' ? field =  [field.class,field.color] : ' '}
                        end
        saving = {'board' => board_to_save,'currentplayer' => @currentplayer, 'castle_bool' => @castle_bool}
        dir_name = "../saved_games/#{name}.json"
        File.open(dir_name,'w'){|file| JSON.dump(saving,file)}              
    end
    
    def load_game
        game_paths = Dir['../saved_games/*']
        games = game_paths.map{|game| game = game[..-6];array = game.split('/');array[-1]}
        games.each{|game| print '|',game,'|',' '}
        puts 'type in the name of the game'
        selection = gets.chomp
        loop do
            break if games.include?(selection)
            puts "type in the name of the game"
            selection = gets.chomp
        end
        figure_diction = {'Rook' => Rook,"Knight" => Knight,"Bishop"=>Bishop,"Queen"=>Queen,"King"=>King,'PawnWhite' => PawnWhite,'PawnBlack' => PawnBlack}
        path = game_paths[games.index(selection)]

        file = File.read(path)
        hash = JSON.parse(file)
        @board = hash['board'].map{|row| row = row.map{|item| item != ' ' ? item =  figure_diction[item[0]].new(item[1],[0,0]) : ' '}}
        @castle_bool = hash['castle_bool']
        @currentplayer = hash['currentplayer']
        @board.flatten.uniq.keep_if{|item| item.class == King}.
        each{|item| item.color == 'white' ? @king_white = item : @king_black = item}
        update_positions
    end
    def print_info
        print "\n You can make a move through typing in the current position(column,row) then the next position(column,row) \n
        seperated by whitespace like 'a,2 a,4', you can castle by typing in 'castle big' or 'castle small'. \n
        To save the game type in 'save' and 'quit' to quit. To recall this text you can type 'info' \n"
        
    end
    def start_game
        puts "======CHESS======"
        puts "type 'new' for a new game,or 'load' to load one"
        input = gets.chomp
        loop do         
            break if input == 'new' || input == 'load'
            puts "'new' or 'load'"
            input = gets.chomp
        end
        @currentplayer = ['black','white'].sample
        load_game if input == 'load'
        display_board
        puts "#{@currentplayer} begins!"
        print_info
        game_loop
    end
    def game_loop
        loop do
            if @currentplayer == 'black'
                make_move
                display_board 
                check_board              
                @currentplayer = 'white'
            else 
                make_move
                display_board
                check_board
                @currentplayer = 'black'
            end
            break if @game_over
        end
    end
end
