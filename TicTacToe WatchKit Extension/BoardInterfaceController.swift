import WatchKit
import Foundation

protocol GameContext {
    func gameWithView(view: GameView) -> Game
}

class BoardInterfaceController: WKInterfaceController, GameView {

    var game: Game?
    
    //MARK: GameView
    var gameStatus: GameStatus! {
        didSet {
            if let _ = gameStatus {
            renderStatus()
            }
        }
    }
    var gameBoard: GameBoard! {
        didSet {
            renderBoard()
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
    
    func startGame(context: AnyObject?) {
        if let gameBuilder = context as? GameContext {
            game = gameBuilder.gameWithView(self)
        }
    }
    
    func configureButtons() {
        buttons = [
            topLeftButton, topMiddleButton, topRightButton,
            middleLeftButton, middleButton, middleRightButton,
            bottomLeftButton, bottomMiddleButton, bottomRightButton]
    }
    
    //MARK: - Board Button Actions
    
    @IBAction func topLeftAction() {
        game?.takeTurnAtPosition(.TopLeft)
    }
    
    @IBAction func topMiddleAction() {
        game?.takeTurnAtPosition(.TopMiddle)
    }
    
    @IBAction func topRightAction() {
        game?.takeTurnAtPosition(.TopRight)
    }
    
    
    
    @IBAction func middleLeftAction() {
        
        game?.takeTurnAtPosition(.MiddleLeft)
    }
    
    @IBAction func middleAction() {
        
        game?.takeTurnAtPosition(.Middle)
    }
    
    @IBAction func middleRightAction() {
        game?.takeTurnAtPosition(.MiddleRight)
    }
    
    
    
    @IBAction func bottomLeftAction() {
        game?.takeTurnAtPosition(.BottomLeft)
    }
    
    @IBAction func bottomMiddleAction() {
        game?.takeTurnAtPosition(.BottomMiddle)
    }
    
    @IBAction func bottomRightAction() {
        game?.takeTurnAtPosition(.BottomRight)
    }
    
    //MARK: - Board Updates
    
    func renderBoard() {
        
        for (index, marker) in gameBoard.markers.enumerate() {
            let button = buttons[index]
            let imageName = "\(marker)"
            button.setBackgroundImageNamed(imageName)
        }
    }
    
    func renderStatus() {
        
        let color = colorForGameStatus()
        
        for button in buttons {
            button.setBackgroundColor(color)
        }
        
        renderBoard()
    }

    func colorForGameStatus() -> UIColor {
        
        switch gameStatus! {
        case .ComputerWins:
            return .redColor()
        case .PlayerOneWins, .PlayerTwoWins:
            return .greenColor()
        case .Stalemate:
            return .yellowColor()
        default:
            return  .whiteColor()
        }
        
    }


}
