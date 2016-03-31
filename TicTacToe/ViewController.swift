import UIKit

typealias ButtonPositions = [UIButton]

class ViewController: UIViewController, GameView {

    var game: Game!
    var buttons: ButtonPositions!
    
    @IBOutlet var topLeftButton: UIButton!
    @IBOutlet var topMiddleButton: UIButton!
    @IBOutlet var topRightButton: UIButton!
    @IBOutlet var middleLeftButton: UIButton!
    @IBOutlet var middleButton: UIButton!
    @IBOutlet var middleRightButton: UIButton!
    @IBOutlet var bottomLeftButton: UIButton!
    @IBOutlet var bottomMiddleButton: UIButton!
    @IBOutlet var bottomRightButton: UIButton!
    
    var gameStatus: GameStatus! {
        didSet {
            
            guard needsColorUpdate() else {
                return
            }
            
            updateBoardColor()
            
        }
    }
    
    var gameBoard: GameBoard! {
        didSet {
            updateBoardMarkers()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        createGame()
    }

    private func configureButtons() {
        buttons = [
            topLeftButton, topMiddleButton, topRightButton,
            middleLeftButton, middleButton, middleRightButton,
            bottomLeftButton, bottomMiddleButton, bottomRightButton]
        
        buttons.forEach { (button) -> () in
            button.setBackgroundImage(nil, forState: .Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createGame() {
        let factory = GameFactory(gameType: .HumanVersusHuman)
        game = factory.gameWithView(self)
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        
        var position: BoardPosition = .Middle
        
        if sender == topLeftButton {
            position = .TopLeft
        } else if sender == topMiddleButton {
            position = .TopMiddle
        } else if sender == topRightButton {
            position = .TopRight
        } else if sender == middleLeftButton {
            position = .MiddleLeft
        } else if sender == middleButton {
            position = .Middle
        } else if sender == middleRightButton {
            position = .MiddleRight
        } else if sender == bottomLeftButton {
            position = .BottomLeft
        } else if sender == bottomMiddleButton {
            position = .BottomMiddle
        } else if sender == bottomRightButton {
            position = .BottomRight
        }
        
        game?.takeTurnAtPosition(position)
    }
    
    
    func updateBoardMarkers() {
        for (index, marker) in gameBoard.markers.enumerate() {
            updateButtonAtIndex(index, forMarker: marker)
        }
    }
    
    
    private func updateButtonAtIndex(index: Int, forMarker marker: BoardMarker) {
        let button = buttons[index]
        updateButton(button, backgroundImageWithMarker: marker)
    }
    
    private func updateButton(button: UIButton, backgroundImageWithMarker marker: BoardMarker) {
        var imageName: String? = nil
        
        button.titleLabel?.text = nil
        
        switch marker {
        case .Cross, .Nought:
            imageName = "\(marker)"
        default:
            imageName = nil
        }
        
        if let imageName = imageName {
            let image = UIImage(named: imageName)
            button.setBackgroundImage(image, forState: .Normal)
        }
        
    }

    private func needsColorUpdate() -> Bool {
        
        guard let gameStatus = gameStatus else {
            return false
        }
        
        switch gameStatus {
        case .ComputerWins, .PlayerOneWins, .PlayerTwoWins, .Stalemate, .ComputerUp:
            return true
        default:
            return false
        }
    }
    
    //MARK: - Board View Updates
    
    private func updateBoardColor() {
        
        let color = colorForGameStatus()
        var updatedButtons = [UIButton]()
        
        if let winningLine = gameBoard.winningLine  {
            
            winningLine.forEach({ (position) -> () in
                updatedButtons.append(buttons[position.rawValue])
            })
            
        } else {
            
            updatedButtons.appendContentsOf(buttons)
            
        }
        
        updateButtons(updatedButtons, withColor: color)
        updateBoardMarkers()
        
        
        
    }
    
    private func updateButtons(buttons: [UIButton], withColor color: UIColor) {
        buttons.forEach { (button) -> () in
            button.tintColor = color
        }
    }
    
    private func colorForGameStatus() -> UIColor {
        
        guard let gameStatus = gameStatus else {
            return .whiteColor()
        }
        
        switch gameStatus {
        case .ComputerWins:
            return .redColor()
        case .PlayerOneWins, .PlayerTwoWins:
            return .greenColor()
        case .Stalemate:
            return .yellowColor()
        default:
            return .whiteColor()
        }
        
    }
}

