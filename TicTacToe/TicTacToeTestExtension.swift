import XCTest

@testable import TicTacToe

protocol TicTacToeTestCase: class {
    var view: GameView! { get set }
    var game: TicTacToe! { get set }
    var bot: TicTacToeBot? { get set }
}

extension TicTacToeTestCase {
    
    func takeTurnsAtPositions(positions: [BoardPosition.RawValue]) {
        
        for position in positions {
            game.takeTurnAtPosition(position)
        }
    }

    func newGame(type: GameType, bot: TicTacToeBot? = nil, markers: [BoardMarker]? = nil) {

        self.view = GameViewSpy()
        self.bot = bot
        
        setUpGame(markers)
        
        game.newGame(type)
    }

    private func setUpGame(markers: [BoardMarker]?) {
        
        if let markers = markers {
            let board = TicTacToeBoard(board:markers)
            self.game = TicTacToe(view: view, board: board)
        } else {
            self.game = TicTacToe(view: view)
        }
        
        
        if let bot = self.bot {
            game.bot = bot
        }
        
    }
    
    func playGamesAssertingComputersSuperiority(type: GameType) -> Bool {
        
        var computerWinCount = 0
        var stalemateCount = 0
        var humanWinCount = 0
        var gameCount = 0
        
        for ; gameCount < 100; gameCount++ {
            
            while view.gameStatus == .PlayerOneUp {
                let positionIndex = Int(arc4random_uniform(UInt32(view.gameBoard.emptyPositions.count)))
                let position = view.gameBoard.emptyPositions[positionIndex]
                game.takeTurnAtPosition(position)
            }
            
            switch view.gameStatus{
            case .ComputerWins:
                computerWinCount++
            case .Stalemate:
                stalemateCount++
            case .PlayerOneWins, .PlayerTwoWins:
                humanWinCount++
            default:
                break
            }
            
            XCTAssertNotEqual(view.gameStatus, GameStatus.PlayerOneWins)
            XCTAssertNotEqual(view.gameStatus, GameStatus.PlayerTwoWins)
            
            newGame(type, bot: self.bot)
        }
        
        print("Played \(gameCount) Games with \(computerWinCount) Computer Wins, \(stalemateCount) Stalemates, Humans Wins=\(humanWinCount) (0 expected)")
        
        return humanWinCount == 0

    }
    
}
