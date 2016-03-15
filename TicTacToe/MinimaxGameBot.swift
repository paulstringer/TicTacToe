import Foundation


struct MinimaxGameBot: GameBot {
    
    let testable: Bool
    
    init(testable: Bool = false) {
        self.testable = testable
    }
    
    func nextMove(board: GameBoard, completion: GameBotCompletion){
        
        guard board.lastTurn != nil else {
            return completion(.TopLeft)
        }

        calculateMove(board, completion: completion)
        
    }

    private func calculateMove(board: GameBoard, completion: GameBotCompletion) {
        if testable {
            completion( minimaxPositionForBoard(board) )
        } else {
            dispatchBackground(board, completion: completion)
        }
    }
    
    private func dispatchBackground(board: GameBoard, completion: GameBotCompletion) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            let position = self.minimaxPositionForBoard(board)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(position)
            })
        })
    }
    
    private func minimaxPositionForBoard(board: GameBoard) -> BoardPosition{
        let rootNode = TicTacToeNode(board: board)
        var position = BoardPosition.TopLeft
        _ = self.minimax(rootNode, outMove: &position)
        return position
    }
    
    private func minimax(var node: TicTacToeNode, inout outMove move: BoardPosition, maximise: Bool = false, depth:Int = 9 ) -> Int {
        
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


class TicTacToeNodeGameView: GameView {
    var gameStatus: GameStatus!
    var gameBoard: GameBoard!
    var gameWinningLine: BoardLine?
}

struct TicTacToeNode {
    
    let gameBoard: GameBoard
    let position: BoardPosition?
    
    lazy var gameView: GameView = self.createGameView()
    lazy var children: [TicTacToeNode] = self.generateChildren()
    
    init(board: GameBoard, move: BoardPosition? = nil) {
        self.position = move
        self.gameBoard = board
    }
    
    mutating func generateChildren() -> [TicTacToeNode] {
        
        var nodes = [TicTacToeNode]()
        let board = gameView.gameBoard
        let remainingMoves = BoardAnalyzer.emptyPositions(board)
        
        for move in remainingMoves {
            let child = TicTacToeNode(board: board, move: move)
            nodes.append(child)
        }
        
        return nodes
        
    }
    
    func createGameView() -> GameView {
        
        let view = TicTacToeNodeGameView()
        let game = GameFactory(gameType: .HumanVersusHuman).gameWithView(view, markers: gameBoard.markers)
        
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
}