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

    fileprivate func configureButtons() {
        buttons = [
            topLeftButton, topMiddleButton, topRightButton,
            middleLeftButton, middleButton, middleRightButton,
            bottomLeftButton, bottomMiddleButton, bottomRightButton]
        
        buttons.forEach { (button) -> () in
            button.setBackgroundImage(nil, for: UIControlState())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createGame() {
        let factory = GameFactory(gameType: .humanVersusHuman)
        game = factory.gameWithView(self)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        var position: BoardPosition = .middle
        
        if sender == topLeftButton {
            position = .topLeft
        } else if sender == topMiddleButton {
            position = .topMiddle
        } else if sender == topRightButton {
            position = .topRight
        } else if sender == middleLeftButton {
            position = .middleLeft
        } else if sender == middleButton {
            position = .middle
        } else if sender == middleRightButton {
            position = .middleRight
        } else if sender == bottomLeftButton {
            position = .bottomLeft
        } else if sender == bottomMiddleButton {
            position = .bottomMiddle
        } else if sender == bottomRightButton {
            position = .bottomRight
        }
        
        game?.takeTurnAtPosition(position)
    }
    
    
    func updateBoardMarkers() {
        for (index, marker) in gameBoard.markers.enumerated() {
            updateButtonAtIndex(index, forMarker: marker)
        }
    }
    
    
    fileprivate func updateButtonAtIndex(_ index: Int, forMarker marker: BoardMarker) {
        let button = buttons[index]
        updateButton(button, backgroundImageWithMarker: marker)
    }
    
    fileprivate func updateButton(_ button: UIButton, backgroundImageWithMarker marker: BoardMarker) {
        var imageName: String? = nil
        
        button.titleLabel?.text = nil
        
        switch marker {
        case .cross, .nought:
            imageName = "\(marker)"
        default:
            imageName = nil
        }
        
        if let imageName = imageName {
            let image = UIImage(named: imageName)
            button.setBackgroundImage(image, for: UIControlState())
        }
        
    }

    fileprivate func needsColorUpdate() -> Bool {
        
        guard let gameStatus = gameStatus else {
            return false
        }
        
        switch gameStatus {
        case .computerWins, .playerOneWins, .playerTwoWins, .stalemate, .computerUp:
            return true
        default:
            return false
        }
    }
    
    //MARK: - Board View Updates
    
    fileprivate func updateBoardColor() {
        
        let color = colorForGameStatus()
        let accessibilityLabel = labelForGameStatus()
        
        var updatedButtons = [UIButton]()
        
        if let winningLine = gameBoard.winningLine  {
            
            winningLine.forEach({ (position) -> () in
                updatedButtons.append(buttons[position.rawValue])
            })
            
        } else {
            
            updatedButtons.append(contentsOf: buttons)
            
        }
        
        updateButtons(updatedButtons, withColor: color, accessibilityLabel: accessibilityLabel )
        updateBoardMarkers()
        
        
        
    }
    
    fileprivate func updateButtons(_ buttons: [UIButton], withColor color: UIColor, accessibilityLabel: String) {
        buttons.forEach { (button) -> () in
            button.tintColor = color
            button.accessibilityLabel = accessibilityLabel
        }
    }
    
    fileprivate func colorForGameStatus() -> UIColor {
        
        guard let gameStatus = gameStatus else {
            return .white
        }
        
        switch gameStatus {
        case .computerWins:
            return .red
        case .playerOneWins, .playerTwoWins:
            return .green
        case .stalemate:
            return .yellow
        default:
            return .white
        }
        
    }
    
    fileprivate func labelForGameStatus() -> String {
        
        guard let gameStatus = gameStatus else {
            return "WHITE"
        }
        
        switch gameStatus {
        case .computerWins:
            return "RED"
        case .playerOneWins, .playerTwoWins:
            return "GREEN"
        case .stalemate:
            return "YELLOW"
        default:
            return "WHITE"
        }
        
    }
}

