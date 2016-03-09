import Foundation

class TicTacToeNodeGameView: GameView {
    var gameTypes = [GameType]()
    var gameStatus: GameStatus = .None
    var gameBoard: GameBoard!
}

struct TicTacToeNode {
    
    lazy var children: [TicTacToeNode] = {
     
        self.generateChildren()
        
    }()

    let position: BoardPosition?
    
    var gameOver: Bool {
        mutating get {
            switch gameView.gameStatus {
            case .PlayerOneUp, .PlayerTwoUp:
                return false
            default:
                print("Game Over \(gameView.gameStatus)")
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
        
        print("Added \(nodes.count) moves from this position \(position)")
        
        return nodes
        
    }
    
    func runGame() -> GameView {
        
        // Create a new game at the current position
        let view = TicTacToeNodeGameView()
        let board = TicTacToeBoard(board: gameBoard.board)
        let game = TicTacToe(view: view, board: board)
        
        // Play the Game Manually
        game.newGame(.HumanVersusHuman)
        
        // Play position for this nodes (except where it is root first)
        if let position = position {
            game.takeTurnAtPosition(position)
        }
        
        return view
    }
    
    mutating func score() -> Int {
        
        // http://www3.ntu.edu.sg/home/ehchua/programming/java/JavaGame_TicTacToe_AI.html
        
        // BASE THE SCORE ON CURRENT BOARD STATE NOT A FINAL GAME STATE
        
//        +100 for EACH 3-in-a-line for computer.
//        +10 for EACH 2-in-a-line (with a empty cell) for computer.
//        +1 for EACH 1-in-a-line (with two empty cells) for computer.
//        
//        if gameView.gameBoard.hasCompleteLine() {
//            
//        }
//        
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

struct TicTacToeMinimaxBot: TicTacToeBot {

    mutating func turnTakenAtBoardPosition(position: BoardPosition) {
        // NOTHING TO DO
    }
    
    mutating func nextMove(board: TicTacToeBoard) -> BoardPosition {
        
        
        var move = BoardPosition.TopLeft
        
        guard board.lastTurn != nil else {
            return move
        }
        
        let rootNode = TicTacToeNode(board: board)
        let _ = minimax( rootNode, move: &move)
        return move
        
    }

    func minimax(var node: TicTacToeNode, inout move: BoardPosition, maximisePlayer: Bool = false, depth:Int = 9 ) -> Int {

        print("Executing Minimax on Parent Node \(node.position) Depth=\(depth)")
        
        if depth == 0 || node.gameOver {
            print("--- !!!Reached Leaf (Game Over) with Score \(node.score()) Depth=\(depth)!!!")
            return node.score()
        }
        
        var moves = [TicTacToeNode]()
        var scores = [Int]()
        var childIndex = 0
        let children = node.children
        for (index, child) in children.enumerate() {
            print("--- Processing Child \(index)/\(node.children.count) node \(node.position) Depth \(depth)")
            let score = minimax(child, move: &move, maximisePlayer: !maximisePlayer, depth: depth - 1)
            scores.append(score)
            moves.append(child)
            print("--- Score Received for Minimax (Count=\(scores.count)) of Node \(node.position) Depth \(depth))")
            childIndex++
        }
        
        print("--- Children Exhausted \(childIndex)/\(node.children.count)")
        
        if maximisePlayer {
            let max = scores.maxElement()!
            let indexOfMove = scores.indexOf(max)!
            move = moves[indexOfMove].position!
            return max
        } else {
            let min = scores.minElement()!
            let indexOfMove = scores.indexOf(min)!
            move = moves[indexOfMove].position!
            return min
        }
        
        
    }

}