import WatchKit
import Foundation


class BoardInterfaceController: WKInterfaceController, GameView {

    var game: TicTacToe!
    
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
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        buttons = [
            topLeftButton, topMiddleButton, topRightButton,
            middleLeftButton, middleButton, middleRightButton,
            bottomLeftButton, bottomMiddleButton, bottomRightButton]
        
        if let gameTypeValue = context as? GameTypeValue, let gameType = GameType(rawValue: gameTypeValue) {
            game = TicTacToe(view: self)
            game.newGame(gameType)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //MARK: - Board Button Actions
    
    @IBAction func topLeftAction() {
        game.takeTurnAtPosition(.TopLeft)
    }
    
    @IBAction func topMiddleAction() {
        game.takeTurnAtPosition(.TopMiddle)
    }
    
    @IBAction func topRightAction() {
        game.takeTurnAtPosition(.TopRight)
    }
    
    
    
    @IBAction func middleLeftAction() {
        
        game.takeTurnAtPosition(.MiddleLeft)
    }
    
    @IBAction func middleAction() {
        
        game.takeTurnAtPosition(.Middle)
    }
    
    @IBAction func middleRightAction() {
        game.takeTurnAtPosition(.MiddleRight)
    }
    
    
    
    
    @IBAction func bottomLeftAction() {
        game.takeTurnAtPosition(.BottomLeft)
    }
    
    @IBAction func bottomMiddleAction() {
        game.takeTurnAtPosition(.BottomMiddle)
    }
    
    @IBAction func bottomRightAction() {
        game.takeTurnAtPosition(.BottomRight)
    }
    
    func renderBoard() {
        
        for (index, marker) in gameBoard.board.enumerate() {
            let button = buttons[index]
            let imageName = "\(marker)"
            button.setBackgroundImageNamed(imageName)
        }
    }
    
    func renderStatus() {
        
        var color: UIColor = UIColor.whiteColor()
        
        switch gameStatus! {
        case .ComputerWins:
            color = .redColor()
        case .PlayerOneWins, .PlayerTwoWins:
            color = .greenColor()
        case .Stalemate:
            color = .yellowColor()
        default:
            return
        }
        
        for button in buttons {
            button.setBackgroundColor(color)
        }
        
        renderBoard()
    }



}
