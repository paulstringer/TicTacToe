import WatchKit
import Foundation

typealias ButtonPositions = [WKInterfaceButton]

class BoardInterfaceController: WKInterfaceController, GameView {

    var context: GameFactory?
    var game: Game?
    
    //MARK: GameView
    
    var gameStatus: GameStatus! {
        didSet {            
            
            guard needsColorUpdate() else {
                return
            }
            
            updateBoardColor()
            
            if gameStatus! == .computerUp {
                animateEmptyButtons()
            }
        }
    }
    
    var gameBoard: GameBoard! {
        didSet {
            updateBoardMarkers()
        }
    }
    
    //MARK: Game Buttons
    
    var buttons: ButtonPositions!
    @IBOutlet var topLeftButton: WKInterfaceButton!
    @IBOutlet var topMiddleButton: WKInterfaceButton!
    @IBOutlet var topRightButton: WKInterfaceButton!
    @IBOutlet var middleLeftButton: WKInterfaceButton!
    @IBOutlet var middleButton: WKInterfaceButton!
    @IBOutlet var middleRightButton: WKInterfaceButton!
    @IBOutlet var bottomLeftButton: WKInterfaceButton!
    @IBOutlet var bottomMiddleButton: WKInterfaceButton!
    @IBOutlet var bottomRightButton: WKInterfaceButton!
    
    //MARK: - Life Cycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        configureButtons()
        startGame(context as AnyObject?)
    }
    
    fileprivate func startGame(_ context: AnyObject?) {
        if let context = context as? GameFactory {
            self.context = context
            createGame()
        } else {
            fatalError("Unexpected Context")
        }
    }
    
    fileprivate func configureButtons() {
        buttons = [
            topLeftButton, topMiddleButton, topRightButton,
            middleLeftButton, middleButton, middleRightButton,
            bottomLeftButton, bottomMiddleButton, bottomRightButton]
        
        buttons.forEach { (button) -> () in
            button.setBackgroundImage(nil)
        }
    }
    
    //MARK: - Board Button Actions
    
    @IBAction func createGame() {
        game = context?.gameWithView(self)
        updateBoardColor()
    }
    
    //TOP
    
    @IBAction func topLeftAction() {
        takeTurnAtPosition(.topLeft)
    }
    
    @IBAction func topMiddleAction() {
        takeTurnAtPosition(.topMiddle)
    }
    
    @IBAction func topRightAction() {
        takeTurnAtPosition(.topRight)
    }
    
    //MIDDLE
    
    @IBAction func middleLeftAction() {
        takeTurnAtPosition(.middleLeft)
    }
    
    @IBAction func middleAction() {
        takeTurnAtPosition(.middle)
    }
    
    @IBAction func middleRightAction() {
        takeTurnAtPosition(.middleRight)
    }
    
    //BOTTOM
    
    @IBAction func bottomLeftAction() {
        takeTurnAtPosition(.bottomLeft)
    }
    
    @IBAction func bottomMiddleAction() {
        takeTurnAtPosition(.bottomMiddle)
    }
    
    @IBAction func bottomRightAction() {
        takeTurnAtPosition(.bottomRight)
    }
    
    //Button Action
    
    fileprivate func takeTurnAtPosition(_ position: BoardPosition) {
        game?.takeTurnAtPosition(position)
    }
    
    //MARK: - Board View Updates
    
    fileprivate func updateBoardColor() {

        let color = colorForGameStatus()
        var updatedButtons = [WKInterfaceButton]()
        
        if let winningLine = gameBoard.winningLine  {
            
            winningLine.forEach({ (position) -> () in
                updatedButtons.append(buttons[position.rawValue])
            })
            
        } else {
            
            updatedButtons.append(contentsOf: buttons)
            
        }

        updateButtons(updatedButtons, withColor: color)
        updateBoardMarkers()
        
   
        
    }
    
    func updateBoardMarkers() {
        for (index, marker) in gameBoard.markers.enumerated() {
            updateButtonAtIndex(index, forMarker: marker)
        }
    }
    
    fileprivate func updateButtons(_ buttons: [WKInterfaceButton], withColor color: UIColor) {
        buttons.forEach { (button) -> () in
            button.setBackgroundColor(color)
        }
    }

    fileprivate func updateButtonAtIndex(_ index: Int, forMarker marker: BoardMarker) {
        let button = buttons[index]
        updateButton(button, backgroundImageWithMarker: marker)
    }
    
    fileprivate func updateButton(_ button: WKInterfaceButton, backgroundImageWithMarker marker: BoardMarker) {
        var imageName: String? = nil
        
        switch marker {
        case .cross, .nought:
            imageName = "\(marker)"
        default:
            imageName = nil
        }
        
        button.setBackgroundImageNamed(imageName)

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
    
    fileprivate func animateEmptyButtons()  {

        let emptyPositions = BoardAnalyzer.emptyPositions(gameBoard)
        
        let emptyButtons = buttons.filter { (button) -> Bool in
            return emptyPositions.contains( boardPosition(button) )
        }
        
        for button in emptyButtons {
            let mod = buttons.index(of: button)! % 2
            let animatedImage = UIImage.animatedImageNamed("Thinking\(mod)-", duration: 0.5)
            button.setBackgroundImage(animatedImage)

        }
    }

    fileprivate func boardPosition(_  button: WKInterfaceButton) -> BoardPosition {
        let index = buttons.index(of: button)!
        return BoardPosition(rawValue: index)!
    }


}
