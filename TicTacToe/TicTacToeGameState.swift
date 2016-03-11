import Foundation

protocol GameInternalState {
    
    func takeTurn(game: TicTacToe, position: BoardPosition)
    
    func finishTurn(game:TicTacToe)
    
    func declareVictory(game: TicTacToe)
    
}

extension GameInternalState {
    
    //MARK: No-Op Defaults
    
    func finishTurn(game: TicTacToe) {
    }
    
    func declareVictory(game: TicTacToe) {
    }
    
    //MARK: Turn Taking
    
    func takeTurn(game: TicTacToe, position: BoardPosition) {

        do {
            try game.board.takeTurnAtPosition(position)
            game.view.gameBoard = game.board
        } catch {
            return
        }
        
        if victory(game) {
            declareVictory(game)
        } else if stalemate(game) {
            declareStalemate(game)
        } else {
            finishTurn(game)
        }
        
    }
    
    // MARK: End Game Operations
    
    private func victory(game: TicTacToe) -> Bool{
        return BoardAnalyzer.victory(game.board)
    }
    
    private func stalemate(game: TicTacToe) -> Bool{
        return BoardAnalyzer.stalemate(game.board)
    }
    
    private func declareStalemate(game: TicTacToe) {
        Stalemate.performTransition(game)
    }
}

//MARK:- Stalemate

struct Stalemate: GameInternalState {
    
    static func performTransition(game: TicTacToe) {
        game.state = Stalemate(game: game)
    }

    init(game: TicTacToe) {
        game.view.gameStatus = .Stalemate
    }
    
}

//MARK:- New Game

struct NewGame: GameInternalState {
    
    static func performTransition(game: TicTacToe) {
        game.state = NewGame(game: game)
    }
    
    init(game: TicTacToe) {
        game.view.gameStatus = .None
    }

}

//MARK:- Human One

struct HumanOneUp: GameInternalState  {
    
    static func performTransition(game: TicTacToe) {
        game.state = HumanOneUp(game: game)
    }
    
    init(game: TicTacToe) {
        game.view.gameStatus = .PlayerOneUp
    }
    
    func finishTurn(game: TicTacToe) {
        HumanTwoUp.performTransition(game)
    }
    
    func declareVictory(game: TicTacToe) {
        GameOver.performTransition(game, gameStatus: .PlayerOneWins)
    }
    
}

//MARK:- Human One V Computer

struct HumanOneAgainstComputerUp: GameInternalState {
    
    static func performTransition(game: TicTacToe) {
        game.state = HumanOneAgainstComputerUp(game: game)
    }
    
    init(game: TicTacToe) {
        game.view.gameStatus = .PlayerOneUp
    }
    
    func finishTurn(game: TicTacToe) {
        ComputerUp.performTransition(game)
    }
    
    func declareVictory(game: TicTacToe) {
        game.view.gameStatus = .ComputerWins // Looks like a bug?
    }
    
}

//MARK:- Human Two

struct HumanTwoUp: GameInternalState {
    
    static func performTransition(game: TicTacToe) {
        game.state = HumanTwoUp(game: game)
    }
    
    init(game: TicTacToe) {
        game.view.gameStatus = .PlayerTwoUp
    }
    
    func finishTurn(game: TicTacToe) {
        HumanOneUp.performTransition(game)
    }
    
    func declareVictory(game: TicTacToe) {
        GameOver.performTransition(game, gameStatus: .PlayerTwoWins)
    }
    
}

//MARK:- Computer

struct ComputerUp: GameInternalState {
    
    static func performTransition(game: TicTacToe) {
        
        let computer = ComputerUp()
        computer.takeComputersTurn(game)
    }
    
    func finishTurn(game: TicTacToe) {
        HumanOneAgainstComputerUp.performTransition(game)
    }
    
    func declareVictory(game: TicTacToe) {
        GameOver.performTransition(game, gameStatus: .ComputerWins)
    }
    
    func takeComputersTurn(game: TicTacToe) {
        
        let board = game.board
        
        let position = game.bot.nextMove(board)
        
        takeTurn(game, position: position)
        
    }
    
}

//MARK:- Game Over

struct GameOver: GameInternalState {
    
    static func performTransition(game: TicTacToe,  gameStatus: GameStatus) {
        game.state = GameOver()
        game.view.gameStatus = gameStatus
    }
    
    func takeTurn(game: TicTacToe, position: BoardPosition) {
    }
    
}

