import Foundation

enum GameType {
    
    case HumanVersusHuman
    case HumanVersusComputer
    case ComputerVersusHuman
    
    static var allValues: [GameType] {
        get {
            return [.HumanVersusComputer, .ComputerVersusHuman, .HumanVersusHuman]
        }
    }
    
}

class GameFactory {
    
    let bot: GameBot
    var gameType: GameType
    
    init(gameType: GameType = GameType.allValues.first!, bot: GameBot = MinimaxGameBot()) {
        self.gameType = gameType
        self.bot = bot
    }
    
    func gameWithView(view: GameView, markers: [BoardMarker]? = nil) -> Game {
        if let markers = markers {
            return restoredGameWithView(view, markers: markers)
        } else {
            return newGameWithView(view)
        }
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
        
        let factory = TicTacToeGamePlayerStateFactory(gameBot: bot)
        
        let isFirstPlayersTurn = BoardAnalyzer.emptyPositions(game.board).count % 2 == 1
        
        switch gameType {
        case .HumanVersusHuman:
            game.state = factory.humanOneUp(game)
            
        case .HumanVersusComputer where isFirstPlayersTurn:
            game.state = factory.humanAgainstComputerUp(game)
            
        case .HumanVersusComputer where !isFirstPlayersTurn:
            let computer = factory.computerUp(game)
            startGame(game, againstComputer: computer)
            
        case .ComputerVersusHuman where isFirstPlayersTurn:
            let computer = factory.computerUp(game)
            startGame(game, againstComputer: computer)
            
        case .ComputerVersusHuman where !isFirstPlayersTurn:
            game.state = factory.humanAgainstComputerUp(game)
            
        default:
            break
        }
        
    }
    
    private func startGame(game: TicTacToe, againstComputer computer: Player) {
        game.state = computer
        computer.takeBotTurn(game)
    }
    
}


