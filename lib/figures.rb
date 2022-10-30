module ChessTupel
    @chess_tupel = []
    for i in 0..7
        for k in 0..7
            @chess_tupel.push([i,k])
        end
    end
    def self.get_tupel
        chess_tupel = Array.new(@chess_tupel)
        chess_tupel
    end
end

class Figure
    attr_accessor :color,:position
    def initialize(color,position)
        @color = color
        @position = position
    end
    
    def find_moves(board)
    end

    def make_move(board,next_position)
        @previous_position = @position.clone
        @previous_item = board[next_position[0]][next_position[1]]
        board[@position[0]][@position[1]] = ' '
        board[next_position[0]][next_position[1]] = self
        @position = next_position
        return board
    end

    def return_move(board)
        board[@position[0]][@position[1]] = @previous_item
        board[@previous_position[0]][@previous_position[1]] = self
        @position = @previous_position
        return board
    end
        
end


class PawnBlack < Figure
    def utf_8
        "\u265F"
    end
    def find_moves(board)
        chess_tupel = ChessTupel.get_tupel
        chess_tupel.filter do |tupel|
                check1 = @position[0] == 1 && @position[1] == tupel[1] && (@position[0] ==  tupel[0] - 1 || @position[0] == tupel[0] - 2) && board[tupel[0]][tupel[1]] == ' ' 
                check2 = @position[1] == tupel[1] && @position[0] == tupel[0] - 1 && board[tupel[0]][tupel[1]] == ' ' 
                check3 = if (@position[1] == tupel[1] + 1 || @position[1] == tupel[1] - 1) && @position[0] == tupel[0] - 1 && board[tupel[0]][tupel[1]] != ' '
                            (board[tupel[0]][tupel[1]]).color != self.color ? true : false
                        else
                            false
                        end 
                item_check4 = tupel[0] - 1 >= 0 ? board[tupel[0] - 1][tupel[1]] : nil
                check4 = position[0] == 4 && tupel[0] == 5 && (tupel[1] - position[1]).abs == 1 && item_check4 != ' ' && item_check4.class == PawnWhite && item_check4.instance_variable_get(:@can_en_passent)    
                check1 || check2 || check3 || check4                       
        end  
    end
end

class PawnWhite < Figure
    def utf_8
        "\u2659"
    end
    def find_moves(board)
        chess_tupel = ChessTupel.get_tupel
        chess_tupel.filter do |tupel|
                check1 = @position[0] == 6 && @position[1] == tupel[1] && (@position[0] ==  tupel[0] + 1 || @position[0] == tupel[0] + 2) && board[tupel[0]][tupel[1]] == ' ' 
                check2 = @position[1] == tupel[1] && @position[0] == tupel[0] + 1 && board[tupel[0]][tupel[1]] == ' ' 
                check3 = if (@position[1] == tupel[1] + 1 || @position[1] == tupel[1] - 1) && @position[0] == tupel[0] + 1 && board[tupel[0]][tupel[1]] != ' '
                            (board[tupel[0]][tupel[1]]).color != self.color ? true : false
                        else
                            false
                        end   
                        
                item_check4 = tupel[0] + 1 <= 7 ? board[tupel[0] + 1][tupel[1]] : nil
                check4 = position[0] == 3 && tupel[0] == 2 && (tupel[1] - position[1]).abs == 1 && item_check4 != ' ' && item_check4.class == PawnBlack && item_check4.instance_variable_get(:@can_en_passent)           
                check1 || check2 || check3 || check4                            
        end  
    end
end

class Rook < Figure
    def utf_8
        @color == 'black' ? "\u265C" : "\u2656"
    end
    def find_moves(board)
        possib_fields = []
        for index in 1..@position[0] 
            index = @position[0] - index
            item = board[index][@position[1]]
            if item != ' '
                if item.color != self.color
                    item.color != self.color ? possib_fields.push(item.position) : false
                end
                break
            end
            possib_fields.push([index,@position[1]])
        end
        for index in @position[0] + 1..7
            item = board[index][@position[1]]
            if item != ' '
                if item.color != self.color
                    item.color != self.color ? possib_fields.push(item.position) : false
                end
                break
            end
            possib_fields.push([index,@position[1]])
        end
        for index in 1..@position[1] 
            index = @position[1] - index
            item = board[@position[0]][index]
            if item != ' '
                if item.color != self.color
                    item.color != self.color ? possib_fields.push(item.position) : false
                end
                break
            end
            possib_fields.push([@position[0],index])
        end
        for index in @position[1] + 1..7
            item = board[@position[0]][index]
            if item != ' '
                if item.color != self.color
                    item.color != self.color ? possib_fields.push(item.position) : false
                end
                break
            end
            possib_fields.push([@position[0],index])
        end
        return possib_fields
    end



end

class Knight < Figure 
    def utf_8
        @color == 'black' ? "\u265E" : "\u2658"
    end
    def find_moves(board)
        chess_tupel = ChessTupel.get_tupel
        chess_tupel.filter! do |tupel| 
            item = board[tupel[0]][tupel[1]]
            check1 = (tupel[0] - @position[0]).abs == 2 && (tupel[1] - @position[1]).abs == 1 || (tupel[0] - @position[0]).abs == 1 && (tupel[1] - @position[1]).abs == 2
            check2 = item == ' '
            check3 = item != ' ' ? item.color != self.color : false
            check1 && (check2 || check3)
        end
    end
end

