import WatchKit
import Foundation

class InterfaceController: WKInterfaceController, GameView {

    var game: TicTacToe!
    
    //MARK: Interface
    @IBOutlet var picker: WKInterfacePicker!
    
    //MARK:- GameView
    
    var selectedGameType: GameType!
    var gameTypes = [GameType]() {
        didSet {
            selectedGameType = gameTypes.first
        }
    }
    var gameStatus: GameStatus = .None
    var gameBoard: GameBoard!
    
    override init() {
        super.init()
        game = TicTacToe(view: self)
    }
    
    
    //MARK:- Interface Controller Lifecyle
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        configureNewGamePicker()
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        game.newGame(selectedGameType)
        return game
    }
    
    //MARK:- Game Interface
    
    func configureNewGamePicker() {
        let items = gameTypes.map { (type) -> WKPickerItem in
            return pickerItemForGameType(type)
        }
        picker.setItems(items)
    }
    
    func pickerItemForGameType(type: GameType) -> WKPickerItem {
        let item = WKPickerItem()
        item.title = "\(type)"
        return item
    }
    
    @IBAction func pickerAction(value: Int) {
        print("Selected Game Type \(value)")
        selectedGameType = gameTypes[value]
    }
    
}
