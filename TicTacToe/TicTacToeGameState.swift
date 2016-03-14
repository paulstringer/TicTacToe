import Foundation

//MARK:- Game Player Strategy

private protocol GamePlayerStrategy {
    
    func finishTurn(game:TicTacToe)
    
    func declareVictory(game: TicTacToe)
    
}

extension GamePlayerStrategy {
    
    func finishTurn(game: TicTacToe) {
    }

    func declareVictory(game: TicTacToe) {
    }
    
}

//MARK:- Game Player Factory

protocol GamePlayerStateFactory {
    func humanOneUp(game: TicTacToe) -> GameState
    func humanTwoUp(game: TicTacToe) -> GameState
    func humanAgainstComputerUp(game: TicTacToe) -> GameState
    func computerUp(game: TicTacToe) -> (GameState, BoardPosition)
}

class TicTacToeGamePlayerStateFactory: GamePlayerStateFactory {
    
    func humanOneUp(game: TicTacToe) -> GameState {
        return Player(strategy: HumanOneUp( game: game, factory: self)  )
    }
    
    func humanTwoUp(game: TicTacToe) -> GameState {
        return Player( strategy: HumanTwoUp(game: game, factory: self) )
    }

    func humanAgainstComputerUp(game: TicTacToe) -> GameState {
        return Player( strategy: HumanOneAgainstComputerUp(game: game, factory: self) )
    }
    
    func computerUp(game: TicTacToe) -> (GameState, BoardPosition ) {
        let computer = ComputerUp(game: game, factory: self)
        return ( Player( strategy: computer ) , computer.computersTurn() )
    }
    
}

//MARK:- Game States

extension GameState {
    
    func takeTurn(game: TicTacToe, position: BoardPosition) {}
    
}

struct NewGame: GameState {
    
    init(game: TicTacToe) {
        game.view.gameStatus = .None
    }

}

struct Player: GameState {
    
    private let strategy: GamePlayerStrategy
    
    func takeTurn(game: TicTacToe, position: BoardPosition) {
        
        do {
            try game.board.takeTurnAtPosition(position)
        } catch {
            return
        }
        
        updateView(game)
        advanceGame(game)
        
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
            self.strategy.finishTurn(game)
        }
        
    }
    
    private func victory(game: TicTacToe) -> Bool{
        return BoardAnalyzer.victory(game.board)
    }
    
    private func stalemate(game: TicTacToe) -> Bool{
        return BoardAnalyzer.stalemate(game.board)
    }
    
    private func declareStalemate(game: TicTacToe) {
        game.state = Stalemate(game: game)
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
        let (player, turn) = factory.computerUp(game)
        game.state = player
        player.takeTurn(game, position: turn)
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

class ComputerUp: GamePlayerStrategy {

    let factory: GamePlayerStateFactory
    let game: TicTacToe
    
    init(game: TicTacToe, factory: GamePlayerStateFactory) {
        self.factory = factory
        self.game = game
    }
    
    func finishTurn(game: TicTacToe) {
        game.state = factory.humanAgainstComputerUp(game)
    }
    
    func declareVictory(game: TicTacToe) {
        game.state = GameOver(game: game, gameStatus: .ComputerWins)
    }

    func computersTurn() -> BoardPosition  {
        return game.bot.nextMove(self.game.board)
    }
    
//    func computersTurn( block: (BoardPosition) -> Void )  {
//        block(.TopLeft)
//    }
//    func takeTurnSync(player: Player) {
//        let turn = self.game.bot.nextMove(self.game.board)
//        player.takeTurn(self.game, position: turn)
//    }
//    
//    func takeTurnAsync(player: Player) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in
//            let turn = self.game.bot.nextMove(self.game.board)
//            dispatch_async(dispatch_get_main_queue()) { () -> Void in
//                player.takeTurn(self.game, position: turn)
//            }
//        }
//    }
    
}


