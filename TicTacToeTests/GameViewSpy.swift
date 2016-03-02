import Foundation
@testable import TicTacToe

class GameViewSpy: GameView {
    
    var gameTypes = [GameType]()
    var gameStatus: GameStatus = .None
    var gameBoard: GameBoard!
    
}

extension GameBoard {
    
    var noughts: Int {

        get {
            return board.filter { (marker) in return marker == .Nought }.count
        }
    }
    
    var crosses: Int {
        
        get {
            return board.filter { (marker) in return marker == .Cross }.count
        }
    }
    
    
}