import XCTest

@testable import TicTacToe

class HeuristicGameBotVersusHumanTests: XCTestCase, GameTestCase {

    var view: GameView!
    var game: Game!
    
    let bot: GameBot? = HeuristicGameBot()
    let type: GameType = GameType.computerVersusHuman
    
    override func setUp() {
        setUpGame()
    }

    //MARK:- Computer V Human Tests
    
    func testGivenView_WhenNewComputerVersusHumanGameStarted_ThenPlayerOneUp() {
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
    }
    
    func testGivenView_WhenNewComputerVersusHumanGameStarted_ThenLastTurnNotNil() {
        XCTAssertNotNil(view.gameBoard.lastTurn)
    }

    //MARK:- Opening Move Strategy Tests
    
    func testGivenView_WhenNewComputerVersusHumanGameStarted_ThenComputerPlaysCorner() {
        XCTAssertNotNil(view.gameBoard.lastTurn?.isCorner)
    }
    
    func testGivenView_WhenHumansFirstMoveIsCenter_ThenComputerPlaysItsOppositeCorner() {
        game.takeTurnAtPosition(.middle)
        XCTAssertEqual(view.gameBoard.lastTurn, .bottomRight)
    }
    
    func testGivenView_WhenHumansFirstMoveIsEdge_ThenComputerPlaysEmptyCorner() {
        game.takeTurnAtPosition(.topMiddle)
        XCTAssertTrue(view.gameBoard.lastTurn!.isCorner)
    }
    
    func testGivenView_WhenHumansFirstMoveIsCorner_ThenComputerPlaysEmptyCorner() {
        game.takeTurnAtPosition(.topRight)
        XCTAssertTrue(view.gameBoard.lastTurn!.isCorner)
    }
    
    func testGivenView_WhenHumansFirstMoveIsOppositeCorner_ThenComputerPlaysEmptyCorner() {
        game.takeTurnAtPosition(.bottomRight)
        XCTAssertTrue(view.gameBoard.lastTurn!.isCorner)
    }
    
    func testGivenView_WhenHumansFirstMoveIsTopEdge_ThenComputerPlaysCornerNotNextToEdge() {
        game.takeTurnAtPosition(.topMiddle)
        XCTAssertNotEqual(view.gameBoard.lastTurn, .topRight)
    }
    
    func testGivenView_WhenHumansFirstMoveIsLeftEdge_ThenComputerPlaysCornerNotNextToEdge() {
        game.takeTurnAtPosition(.middleLeft)
        XCTAssertNotEqual(view.gameBoard.lastTurn, .bottomLeft)
    }
    
    //MARK:- Third Computer Turn Tests
    
    func testGivenView_WhenHumansSecondTurnBlocksMiddleDiagonal_ThenComputerBlocksBottomMiddle() {
        game.takeTurnAtPosition(.topMiddle)
        XCTAssertEqual(view.gameBoard.lastTurn, .bottomRight)
        game.takeTurnAtPosition(.middle)
        XCTAssertEqual(view.gameBoard.lastTurn, .bottomMiddle)
    }
    
    func testGivenView_WhenHumansSecondTurnDoesNotBlockMiddleDiagonal_ThenComputerWins() {
        game.takeTurnAtPosition(.topMiddle)
        game.takeTurnAtPosition(.topRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .middle)
        XCTAssertEqual(view.gameStatus, GameStatus.computerWins)
    }
    
    //MARK:- Perfect Strategic Computer v Human game test
    
    func testGivenView_WhenTakingBestTurns_ThenGameIsStalemate() {
        game.takeTurnAtPosition(.middle)
        XCTAssertEqual(view.gameBoard.lastTurn, .bottomRight)
        game.takeTurnAtPosition(.topMiddle)
        XCTAssertEqual(view.gameBoard.lastTurn, .bottomMiddle)
        game.takeTurnAtPosition(.bottomLeft)
        XCTAssertEqual(view.gameBoard.lastTurn, .topRight)
        game.takeTurnAtPosition(.middleRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .middleLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.stalemate)
    }
    
}
