import WatchKit
import Foundation

protocol GameContext {
    func gameWithView(view: GameView) -> Game
}

class BoardInterfaceController: WKInterfaceController, GameView {

    var updateBoardDelayTimer: NSTimer?
    var game: Game?
    
    //MARK: GameView
    
    var gameStatus: GameStatus! {
        didSet {
            updateBoardColor()
        }
    }
    var gameBoard: GameBoard! {
        didSet {
            updateBoardMarkers()
        }
    }
    
    //MARK: Game Buttons
    
    var buttons: [WKInterfaceButton]!
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
        if let gameBuilder = context as? GameFactory {
            game = gameBuilder.gameWithView(self)
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
        buttons.forEach { (button) -> () in
            updateButtonColor(button)
        }
    }
    
    private func updateBoardMarkers() {
        for (index, marker) in gameBoard.markers.enumerate() {
            updateButtonAtIndex(index, forMarker: marker)
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
    
    private func updateButtonColor(button: WKInterfaceButton) {
        let color = colorForGameStatus()
        button.setBackgroundColor(color)
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
