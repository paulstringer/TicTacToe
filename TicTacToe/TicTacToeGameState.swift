import Foundation

protocol GameState {
    
    func setGameType(type: GameType, game: TicTacToe)
    
    func takeTurn(game: TicTacToe, position: BoardPosition)
    
    func finishTurn(game:TicTacToe)
    
    func declareVictory(game: TicTacToe)
    
}

extension GameState {
    
    //MARK: No-Op Defaults
    
    func finishTurn(game: TicTacToe) {
    }
    
    func declareVictory(game: TicTacToe) {
    }
    
    func setGameType(type: GameType, game: TicTacToe) {
    }
    
    //MARK: Shared Game State Mechanics
    
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

struct Stalemate: GameState {
    
    static func performTransition(game: TicTacToe) {
        game.state = Stalemate(game: game)
    }

    init(game: TicTacToe) {
        game.view.gameStatus = .Stalemate
    }
    
}

//MARK:- New Game

struct NewGame: GameState {
    
    static func performTransition(game: TicTacToe) {
        game.state = NewGame(game: game)
    }
    
    init(game: TicTacToe) {
        game.view.gameStatus = .None
    }
    
    func setGameType(type: GameType, game: TicTacToe) {
        
        let isFirstPlayersTurn = BoardAnalyzer.emptyPositions(game.board).count % 2 == 1
        
        switch type {
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

//MARK:- Human One

struct HumanOneUp: GameState  {
    
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

struct HumanOneAgainstComputerUp: GameState {
    
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

struct HumanTwoUp: GameState {
    
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

struct ComputerUp: GameState {
    
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

struct GameOver: GameState {
    
    static func performTransition(game: TicTacToe,  gameStatus: GameStatus) {
        game.state = GameOver()
        game.view.gameStatus = gameStatus
    }
    
    func takeTurn(game: TicTacToe, position: BoardPosition) {
    }
    
}

