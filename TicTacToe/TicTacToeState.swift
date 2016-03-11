import Foundation

protocol TicTacToeState {
    
    func setGameType(type: GameType, game: TicTacToe)
    
    func takeTurn(game: TicTacToe, position: BoardPosition)
    
    // PRIVATE
    
    func finishTurn(game:TicTacToe)
    
    func declareVictory(game: TicTacToe)
    
}

extension TicTacToeState {
    
    //MARK: No-Op Default Implementations
    
    func declareVictory(game: TicTacToe) {
    }
    
    func finishTurn(game: TicTacToe) {
    }
    
    func setGameType(type: GameType, game: TicTacToe) {
    }
    
    //MARK: Game Mechanics
    
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
        return game.board.hasCompleteLine()
    }
    
    private func stalemate(game: TicTacToe) -> Bool{
        return game.board.isFull()
    }
    
    private func declareStalemate(game: TicTacToe) {
        TicTacToeStalemate.performTransition(game)
    }
}


//MARK:- Stalemate

struct TicTacToeStalemate: TicTacToeState {
    
    static func performTransition(game: TicTacToe) {
        game.state = TicTacToeStalemate(game: game)
    }

    init(game: TicTacToe) {
        game.view.gameStatus = .Stalemate
    }
    
}

//MARK:- New Game

struct TicTacToeNewGame: TicTacToeState {
    
    static func performTransition(game: TicTacToe) {
        game.state = TicTacToeNewGame(game: game)
    }
    
    init(game: TicTacToe) {
        game.view.gameStatus = .None
    }
    
    func setGameType(type: GameType, game: TicTacToe) {
        
        let isFirstPlayersTurn = game.board.emptyPositions.count % 2 == 1
        
        switch type {
        case .HumanVersusHuman:
            TicTacToeHumanOneUp.performTransition(game)
            
        case .HumanVersusComputer where isFirstPlayersTurn:
            TicTacToeHumanOneAgainstComputerUp.performTransition(game)
        case .HumanVersusComputer where !isFirstPlayersTurn:
            TicTacToeComputerUp.performTransition(game)
            
        case .ComputerVersusHuman where isFirstPlayersTurn:
            TicTacToeComputerUp.performTransition(game)
        case .ComputerVersusHuman where !isFirstPlayersTurn:
            TicTacToeHumanOneAgainstComputerUp.performTransition(game)
            
        default:
            break
        }
    }
}

//MARK:- Human One

struct TicTacToeHumanOneUp: TicTacToeState  {
    
    static func performTransition(game: TicTacToe) {
        game.state = TicTacToeHumanOneUp(game: game)
    }
    
    init(game: TicTacToe) {
        game.view.gameStatus = .PlayerOneUp
    }
    
    func finishTurn(game: TicTacToe) {
        TicTacToeHumanTwoUp.performTransition(game)
    }
    
    func declareVictory(game: TicTacToe) {
        TicTacToeGameOver.performTransition(game, gameStatus: .PlayerOneWins)
    }
}

//MARK:- Human One V Computer

struct TicTacToeHumanOneAgainstComputerUp: TicTacToeState {
    
    static func performTransition(game: TicTacToe) {
        game.state = TicTacToeHumanOneAgainstComputerUp(game: game)
    }
    
    init(game: TicTacToe) {
        game.view.gameStatus = .PlayerOneUp
    }
    
    func finishTurn(game: TicTacToe) {
        TicTacToeComputerUp.performTransition(game)
    }
    
    func declareVictory(game: TicTacToe) {
        game.view.gameStatus = .ComputerWins // Looks like a bug?
    }
    
}

//MARK:- Human Two

struct TicTacToeHumanTwoUp: TicTacToeState {
    
    static func performTransition(game: TicTacToe) {
        game.state = TicTacToeHumanTwoUp(game: game)
    }
    
    init(game: TicTacToe) {
        game.view.gameStatus = .PlayerTwoUp
    }
    
    func finishTurn(game: TicTacToe) {
        TicTacToeHumanOneUp.performTransition(game)
    }
    
    func declareVictory(game: TicTacToe) {
        TicTacToeGameOver.performTransition(game, gameStatus: .PlayerTwoWins)
    }
    
}

//MARK:- Computer

struct TicTacToeComputerUp: TicTacToeState {
    
    static func performTransition(game: TicTacToe) {
        
        let computer = TicTacToeComputerUp()
        computer.takeComputersTurn(game)
    }
    
    func finishTurn(game: TicTacToe) {
        TicTacToeHumanOneAgainstComputerUp.performTransition(game)
    }
    
    func declareVictory(game: TicTacToe) {
        TicTacToeGameOver.performTransition(game, gameStatus: .ComputerWins)
    }
    
    func takeComputersTurn(game: TicTacToe) {
        
        let position = game.bot.nextMove(game.board)
        
        takeTurn(game, position: position)

        game.bot.turnTakenAtBoardPosition(position)
        
    }
    
}

struct TicTacToeGameOver: TicTacToeState {
    
    static func performTransition(game: TicTacToe,  gameStatus: GameStatus) {
        game.state = TicTacToeGameOver()
        game.view.gameStatus = gameStatus
    }
    
    func takeTurn(game: TicTacToe, position: BoardPosition) {
        //NO-OP
    }
    
}

//MARK: BoardView Extension

extension GameBoard {
    
    var emptyPositions: [BoardPosition] {
        
        get {
            var positions = [BoardPosition]()
            for (index, marker) in board.enumerate() {
                if marker == .None {
                    let position = BoardPosition(rawValue: index)!
                    positions.append(position)
                }
            }
            return positions
        }
        
    }
    
}