import Foundation

//MARK:- Game Player Strategy

private protocol GamePlayerStrategy {
    
    func finishTurn(_ game:TicTacToe)
    
    func declareVictory(_ game: TicTacToe)
    
    var ignoreTurns: Bool { get }
    
}

extension GamePlayerStrategy {
    
    // Default No-Op Implementations
    
    func finishTurn(_ game: TicTacToe) {}

    func declareVictory(_ game: TicTacToe) {}
    
    var ignoreTurns: Bool  {
        get {
            return false
        }
    }
    
}

private protocol GameBotStrategy: GamePlayerStrategy {
    
    func calculateNextPosition(_ completion: @escaping GameBotCompletion)
    
}

//MARK:- Game Player Factory

protocol GamePlayerStateFactory {
    
    func humanOneUp(_ game: TicTacToe) -> Player
    
    func humanTwoUp(_ game: TicTacToe) -> Player
    
    func humanAgainstComputerUp(_ game: TicTacToe) -> Player
    
    func computerUp(_ game: TicTacToe) -> Player
}

class TicTacToeGamePlayerStateFactory: GamePlayerStateFactory {
    
    let gameBot: GameBot
    
    init(gameBot: GameBot) {
        self.gameBot = gameBot
    }
    
    func humanOneUp(_ game: TicTacToe) -> Player {
        return Player(strategy: HumanOneUp( game: game, factory: self)  )
    }
    
    func humanTwoUp(_ game: TicTacToe) -> Player {
        return Player( strategy: HumanTwoUp(game: game, factory: self) )
    }

    func humanAgainstComputerUp(_ game: TicTacToe) -> Player {
        return Player( strategy: HumanOneAgainstComputerUp(game: game, factory: self) )
    }
    
    func computerUp(_ game: TicTacToe) -> Player {
        return Player( strategy: ComputerUp(game: game, gameBot:gameBot, factory: self) )
    }
    
}

//MARK:- Game States

extension GameState {
    
    // Default GameState Implementation
    
    func takeTurn(_ game: TicTacToe, position: BoardPosition) {
        // No-Op
    }
    
    fileprivate func declareStalemate(_ game: TicTacToe) {
        game.state = Stalemate(game: game)
    }
    
}


struct Player: GameState {
    
    fileprivate let strategy: GamePlayerStrategy
    
    //MARK: Game State API
    
    func takeTurn(_ game: TicTacToe, position: BoardPosition) {
        
        guard tryTurn(game, atPosition: position) else {
            return
        }
   
        updateView(game)
        
        advanceGame(game)
        
    }
    
    //MARK: Bot Player API
    
    func takeBotTurn(_ game: TicTacToe) {
        
        guard let bot = strategy as? GameBotStrategy else {
            return
        }

        bot.calculateNextPosition { (position) -> Void in
            self.takeTurn(game, position: position)
        }
    }
    
    //MARK: Private API
    
    fileprivate func tryTurn(_ game: TicTacToe, atPosition position: BoardPosition) -> Bool {
        
        guard strategy.ignoreTurns == false else {
            return false
        }
        
        do {
            try game.board.takeTurnAtPosition(position)
        } catch {
            return false
        }
        
        return true
        
    }
    
    fileprivate func updateView(_ game: TicTacToe) {
        game.view.gameBoard = game.board
    }
    
    fileprivate func advanceGame(_ game: TicTacToe) {
        
        if victory(game) {
            strategy.declareVictory(game)
        } else if stalemate(game) {
            declareStalemate(game)
        } else {
            strategy.finishTurn(game)
        }
        
    }
    
    fileprivate func victory(_ game: TicTacToe) -> Bool {
        return BoardAnalyzer.victory(game.board).result
    }
    
    fileprivate func stalemate(_ game: TicTacToe) -> Bool{
        return BoardAnalyzer.stalemate(game.board)
    }
    
    
}

struct NewGame: GameState {
    
    init(game: TicTacToe) {
        game.view.gameStatus = .none
        game.view.gameBoard = game.board
    }
    
}

struct Stalemate: GameState {
    
    init(game: TicTacToe) {
        game.view.gameStatus = .stalemate
    }
    
}

struct GameOver: GameState {

    init(game: TicTacToe, gameStatus: GameStatus) {
        game.view.gameStatus = gameStatus
    }
    
}


//MARK:- Game Players

//MARK: Human One

struct HumanOneUp: GamePlayerStrategy  {

    let factory: GamePlayerStateFactory

    init(game: TicTacToe, factory: GamePlayerStateFactory) {
        self.factory = factory
        game.view.gameStatus = .playerOneUp
    }

    func finishTurn(_ game: TicTacToe) {
        game.state = factory.humanTwoUp(game)
    }
    
    func declareVictory(_ game: TicTacToe) {
        game.state = GameOver(game: game, gameStatus: .playerOneWins)
    }

}

//MARK: Human One V Computer

struct HumanOneAgainstComputerUp: GamePlayerStrategy {

    let factory: GamePlayerStateFactory
    
    init(game: TicTacToe, factory: GamePlayerStateFactory) {
        self.factory = factory
        game.view.gameStatus = .playerOneUp
    }
    
    func finishTurn(_ game: TicTacToe) {
        let computersTurn = factory.computerUp(game)
        game.state = computersTurn
        computersTurn.takeBotTurn(game)
    }
    
    func declareVictory(_ game: TicTacToe) {
        game.state = GameOver(game: game, gameStatus: .playerOneWins)
    }
    
}

//MARK: Human Two

struct HumanTwoUp: GamePlayerStrategy {

    let factory: GamePlayerStateFactory

    init(game: TicTacToe, factory: GamePlayerStateFactory) {
        self.factory = factory
        game.view.gameStatus = .playerTwoUp
    }

    func finishTurn(_ game: TicTacToe) {
        game.state = factory.humanOneUp(game)
    }

    func declareVictory(_ game: TicTacToe) {
        game.state = GameOver(game: game, gameStatus: .playerTwoWins)
    }

}


//MARK: Computer

struct ComputerUp: GameBotStrategy {

    let factory: GamePlayerStateFactory
    let game: TicTacToe
    let gameBot: GameBot
 
    init(game: TicTacToe, gameBot: GameBot, factory: GamePlayerStateFactory) {
        self.factory = factory
        self.gameBot = gameBot
        self.game = game
        game.view.gameStatus = .computerUp
    }
    
    func finishTurn(_ game: TicTacToe) {
        game.state = factory.humanAgainstComputerUp(game)
    }
    
    func declareVictory(_ game: TicTacToe) {
        game.state = GameOver(game: game, gameStatus: .computerWins)
    }
    
    func calculateNextPosition(_ completion: @escaping GameBotCompletion )  {
        game.state = Player( strategy: ComputerThinking() )
        gameBot.nextMove(game.board) { (position) in
            self.game.state = self.factory.computerUp(self.game)
            completion(position)
        }
    }

}

struct ComputerThinking: GamePlayerStrategy {
    
    var ignoreTurns: Bool  {
        get {
            return true
        }
    }

}

typealias GameBotCompletion = (BoardPosition) -> Void

protocol GameBot {
    func nextMove(_ board: GameBoard, completion: @escaping GameBotCompletion)
}
