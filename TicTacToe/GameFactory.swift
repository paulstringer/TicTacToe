import Foundation

enum GameType {
    
    case HumanVersusHuman
    case HumanVersusComputer
    case ComputerVersusHuman
    
    static var allValues: [GameType] {
        get {
            return [.HumanVersusHuman, .HumanVersusComputer, .ComputerVersusHuman]
        }
    }
    
}

class GameFactory {
    
    static let GameTypes = GameType.allValues
    
    var gameType: GameType
    
    init(gameType: GameType = .ComputerVersusHuman) {
        self.gameType = gameType
    }
    
    func gameWithView(view: GameView) -> Game {
        return newGameWithView(view)
    }
    
    func gameWithView(view: GameView, markers: [BoardMarker]) -> Game {
        return restoredGameWithView(view, markers: markers)
    }
    
    private func restoredGameWithView(view: GameView, markers: [BoardMarker]) -> TicTacToe {

        let board = TicTacToeBoard(markers: markers)
        let game = TicTacToe(view: view, board: board)
        startGameAndRenderInitialView(game)
        
        return game
       
    }
    
    private func newGameWithView(view: GameView) -> TicTacToe {
        
        let game: TicTacToe = TicTacToe(view: view)
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
            HumanOneUp.beginTurn(game)
            
        case .HumanVersusComputer where isFirstPlayersTurn:
            HumanOneAgainstComputerUp.beginTurn(game)
            
        case .HumanVersusComputer where !isFirstPlayersTurn:
            ComputerUp.beginTurn(game)
            
        case .ComputerVersusHuman where isFirstPlayersTurn:
            ComputerUp.beginTurn(game)
            
        case .ComputerVersusHuman where !isFirstPlayersTurn:
            HumanOneAgainstComputerUp.beginTurn(game)
            
        default:
            break
        }
        
    }
    
}


