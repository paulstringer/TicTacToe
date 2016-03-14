import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    var gameFactory = GameFactory()
    
    //MARK: Interface
    
    @IBOutlet var picker: WKInterfacePicker!
    
    
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
        return gameFactory
        
    }
    
    //MARK:- Game Picker Interface
    
    func configureNewGamePicker() {
        let items = GameFactory.GameTypes.map { (type) -> WKPickerItem in
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
        gameFactory.gameType = GameFactory.GameTypes[value]
    }
    
}
