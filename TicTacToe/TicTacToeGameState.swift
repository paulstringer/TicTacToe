import Foundation


enum TicTacToeGamePlayer {
    case NewGame
    case HumanOne
    case HumanOnePlayingComputer
    case HumanTwo
    case Computer
}


protocol TicTacToeGamePlayerType {
    
    func setGameType(type: GameType, game: TicTacToe)
    
    var type: TicTacToeGamePlayer { get }
    
    func incrementPlayer(game:TicTacToe)
    
    func declareVictory(game: TicTacToe)
    
    func nextMove(game: TicTacToe) -> BoardPosition?
    
}

extension TicTacToeGamePlayerType {
    
    func declareVictory(game: TicTacToe) {
        game.view.gameState = .PlayerOneWins
    }
    
    func nextMove(game: TicTacToe) -> BoardPosition? {

//        guard game.gameType == .HumanVersusComputer else {
//            return nil
//        }
//        
//        return game.bot.nextMove(game.board)

        return nil
        
    }
    
    func setGameType(type: GameType, game: TicTacToe) {
        // No-Op for most instances
    }
}

func newTicTacToeGamePlayerType(type: TicTacToeGamePlayer) -> TicTacToeGamePlayerType {
    
    switch type {
    case .NewGame:
        return TicTacToePlayerNewGame()
    case .HumanOne:
        return TicTacToePlayerHumanOne()
    case .HumanOnePlayingComputer:
        return TicTacToePlayerHumanOneAgainstComputer()
    case .HumanTwo:
        return TicTacToePlayerHumanTwo()
    case .Computer:
        return TicTacToePlayerComputer()
    }
    
}

func newTicTacToeGamePlayerForGameType(type: GameType) -> TicTacToeGamePlayerType {
    
    switch type {

    case .HumanVersusHuman:
        return TicTacToePlayerHumanTwo()
    case .HumanVersusComputer:
        return TicTacToePlayerComputer()
    }
    
}

struct TicTacToePlayerNewGame: TicTacToeGamePlayerType {
    
    var type:TicTacToeGamePlayer = .NewGame
    
    func declareVictory(game: TicTacToe) {
        // No-op
    }
    
    func incrementPlayer(game: TicTacToe) {

//        switch game.gameType {
//        case .HumanVersusHuman: // TicTacToePlayerHumanTwo
//            game.view.gameState = .PlayerTwoUp
//            game.setGamePlayerType(.HumanOne)
////            return newTicTacToeGamePlayerType(.HumanOne)
//        case .HumanVersusComputer: // TicTacToePlayerComputer
//            game.view.gameState = .PlayerOneUp
//            game.setGamePlayerType(.HumanOnePlayingComputer)
////            return newTicTacToeGamePlayerType(.HumanOnePlayingComputer)
//        }
        
        // No-op

    }
    

    func setGameType(type: GameType, game: TicTacToe) {
        
        // change state to the first player for the state
        
        switch type {
        case .HumanVersusHuman:
            game.view.gameState = .PlayerTwoUp
            game.setGamePlayerType(.HumanOne)
        case .HumanVersusComputer:
            game.view.gameState = .PlayerOneUp
            game.setGamePlayerType(.HumanOnePlayingComputer)
        }
    }
}

//TODO: Extract all gameType switch code into discreet states for simplification
struct TicTacToePlayerHumanOne: TicTacToeGamePlayerType  {
    
    var type: TicTacToeGamePlayer = .HumanOne
    
    func incrementPlayer(game: TicTacToe) {
        
        game.view.gameState = .PlayerTwoUp
        
        game.setGamePlayerType(.HumanTwo)
        
    }
    
    func declareVictory(game: TicTacToe) {
        
        game.view.gameState = .PlayerOneWins
        
    }
}

struct TicTacToePlayerHumanOneAgainstComputer: TicTacToeGamePlayerType {
    
    var type: TicTacToeGamePlayer = .HumanOnePlayingComputer
    
    func incrementPlayer(game: TicTacToe) {
        
        game.setGamePlayerType(.Computer)
//        return newTicTacToeGamePlayerType(.Computer)
        
    }
    
    func declareVictory(game: TicTacToe) {
        
            game.view.gameState = .ComputerWins
        
    }
    
}

struct TicTacToePlayerHumanTwo: TicTacToeGamePlayerType {
    
    var type:TicTacToeGamePlayer = .HumanTwo
    
    func incrementPlayer(game: TicTacToe) {

        game.view.gameState = .PlayerOneUp
        game.setGamePlayerType(.HumanOne)
        
    }
    
    func declareVictory(game: TicTacToe) {
        game.view.gameState = .PlayerTwoWins
    }
    
}

struct TicTacToePlayerComputer: TicTacToeGamePlayerType {
    
    var type:TicTacToeGamePlayer = .Computer
    
    func nextMove(game: TicTacToe) -> BoardPosition? {
        // NO-OP
        return game.bot.nextMove(game.board)
    }
    
    func declareVictory(game: TicTacToe) {
        game.view.gameState = .ComputerWins
    }
    
    func incrementPlayer(game: TicTacToe) {
        game.view.gameState = .PlayerOneUp
        game.setGamePlayerType(.HumanOnePlayingComputer)
    }
}