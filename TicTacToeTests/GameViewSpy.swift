import Foundation
@testable import TicTacToe

class GameViewSpy: GameView {
    
    var gameTypes = [GameType]()
    var gameState: GameState = .None
    var gameBoard: BoardView!
    
}