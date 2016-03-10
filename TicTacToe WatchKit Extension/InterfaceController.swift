import WatchKit
import Foundation

class InterfaceController: WKInterfaceController, GameChooserView {

    var gameChooser: TicTacToeGameChooser!
    
    //MARK: Interface
    @IBOutlet var picker: WKInterfacePicker!
    
    //MARK:- GameChooserView
    var gameTypes = [GameType]() {
        didSet {
            selectedGameType = gameTypes.first
        }
    }

    var selectedGameType: GameType!
    
    override init() {
        super.init()
        gameChooser = TicTacToeGameChooser(view: self)
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
        
        return selectedGameType.rawValue
        
    }
    
    //MARK:- Game Picker Interface
    
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
        selectedGameType = gameTypes[value]
    }
    
}
