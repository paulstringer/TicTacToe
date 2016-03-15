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
            
            if gameStatus! == .ComputerUp {
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
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        configureButtons()
        startGame(context)
    }
    
    private func startGame(context: AnyObject?) {
        if let context = context as? GameFactory {
            self.context = context
            createGame()
        } else {
            fatalError("Unexpected Context")
        }
    }
    
    private func configureButtons() {
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
        takeTurnAtPosition(.TopLeft)
    }
    
    @IBAction func topMiddleAction() {
        takeTurnAtPosition(.TopMiddle)
    }
    
    @IBAction func topRightAction() {
        takeTurnAtPosition(.TopRight)
    }
    
    //MIDDLE
    
    @IBAction func middleLeftAction() {
        takeTurnAtPosition(.MiddleLeft)
    }
    
    @IBAction func middleAction() {
        takeTurnAtPosition(.Middle)
    }
    
    @IBAction func middleRightAction() {
        takeTurnAtPosition(.MiddleRight)
    }
    
    //BOTTOM
    
    @IBAction func bottomLeftAction() {
        takeTurnAtPosition(.BottomLeft)
    }
    
    @IBAction func bottomMiddleAction() {
        takeTurnAtPosition(.BottomMiddle)
    }
    
    @IBAction func bottomRightAction() {
        takeTurnAtPosition(.BottomRight)
    }
    
    //Button Action
    
    private func takeTurnAtPosition(position: BoardPosition) {
        game?.takeTurnAtPosition(position)
    }
    
    //MARK: - Board View Updates
    
    private func updateBoardColor() {

        let color = colorForGameStatus()
        var updatedButtons = [WKInterfaceButton]()
        
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
    
    func updateBoardMarkers() {
        for (index, marker) in gameBoard.markers.enumerate() {
            updateButtonAtIndex(index, forMarker: marker)
        }
    }
    
    private func updateButtons(buttons: [WKInterfaceButton], withColor color: UIColor) {
        buttons.forEach { (button) -> () in
            button.setBackgroundColor(color)
        }
    }

    private func updateButtonAtIndex(index: Int, forMarker marker: BoardMarker) {
        let button = buttons[index]
        updateButton(button, backgroundImageWithMarker: marker)
    }
    
    private func updateButton(button: WKInterfaceButton, backgroundImageWithMarker marker: BoardMarker) {
        var imageName: String? = nil
        
        switch marker {
        case .Cross, .Nought:
            imageName = "\(marker)"
        default:
            imageName = nil
        }
        
        button.setBackgroundImageNamed(imageName)

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
    
    private func animateEmptyButtons()  {

        let emptyPositions = BoardAnalyzer.emptyPositions(gameBoard)
        
        let emptyButtons = buttons.filter { (button) -> Bool in
            return emptyPositions.contains( buttons.boardPosition(button) )
        }
        
        for button in emptyButtons {
            let mod = buttons.indexOf(button)! % 2
            let animatedImage = UIImage.animatedImageNamed("Thinking\(mod)-", duration: 0.5)
            button.setBackgroundImage(animatedImage)

        }
    }


}

extension _ArrayType where Generator.Element == WKInterfaceButton {
    
    func boardPosition(button: WKInterfaceButton) -> BoardPosition {
        let index = self.indexOf(button) as! Int
        return BoardPosition(rawValue: index)!
    }
}