import Foundation


enum TicTacToeGamePlayer {
    case None
    case HumanOne
    case HumanTwo
    case Computer
}


protocol TicTacToeGamePlayerType {
    
    var type: TicTacToeGamePlayer { get }
    
    func incrementPlayer(game:TicTacToe) -> TicTacToeGamePlayerType
    
    func declareVictory(game: TicTacToe)
    
    func nextMove(game: TicTacToe) -> BoardPosition?
}

extension TicTacToeGamePlayerType {
    
    func incrementPlayer(game: TicTacToe) -> TicTacToeGamePlayerType {
        
        switch game.gameType {
        case .HumanVersusHuman:
            game.view.gameState = .PlayerTwoUp
        case .HumanVersusComputer:
            game.view.gameState = .PlayerOneUp
        }
        
        return newTicTacToeGamePlayerType(.HumanOne)
        
    }
    
    func declareVictory(game: TicTacToe) {
        game.view.gameState = .PlayerOneWins
    }
    
    func nextMove(game: TicTacToe) -> BoardPosition? {

        guard game.gameType == .HumanVersusComputer else {
            return nil
        }
        
        return game.bot.nextMove(game.board)

        
    }
    
}
func newTicTacToeGamePlayerType(type: TicTacToeGamePlayer) -> TicTacToeGamePlayerType {
    
    switch type {
    case .None:
        return TicTacToePlayerNone()
    case .HumanOne:
        return TicTacToePlayerHumanOne()
    case .HumanTwo:
        return TicTacToePlayerHumanTwo()
    case .Computer:
        return TicTacToePlayerComputer()
    }
    
}

struct TicTacToePlayerNone: TicTacToeGamePlayerType {
    
    var type:TicTacToeGamePlayer = .None
    
    func declareVictory(game: TicTacToe) {
        // No-op
    }

    
}

struct TicTacToePlayerHumanOne: TicTacToeGamePlayerType  {
    
    var type: TicTacToeGamePlayer = .HumanOne
    
    func incrementPlayer(game: TicTacToe) -> TicTacToeGamePlayerType{
        
        switch game.gameType {
        case .HumanVersusHuman:
            game.view.gameState = .PlayerOneUp
            return newTicTacToeGamePlayerType(.HumanTwo)
        case .HumanVersusComputer:
            return newTicTacToeGamePlayerType(.Computer)
        }
        
    }
    
    func declareVictory(game: TicTacToe) {
        
        switch game.gameType {
        case .HumanVersusHuman:
            game.view.gameState = .PlayerTwoWins
        case .HumanVersusComputer:
            game.view.gameState = .ComputerWins
        }
        
    }
}

struct TicTacToePlayerHumanTwo: TicTacToeGamePlayerType {
    
    var type:TicTacToeGamePlayer = .HumanTwo
    
}

struct TicTacToePlayerComputer: TicTacToeGamePlayerType {
    
    var type:TicTacToeGamePlayer = .Computer
    
    func nextMove(game: TicTacToe) -> BoardPosition? {
        // NO-OP
        return nil
    }
}