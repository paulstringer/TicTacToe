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
        game.state = TicTacToeStalemate(game: game)
    }
}

struct TicTacToeStalemate: TicTacToeState {
    
    init(game: TicTacToe) {
        game.view.gameStatus = .Stalemate
    }
    
}

struct TicTacToeNewGame: TicTacToeState {
    
    func setGameType(type: GameType, game: TicTacToe) {
        switch type {
        case .HumanVersusHuman:
            game.state = TicTacToeHumanOneUp(game: game)
        case .HumanVersusComputer:
            game.state = TicTacToeHumanOneAgainstComputerUp(game: game)
        }
    }
}

struct TicTacToeHumanOneUp: TicTacToeState  {
    
    init(game: TicTacToe) {
        game.view.gameStatus = .PlayerOneUp
    }
    
    func finishTurn(game: TicTacToe) {
        game.state = TicTacToeHumanTwoUp(game: game)
    }
    
    func declareVictory(game: TicTacToe) {
        game.view.gameStatus = .PlayerOneWins
    }
}

struct TicTacToeHumanOneAgainstComputerUp: TicTacToeState {
    
    init(game: TicTacToe) {
        game.view.gameStatus = .PlayerOneUp
    }
    
    func finishTurn(game: TicTacToe) {
        let state = TicTacToeComputerUp()
        game.state = state
        state.takeComputersTurn(game)
    }
    
    func declareVictory(game: TicTacToe) {
        game.view.gameStatus = .ComputerWins
    }
    
}

struct TicTacToeHumanTwoUp: TicTacToeState {
    
    init(game: TicTacToe) {
        game.view.gameStatus = .PlayerTwoUp
    }
    
    func finishTurn(game: TicTacToe) {
        game.state = TicTacToeHumanOneUp(game: game)
    }
    
    func declareVictory(game: TicTacToe) {
        game.view.gameStatus = .PlayerTwoWins
    }
    
}

struct TicTacToeComputerUp: TicTacToeState {
    
    func finishTurn(game: TicTacToe) {
        game.state = TicTacToeHumanOneAgainstComputerUp(game: game)
    }
    
    func declareVictory(game: TicTacToe) {
        game.view.gameStatus = .ComputerWins
    }
    
    func takeComputersTurn(game: TicTacToe) {
    
        let position = game.bot.nextMove(game.board)
        
        takeTurn(game, position: position)

        game.bot.turnTakenAtBoardPosition(position)
        
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