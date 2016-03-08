import Foundation

class TicTacToeNodeGameView: GameView {
    var gameTypes = [GameType]()
    var gameStatus: GameStatus = .None
    var gameBoard: GameBoard!
}

struct TicTacToeNode {
    
    lazy var children: [TicTacToeNode] = self.generateChildren()

    let position: BoardPosition?
    
    var gameOver: Bool {
        mutating get {
            switch gameView.gameStatus {
            case .PlayerOneUp, .PlayerTwoUp:
                return false
            default:
                return true
            }
        }
    }
    
    let gameBoard: GameBoard
    lazy var gameView: GameView = self.runGame()
    
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
        let game = TicTacToe(view: view)
        
        // Start a new game that allows us to take each turn
        game.newGame(.HumanVersusHuman)
        
        // Play all the positions on the board
        let allMarkedPositions = gameBoard.board
        for (index, marker) in allMarkedPositions.enumerate() {
            switch marker {
            case .None:
                break
            default:
                game.takeTurnAtPosition(index)
            }
        }
        
        // Play position for this nodes (except where it is the first)
        if let position = position {
            game.takeTurnAtPosition(position)
        }
        
        return view
    }
    
    mutating func score() -> Int {
        
        switch gameView.gameStatus {
        case .PlayerOneWins:
            return 10
        case .PlayerTwoWins:
            return -10
        default:
            return 0
        }
    }
}

struct TicTacToeMinimaxComputerVersusHumanBot: TicTacToeBot {

    mutating func turnTakenAtBoardPosition(position: BoardPosition) {
        // NOTHING TO DO
    }
    
    mutating func nextMove(board: TicTacToeBoard) -> BoardPosition {
        // TODO:
        var moves = [ (TicTacToeNode, Int) ]()
        var stop = false
        let rootNode = TicTacToeNode(board: board)
        let _ = negamax( rootNode, moves: &moves, stop: &stop )
        
        moves.sortInPlace { (lhs, rhs) -> Bool in
            let (_, lhsScore) = lhs
            let (_, rhsScore) = lhs
            return lhsScore > rhsScore
        }
        

        if let (node, _) = moves.first {
            return node.position!
        } else {
            fatalError()
        }
        
    }

    func negamax(var node: TicTacToeNode, inout moves: [(TicTacToeNode, Int)], inout stop: Bool ) -> Int {

        if node.gameOver {
            if node.gameView.gameStatus == .PlayerOneWins {
                stop = true
            }
            return node.score()
        }
        
        var bestValue = Int(INT_FAST16_MIN)
        
        for child in node.children {
            let v = -negamax(child, moves: &moves, stop: &stop)
            bestValue = max(bestValue, v)
            moves.append( (child, bestValue) )
            if stop {
                break
            }
        }
        
        return bestValue
        
        
    }

}