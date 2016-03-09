import XCTest

@testable import TicTacToe

protocol TicTacToeTestCase: class {
    var view: GameView! { get set }
    var game: TicTacToe! { get set }
}

extension TicTacToeTestCase {
    
    func takeTurnsAtPositions(positions: [BoardPosition.RawValue]) {
        
        for position in positions {
            game.takeTurnAtPosition(position)
        }
    }

    func newGame(type: GameType, bot: TicTacToeBot? = nil, markers: [BoardMarker]? = nil) {

        view = GameViewSpy()
        
        if let markers = markers {
            let board = TicTacToeBoard(board:markers)
            game = TicTacToe(view: view, board: board)
        } else {
            game = TicTacToe(view: view)
        }

        
        if let bot = bot {
            game.bot = bot
        }

     
        
        game.newGame(type)
     
        
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
            
            newGame(type)
        }
        
        print("Played \(gameCount) Games with \(computerWinCount) Computer Wins, \(stalemateCount) Stalemates, Humans Wins=\(humanWinCount) (0 expected)")
        
        return humanWinCount == 0

    }
    
}
