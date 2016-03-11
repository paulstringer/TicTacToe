import Foundation


class GameBuilder {
    
    static let GameTypes = GameType.allValues
    
    var gameType: GameType
    
    init(gameType: GameType = GameBuilder.GameTypes.first!) {
        self.gameType = gameType
    }
    
    func gameWithView(view: GameView, markers: [BoardMarker]? = nil) -> TicTacToe {
        
        if let markers = markers {
            return restoredGameWithView(view, markers: markers)
        } else {
            return newGameWithView(view)
        }
    }
    
    private func newGameWithView(view: GameView) -> TicTacToe {
        
        let game: TicTacToe = TicTacToe(view: view)
        startGameAndRenderInitialView(game)
        
        return game
    }
    
    func restoredGameWithView(view: GameView, markers: [BoardMarker]) -> TicTacToe {

        let board = TicTacToeBoard(markers: markers)
        let game = TicTacToe(view: view, board: board)
        startGameAndRenderInitialView(game)
        
        return game
       
    }
    
    private func startGameAndRenderInitialView(game: TicTacToe) -> TicTacToe {
        startGame(game)
        game.view.gameBoard = game.board
        return game
    }
    
    private func startGame(game: TicTacToe) {
        
        let isFirstPlayersTurn = BoardAnalyzer.emptyPositions(game.board).count % 2 == 1
        
        switch gameType {
        case .HumanVersusHuman:
            HumanOneUp.performTransition(game)
            
        case .HumanVersusComputer where isFirstPlayersTurn:
            HumanOneAgainstComputerUp.performTransition(game)
        case .HumanVersusComputer where !isFirstPlayersTurn:
            ComputerUp.performTransition(game)
            
        case .ComputerVersusHuman where isFirstPlayersTurn:
            ComputerUp.performTransition(game)
        case .ComputerVersusHuman where !isFirstPlayersTurn:
            HumanOneAgainstComputerUp.performTransition(game)
            
        default:
            break
        }
        
    }
    
}


typealias GameTypeValue = String

enum GameType: GameTypeValue {
    
    case HumanVersusHuman       = "HumanVersusHuman"
    case HumanVersusComputer    = "HumanVersusComputer"
    case ComputerVersusHuman    = "ComputerVersusHuman"
    
    static var allValues: [GameType] {
        get {
            return [.HumanVersusHuman, .HumanVersusComputer, .ComputerVersusHuman]
        }
    }
    
}