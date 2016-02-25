import Foundation
@testable import TicTacToe

class GameViewSpy: GameView {
    
    var gameTypes = [GameType]()
    var gameState: GameState = .None
    var gameBoard: BoardView!
    
}

extension BoardView {
    
    var noughts: Int {

        get {
            return markers.filter { (marker) in return marker == .Nought }.count
        }
    }
    
    var crosses: Int {
        
        get {
            return markers.filter { (marker) in return marker == .Cross }.count
        }
    }
    
    
}