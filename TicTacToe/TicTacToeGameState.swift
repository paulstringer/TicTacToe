import Foundation

protocol TicTacToeGameState {
    
    func setGameType(type: GameType, game: TicTacToe)
    
    func takeTurn(game: TicTacToe, position: BoardPosition)
    
    // PRIVATE
    
    func finishTurn(game:TicTacToe)
    
    func declareVictory(game: TicTacToe)
    
}

extension TicTacToeGameState {
    
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
        game.state = TicTacToePlayerStalemate(game: game)
    }
}

struct TicTacToePlayerStalemate: TicTacToeGameState {
    
    init(game: TicTacToe) {
        game.view.gameStatus = .Stalemate
    }
    
}

struct TicTacToePlayerNewGame: TicTacToeGameState {
    
    func setGameType(type: GameType, game: TicTacToe) {
        switch type {
        case .HumanVersusHuman:
            game.state = TicTacToePlayerHumanOne(game: game)
        case .HumanVersusComputer:
            game.state = TicTacToePlayerHumanOneAgainstComputer(game: game)
        }
    }
}

struct TicTacToePlayerHumanOne: TicTacToeGameState  {
    
    init(game: TicTacToe) {
        game.view.gameStatus = .PlayerOneUp
    }
    
    func finishTurn(game: TicTacToe) {
        game.state = TicTacToePlayerHumanTwo(game: game)
    }
    
    func declareVictory(game: TicTacToe) {
        game.view.gameStatus = .PlayerOneWins
    }
}

struct TicTacToePlayerHumanOneAgainstComputer: TicTacToeGameState {
    
    init(game: TicTacToe) {
        game.view.gameStatus = .PlayerOneUp
    }
    
    func finishTurn(game: TicTacToe) {
        let state = TicTacToePlayerComputer()
        game.state = state
        state.takeComputersTurn(game)
    }
    
    func declareVictory(game: TicTacToe) {
        game.view.gameStatus = .ComputerWins
    }
    
}

struct TicTacToePlayerHumanTwo: TicTacToeGameState {
    
    init(game: TicTacToe) {
        game.view.gameStatus = .PlayerTwoUp
    }
    
    func finishTurn(game: TicTacToe) {
        game.state = TicTacToePlayerHumanOne(game: game)
    }
    
    func declareVictory(game: TicTacToe) {
        game.view.gameStatus = .PlayerTwoWins
    }
    
}

struct TicTacToePlayerComputer: TicTacToeGameState {
    
    func finishTurn(game: TicTacToe) {
        game.state = TicTacToePlayerHumanOneAgainstComputer(game: game)
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