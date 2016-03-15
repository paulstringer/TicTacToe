import Foundation

//MARK:- Game Player Strategy

private protocol GamePlayerStrategy {
    
    func finishTurn(game:TicTacToe)
    
    func declareVictory(game: TicTacToe)
    
    var ignoreTurns: Bool { get }
    
}

extension GamePlayerStrategy {
    
    // Default No-Op Implementations
    
    func finishTurn(game: TicTacToe) {}

    func declareVictory(game: TicTacToe) {}
    
    var ignoreTurns: Bool  {
        get {
            return false
        }
    }
    
}

private protocol GameBotStrategy: GamePlayerStrategy {
    
    func calculateNextPosition(completion: GameBotCompletion)
    
}

//MARK:- Game Player Factory

protocol GamePlayerStateFactory {
    
    func humanOneUp(game: TicTacToe) -> Player
    
    func humanTwoUp(game: TicTacToe) -> Player
    
    func humanAgainstComputerUp(game: TicTacToe) -> Player
    
    func computerUp(game: TicTacToe) -> Player
}

class TicTacToeGamePlayerStateFactory: GamePlayerStateFactory {
    
    let gameBot: GameBot
    
    init(gameBot: GameBot) {
        self.gameBot = gameBot
    }
    
    func humanOneUp(game: TicTacToe) -> Player {
        return Player(strategy: HumanOneUp( game: game, factory: self)  )
    }
    
    func humanTwoUp(game: TicTacToe) -> Player {
        return Player( strategy: HumanTwoUp(game: game, factory: self) )
    }

    func humanAgainstComputerUp(game: TicTacToe) -> Player {
        return Player( strategy: HumanOneAgainstComputerUp(game: game, factory: self) )
    }
    
    func computerUp(game: TicTacToe) -> Player {
        return Player( strategy: ComputerUp(game: game, gameBot:gameBot, factory: self) )
    }
    
}

//MARK:- Game States

extension GameState {
    
    // Default GameState Implementation
    
    func takeTurn(game: TicTacToe, position: BoardPosition) {
        // No-Op
    }
    
    private func declareStalemate(game: TicTacToe) {
        game.state = Stalemate(game: game)
    }
    
}


struct Player: GameState {
    
    private let strategy: GamePlayerStrategy
    
    //MARK: Game State API
    
    func takeTurn(game: TicTacToe, position: BoardPosition) {
        
        guard tryTurn(game, atPosition: position) else {
            return
        }
   
        updateView(game)
        
        advanceGame(game)
        
    }
    
    //MARK: Bot Player API
    
    func takeBotTurn(game: TicTacToe) {
        
        guard let bot = strategy as? GameBotStrategy else {
            return
        }

        bot.calculateNextPosition { (position) -> Void in
            self.takeTurn(game, position: position)
        }
    }
    
    //MARK: Private API
    
    private func tryTurn(game: TicTacToe, atPosition position: BoardPosition) -> Bool {
        
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
    
    private func updateView(game: TicTacToe) {
        game.view.gameBoard = game.board
    }
    
    private func advanceGame(game: TicTacToe) {
        
        if victory(game) {
            strategy.declareVictory(game)
        } else if stalemate(game) {
            declareStalemate(game)
        } else {
            strategy.finishTurn(game)
        }
        
    }
    
    private func victory(game: TicTacToe) -> Bool {
        return BoardAnalyzer.victory(game.board).result
    }
    
    private func stalemate(game: TicTacToe) -> Bool{
        return BoardAnalyzer.stalemate(game.board)
    }
    
    
}

struct NewGame: GameState {
    
    init(game: TicTacToe) {
        game.view.gameStatus = .None
        game.view.gameBoard = game.board
    }
    
}

struct Stalemate: GameState {
    
    init(game: TicTacToe) {
        game.view.gameStatus = .Stalemate
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
        game.view.gameStatus = .PlayerOneUp
    }

    func finishTurn(game: TicTacToe) {
        game.state = factory.humanTwoUp(game)
    }
    
    func declareVictory(game: TicTacToe) {
        game.state = GameOver(game: game, gameStatus: .PlayerOneWins)
    }

}

//MARK: Human One V Computer

struct HumanOneAgainstComputerUp: GamePlayerStrategy {

    let factory: GamePlayerStateFactory
    
    init(game: TicTacToe, factory: GamePlayerStateFactory) {
        self.factory = factory
        game.view.gameStatus = .PlayerOneUp
    }
    
    func finishTurn(game: TicTacToe) {
        let computersTurn = factory.computerUp(game)
        game.state = computersTurn
        computersTurn.takeBotTurn(game)
    }
    
    func declareVictory(game: TicTacToe) {
        game.state = GameOver(game: game, gameStatus: .PlayerOneWins)
    }
    
}

//MARK: Human Two

struct HumanTwoUp: GamePlayerStrategy {

    let factory: GamePlayerStateFactory

    init(game: TicTacToe, factory: GamePlayerStateFactory) {
        self.factory = factory
        game.view.gameStatus = .PlayerTwoUp
    }

    func finishTurn(game: TicTacToe) {
        game.state = factory.humanOneUp(game)
    }

    func declareVictory(game: TicTacToe) {
        game.state = GameOver(game: game, gameStatus: .PlayerTwoWins)
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
        game.view.gameStatus = .ComputerUp
    }
    
    func finishTurn(game: TicTacToe) {
        game.state = factory.humanAgainstComputerUp(game)
    }
    
    func declareVictory(game: TicTacToe) {
        game.state = GameOver(game: game, gameStatus: .ComputerWins)
    }
    
    func calculateNextPosition(completion: GameBotCompletion )  {
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
    func nextMove(board: GameBoard, completion: GameBotCompletion)
}
