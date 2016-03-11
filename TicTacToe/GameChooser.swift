import Foundation

protocol GameChooserView: class {
    var gameTypes: [GameType] { get set }
}

class GameChooser {
    
    let view: GameChooserView
    
    init(view: GameChooserView) {
        self.view = view
        self.view.gameTypes = GameType.allValues
    }
    
    
}