import Foundation
@testable import TicTacToe

class GameViewSpy: GameView, GameChooserView {
    
    var gameTypes = [GameType]()
    var gameStatus: GameStatus! = .None
    var gameBoard: GameBoard!
    
}

