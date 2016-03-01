import Foundation


enum TicTacToeGamePlayer {
    case None
    case HumanOne
    case HumanTwo
    case Computer
}


protocol TicTacToeGamePlayerType {
    var type: TicTacToeGamePlayer { get }
}

func newTicTacToeGamePlayerType(type: TicTacToeGamePlayer) -> TicTacToeGamePlayerType {
    
    switch type {
    case .None:
        return TicTacToeGameStatePlayerNone()
    case .HumanOne:
        return TicTacToeGamePlayerOne()
    case .HumanTwo:
        return TicTacToeGamePlayerTwo()
    case .Computer:
        return TicTacToeGamePlayerComputer()
    }
    
}

struct TicTacToeGameStatePlayerNone: TicTacToeGamePlayerType {
    
    var type:TicTacToeGamePlayer = .None
    
}

struct TicTacToeGamePlayerOne: TicTacToeGamePlayerType {
    
    var type: TicTacToeGamePlayer = .HumanOne
    
}

struct TicTacToeGamePlayerTwo: TicTacToeGamePlayerType {
    
    var type:TicTacToeGamePlayer = .HumanTwo
    
}

struct TicTacToeGamePlayerComputer: TicTacToeGamePlayerType {
    
    var type:TicTacToeGamePlayer = .Computer

}