import Foundation

enum GameType {
    
    case humanVersusHuman
    case humanVersusComputer
    case computerVersusHuman
    
    static var allValues: [GameType] {
        get {
            return [.humanVersusComputer, .computerVersusHuman, .humanVersusHuman]
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
    
    func gameWithView(_ view: GameView, markers: [BoardMarker]? = nil) -> Game {
        
        if let markers = markers {
            return restoreGameWithView(view, markers: markers)
        } else {
            return newGameWithView(view)
        }
    }
    
    fileprivate func restoreGameWithView(_ view: GameView, markers: [BoardMarker]) -> TicTacToe {

        let board = TicTacToeBoard(markers: markers)
        let game = TicTacToe(view: view, board: board)
        return startGameAndRenderInitialView(game)
       
    }
    
    fileprivate func newGameWithView(_ view: GameView) -> TicTacToe {
        
        let game: TicTacToe = TicTacToe(view: view)
        return startGameAndRenderInitialView(game)
        
    }
    
    fileprivate func startGameAndRenderInitialView(_ game: TicTacToe) -> TicTacToe {
        
        game.view.gameBoard = game.board
        return startGame(game)
    }
    
    fileprivate func startGame(_ game: TicTacToe) -> TicTacToe {
        
        let factory = TicTacToeGamePlayerStateFactory(gameBot: bot)
        
        let isFirstPlayersTurn = BoardAnalyzer.emptyPositions(game.board).count % 2 == 1
        
        switch gameType {

        case .humanVersusHuman:
            game.state = factory.humanOneUp(game)
            
            
        case .humanVersusComputer where isFirstPlayersTurn:
            game.state = factory.humanAgainstComputerUp(game)
            
        case .humanVersusComputer where !isFirstPlayersTurn:
            let computer = factory.computerUp(game)
            startGame(game, againstComputer: computer)
            
            
        case .computerVersusHuman where isFirstPlayersTurn:
            let computer = factory.computerUp(game)
            startGame(game, againstComputer: computer)
            
        case .computerVersusHuman where !isFirstPlayersTurn:
            game.state = factory.humanAgainstComputerUp(game)
            
            
        default:
            break
        }
        
        return game
        
    }
    
    fileprivate func startGame(_ game: TicTacToe, againstComputer computer: Player) {
        
        game.state = computer
        computer.takeBotTurn(game)
    }
    
}