class Bishop < Figure
    def utf_8
        @color == 'black' ? "\u265D" : "\u2657"
    end
    def find_moves(board)
        number_fields = [@position[0],@position[1]].min
        possib_fields = []
        index1 = @position[0]
        index2 = @position[1] 
        for i in 1..number_fields
            index1 -= 1
            index2 -= 1
            item = board[index1][index2]
            if item != ' '
                if item.color != self.color
                    item.color != self.color ? possib_fields.push(item.position) : false
                end
                break
            end
            possib_fields.push([index1,index2])
        end
        number_fields = [@position[0],7 - @position[1]].min
        index1 = @position[0]
        index2 = @position[1] 
        for i in 1..number_fields
            index1 -= 1
            index2 += 1
            item = board[index1][index2]
            if item != ' '
                if item.color != self.color
                    item.color != self.color ? possib_fields.push(item.position) : false
                end
                break
            end
            possib_fields.push([index1,index2])
        end
        number_fields = [7 - @position[0],7 - @position[1]].min
        index1 = @position[0]
        index2 = @position[1] 
        for i in 1..number_fields
            index1 += 1
            index2 += 1
            item = board[index1][index2]
            if item != ' '
                if item.color != self.color
                    item.color != self.color ? possib_fields.push(item.position) : false
                end
                break
            end
            possib_fields.push([index1,index2])
        end
        number_fields = [7 - @position[0],@position[1]].min
        index1 = @position[0]
        index2 = @position[1] 
        for i in 1..number_fields
            index1 += 1
            index2 -= 1
            item = board[index1][index2]
            if item != ' '
                if item.color != self.color
                    item.color != self.color ? possib_fields.push(item.position) : false
                end
                break
            end
            possib_fields.push([index1,index2])
        end
        return possib_fields
        
    end
end

class King < Figure
    def utf_8
        @color == 'black' ? "\u265A" : "\u2654"
    end
    def find_moves(board)
        chess_tupel = ChessTupel.get_tupel
        chess_tupel.filter! do |tupel|
            item = board[tupel[0]][tupel[1]]
            check1 = @position[0] == tupel[0] && (tupel[1] - @position[1]).abs == 1
            check2 = @position[1] == tupel[1] && (tupel[0] - @position[0]).abs == 1
            check3 = @position[1] == tupel[1] - 1 && (tupel[0] - @position[0]).abs == 1
            check4 = @position[1] == tupel[1] + 1 && (tupel[0] - @position[0]).abs == 1
            check5 = (item != ' ') ? (item.color != self.color) : 1
            (check1 || check2 || check3 || check4) && check5
        end
    end
end

class Queen < Figure
    def utf_8
        @color == 'black' ? "\u265B" : "\u2655"
    end
    def find_moves(board)
        possib_fields = []
        for index in 1..@position[0] 
            index = @position[0] - index
            item = board[index][@position[1]]
            if item != ' '
                if item.color != self.color
                    item.color != self.color ? possib_fields.push(item.position) : false
                end
                break
            end
            possib_fields.push([index,@position[1]])
        end
        for index in @position[0] + 1..7
            item = board[index][@position[1]]
            if item != ' '
                if item.color != self.color
                    item.color != self.color ? possib_fields.push(item.position) : false
                end
                break
            end
            possib_fields.push([index,@position[1]])
        end
        for index in 1..@position[1] 
            index = @position[1] - index
            item = board[@position[0]][index]
            if item != ' '
                if item.color != self.color
                    item.color != self.color ? possib_fields.push(item.position) : false
                end
                break
            end
            possib_fields.push([@position[0],index])
        end
        for index in @position[1] + 1..7
            item = board[@position[0]][index]
            if item != ' '
                if item.color != self.color
                    item.color != self.color ? possib_fields.push(item.position) : false
                end
                break
            end
            possib_fields.push([@position[0],index])
        end
        number_fields = [@position[0],@position[1]].min
        index1 = @position[0]
        index2 = @position[1] 
        for i in 1..number_fields
            index1 -= 1
            index2 -= 1
            item = board[index1][index2]
            if item != ' '
                if item.color != self.color
                    item.color != self.color ? possib_fields.push(item.position) : false
                end
                break
            end
            possib_fields.push([index1,index2])
        end
        number_fields = [@position[0],7 - @position[1]].min
        index1 = @position[0]
        index2 = @position[1] 
        for i in 1..number_fields
            index1 -= 1
            index2 += 1
            item = board[index1][index2]
            if item != ' '
                if item.color != self.color
                    item.color != self.color ? possib_fields.push(item.position) : false
                end
                break
            end
            possib_fields.push([index1,index2])
        end
        number_fields = [7 - @position[0],7 - @position[1]].min
        index1 = @position[0]
        index2 = @position[1] 
        for i in 1..number_fields
            index1 += 1
            index2 += 1
            item = board[index1][index2]
            if item != ' '
                if item.color != self.color
                    item.color != self.color ? possib_fields.push(item.position) : false
                end
                break
            end
            possib_fields.push([index1,index2])
        end
        number_fields = [7 - @position[0],@position[1]].min
        index1 = @position[0]
        index2 = @position[1] 
        for i in 1..number_fields
            index1 += 1
            index2 -= 1
            item = board[index1][index2]
            if item != ' '
                if item.color != self.color
                    item.color != self.color ? possib_fields.push(item.position) : false
                end
                break
            end
            possib_fields.push([index1,index2])
        end
        return possib_fields
    end
end