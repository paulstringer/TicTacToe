import Foundation

struct MinimaxGameBot: GameBot {
    
    let testable: Bool
    
    init(testable: Bool = false) {
        self.testable = testable
    }
    
    func nextMove(_ board: GameBoard, completion: @escaping GameBotCompletion){
        
        guard board.lastTurn != nil else {
            return completion(.topLeft)
        }

        calculateMove(board, completion: completion)
        
    }

    fileprivate func calculateMove(_ board: GameBoard, completion: @escaping GameBotCompletion) {
        
        if testable {
            completion( minimaxPositionForBoard(board) )
        } else {
            dispatchMoveCalculation(board, completion: completion)
        }
    }
    
    fileprivate func dispatchMoveCalculation(_ board: GameBoard, completion: @escaping GameBotCompletion) {
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: { () -> Void in
            let position = self.minimaxPositionForBoard(board)
            DispatchQueue.main.async(execute: { () -> Void in
                completion(position)
            })
        })
    }
    
    fileprivate func minimaxPositionForBoard(_ board: GameBoard) -> BoardPosition{
        
        var turnCount = 0
        let timeInterval = Date().timeIntervalSince1970
        
        let rootNode = TicTacToeNode(board: board)
        var position = BoardPosition.topLeft
        _ = self.minimax(rootNode, outMove: &position, turnCount: &turnCount)
        
        let timeTakenInterval = Date().timeIntervalSince1970 - timeInterval
        print("Calculating bot's position took \(turnCount) calculations (\(Int(timeTakenInterval)) seconds)")
        return position
    }
    
    
    private func minimax(_ node: TicTacToeNode, outMove move: inout BoardPosition, maximise: Bool = false, depth:Int = 8, turnCount: inout Int ) -> Int {
        var node = node
        
        turnCount = turnCount + 1
        
        if depth == 0 || node.gameOver {
            let depthScore = (maximise) ? depth * -1 : depth
            return node.score() + depthScore
        }
        
        var moves = [BoardPosition]()
        var scores = [Int]()
        let children = node.children
        
        for child in children {
            let score = minimax(child, outMove: &move, maximise: !maximise, depth: depth - 1, turnCount: &turnCount  )
            if let position = child.position {
                scores.append(score)
                moves.append(position)
            }
        }
        
        return bestScore(maximise, inMinimaxResult: (scores,moves), bestMove: &move )
        
    }
    
    func bestScore(_ maximise: Bool, inMinimaxResult result: (scores: [Int], moves: [BoardPosition]), bestMove: inout BoardPosition ) -> Int {
        
        let bestScore =  maximise ? result.scores.max()! : result.scores.min()!
        let indexOfBestMove = result.scores.index(of: bestScore)!
        bestMove = result.moves[indexOfBestMove]
        return bestScore
    }

}


class TicTacToeNodeGameView: GameView {
    
    var gameStatus: GameStatus!
    var gameBoard: GameBoard!
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
            var child = TicTacToeNode(board: board, move: move)
            nodes.append(child)
            if child.gameOver {
                break
            }
        }
        
        return nodes
        
    }
    
    func createGameView() -> GameView {
        
        let view = TicTacToeNodeGameView()
        let game = GameFactory(gameType: .humanVersusHuman).gameWithView(view, markers: gameBoard.markers)
        
        if let position = position {
            game.takeTurnAtPosition(position)
        }
        
        return view
    }
    
    mutating func score() -> Int {
        
        switch gameView.gameStatus! {
        case .playerOneWins:
            return 10
        case .playerTwoWins:
            return -10
        default:
            return 0
        }
    }
    
    
    var gameOver: Bool {
        
        mutating get {
            switch gameView.gameStatus! {
            case .playerOneUp, .playerTwoUp:
                return false
            default:
                return true
            }
        }
    }
}
