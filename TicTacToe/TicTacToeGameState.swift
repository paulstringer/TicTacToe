import Foundation

//MARK:- Game Player Strategy

private protocol GamePlayerStrategy {
    
    static func beginTurn(game: TicTacToe)
    
    func finishTurn(game:TicTacToe)
    
    func declareVictory(game: TicTacToe)
    
}

extension GamePlayerStrategy {
    
    func finishTurn(game: TicTacToe) {
    }

    func declareVictory(game: TicTacToe) {
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

    static func beginTurn(game: TicTacToe) {
        game.state = Player( strategy: HumanOneUp(game: game) )
    }

    func finishTurn(game: TicTacToe) {
        HumanTwoUp.beginTurn(game)
    }
    
    init(game: TicTacToe) {
        game.view.gameStatus = .PlayerOneUp
    }
    
    func declareVictory(game: TicTacToe) {
        game.state = GameOver(game: game, gameStatus: .PlayerOneWins)
    }

}

//MARK: Human One V Computer

struct HumanOneAgainstComputerUp: GamePlayerStrategy {
    
    static func beginTurn(game: TicTacToe) {
        game.state = Player( strategy: HumanOneAgainstComputerUp(game: game) )
    }
    
    init(game: TicTacToe) {
        game.view.gameStatus = .PlayerOneUp
    }
    
    func finishTurn(game: TicTacToe) {
        ComputerUp.beginTurn(game)
    }
    
    func declareVictory(game: TicTacToe) {
        game.state = GameOver(game: game, gameStatus: .PlayerOneWins)
    }
    
}

//MARK: Human Two

struct HumanTwoUp: GamePlayerStrategy {

    static func beginTurn(game: TicTacToe) {
        game.state = Player( strategy: HumanTwoUp(game: game) )
    }

    init(game: TicTacToe) {
        game.view.gameStatus = .PlayerTwoUp
    }

    func finishTurn(game: TicTacToe) {
        HumanOneUp.beginTurn(game)
    }

    func declareVictory(game: TicTacToe) {
        game.state = GameOver(game: game, gameStatus: .PlayerTwoWins)
    }

}


//MARK: Computer

class ComputerUp: GamePlayerStrategy {
    
    let game: TicTacToe
    
    static func beginTurn(game: TicTacToe) {
        let computer = ComputerUp(game: game)
        let player = Player( strategy: computer )
        computer.takeTurnAsync(player)
    }
    
    init(game: TicTacToe) {
        self.game = game
    }
    
    func finishTurn(game: TicTacToe) {
        HumanOneAgainstComputerUp.beginTurn(game)
    }
    
    func declareVictory(game: TicTacToe) {
        game.state = GameOver(game: game, gameStatus: .ComputerWins)
    }
    
    func takeTurnAsync(player: Player) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in
            let turn = self.game.bot.nextMove(self.game.board)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                player.takeTurn(self.game, position: turn)
            }
        }
    }
    
}


