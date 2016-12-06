import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    var gameFactory = GameFactory()
    
    //MARK: Interface
    
    @IBOutlet var picker: WKInterfacePicker!
    
    //MARK:- Interface Controller Lifecyle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        configureNewGamePicker()
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        return gameFactory
        
    }
    
    //MARK:- Game Picker Interface
    
    fileprivate func configureNewGamePicker() {
        let items = GameType.allValues.map { (type) -> WKPickerItem in
            return pickerItemForGameType(type)
        }
        picker.setItems(items)
    }
    
    fileprivate func pickerItemForGameType(_ type: GameType) -> WKPickerItem {
        let item = WKPickerItem()
        item.contentImage = WKImage(imageName: "\(type)")
        return item
    }
    
    @IBAction func pickerAction(_ value: Int) {
        gameFactory.gameType = GameType.allValues[value]
    }
    
}
