import Foundation

protocol GameChooserView: class {
    var gameTypes: [GameType] { get set }
}

class TicTacToeGameChooser {
    
    let view: GameChooserView
    
    init(view: GameChooserView) {
        self.view = view
        self.view.gameTypes = GameType.allValues
    }
}