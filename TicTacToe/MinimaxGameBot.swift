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
            dispatchMoveCalculation(board, completion: completion)
        }
    }
    
    private func dispatchMoveCalculation(board: GameBoard, completion: GameBotCompletion) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            let position = self.minimaxPositionForBoard(board)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(position)
            })
        })
    }
    
    private func minimaxPositionForBoard(board: GameBoard) -> BoardPosition{
        
        var turnCount = 0
        let timeInterval = NSDate().timeIntervalSince1970
        
        let rootNode = TicTacToeNode(board: board)
        var position = BoardPosition.TopLeft
        _ = self.minimax(rootNode, outMove: &position, turnCount: &turnCount)
        
        let timeTakenInterval = NSDate().timeIntervalSince1970 - timeInterval
        print("Calculating bot's position took \(turnCount) calculations (\(Int(timeTakenInterval)) seconds)")
        return position
    }
    
    
    private func minimax(var node: TicTacToeNode, inout outMove move: BoardPosition, maximise: Bool = false, depth:Int = 8, inout turnCount: Int ) -> Int {
        
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
    
    func bestScore(maximise: Bool, inMinimaxResult result: (scores: [Int], moves: [BoardPosition]), inout bestMove: BoardPosition ) -> Int {
        
        let bestScore =  maximise ? result.scores.maxElement()! : result.scores.minElement()!
        let indexOfBestMove = result.scores.indexOf(bestScore)!
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