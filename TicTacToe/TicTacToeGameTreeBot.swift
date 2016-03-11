import Foundation

class TicTacToeNodeGameView: GameView {
    var gameTypes = [GameType]()
    var gameStatus: GameStatus!
    var gameBoard: GameBoard!
}

struct TicTacToeNode {
    


    let position: BoardPosition?
    
    var gameOver: Bool {
        mutating get {

            switch gameView.gameStatus! {
            case .PlayerOneUp, .PlayerTwoUp:
                return false
            default:
                return true
            }
        }
    }
    
    let gameBoard: GameBoard
    lazy var gameView: GameView = self.runGame()
    lazy var children: [TicTacToeNode] = self.generateChildren()
    
    
    init(board: GameBoard, move: BoardPosition? = nil) {
        self.position = move
        self.gameBoard = board
    }
    
    mutating func generateChildren() -> [TicTacToeNode] {
        
        var nodes = [TicTacToeNode]()
        let board = gameView.gameBoard
        let remainingMoves = board.emptyPositions

        // Generate Children for each remaining move
        for move in remainingMoves {
            let child = TicTacToeNode(board: board, move: move)
            nodes.append(child)
        }
        
        return nodes
        
    }
    
    func runGame() -> GameView {
        
        let view = TicTacToeNodeGameView()
        let board = TicTacToeBoard(board: gameBoard.board)
        let game = TicTacToe(view: view, board: board)
        
        game.newGame(.HumanVersusHuman)
        
        if let position = position {
            game.takeTurnAtPosition(position)
        }
        
        return view
    }
    
    mutating func score() -> Int {
        switch gameView.gameStatus! {
        case .PlayerOneWins:
            return 10
        case .PlayerTwoWins:
            return -10
        default:
            return 0
        }
    }
}

struct TicTacToeGameTreeBot: TicTacToeBot {

    mutating func turnTakenAtBoardPosition(position: BoardPosition) {
        // NOTHING TO DO
    }
    
    mutating func nextMove(board: TicTacToeBoard) -> BoardPosition {
        
        guard board.lastTurn != nil else {
            return .TopLeft
        }
        
        return bestMove(board)
        
    }

    func bestMove(board: TicTacToeBoard) -> BoardPosition {
        var move = BoardPosition.TopLeft
        let rootNode = TicTacToeNode(board: board)
        _ = minimax(rootNode, outMove: &move)
        return move
        
    }
    
    func minimax(var node: TicTacToeNode, inout outMove move: BoardPosition, maximise: Bool = false, depth:Int = 9 ) -> Int {
        
        if depth == 0 || node.gameOver {
            let depthScore = (maximise) ? depth * -1 : depth
            return node.score() + depthScore
        }
        
        var moves = [BoardPosition]()
        var scores = [Int]()
        let children = node.children
        
        for child in children {
            let score = minimax(child, outMove: &move, maximise: !maximise, depth: depth - 1)
            if let position = child.position {
                scores.append(score)
                moves.append(position)
            }
        }
        
        if maximise {
            let max = scores.maxElement()!
            let indexOfMove = scores.indexOf(max)!
            move = moves[indexOfMove]
            return max
        } else {
            let min = scores.minElement()!
            let indexOfMove = scores.indexOf(min)!
            move = moves[indexOfMove]
            return min
        }

        
    }

}