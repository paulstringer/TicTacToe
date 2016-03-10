import XCTest

@testable import TicTacToe

class HeuristicBotVersusHumanTests: XCTestCase, TicTacToeTestCase {

    var view: GameView!
    var game: TicTacToe!
    var bot: TicTacToeBot?
    var type: GameType!
    
    override func setUp() {
        bot = TicTacToeHeuristicBot()
        type = .ComputerVersusHuman
        setUpGame()
    }

    //MARK:- Computer V Human Tests
    
    func testGivenView_WhenTicTacToeInitialised_ThenViewsGameTypesContainsComputerVersusHuman() {
        XCTAssertTrue(view.gameTypes.contains(.ComputerVersusHuman))
    }
    
    func testGivenView_WhenNewComputerVersusHumanGameStarted_ThenPlayerOneUp() {
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
    }
    
    func testGivenView_WhenNewComputerVersusHumanGameStarted_ThenLastTurnNotNil() {
        XCTAssertNotNil(view.gameBoard.lastTurn)
    }

    //MARK:- Opening Move Strategy Tests
    
    func testGivenView_WhenNewComputerVersusHumanGameStarted_ThenComputerPlaysCorner() {
        XCTAssertNotNil(view.gameBoard.lastTurn?.isCorner)
    }
    
    func testGivenView_WhenHumansFirstMoveIsCenter_ThenComputerPlaysItsOppositeCorner() {
        game.takeTurnAtPosition(.Middle)
        XCTAssertEqual(game.board.lastTurn, .BottomRight)
    }
    
    func testGivenView_WhenHumansFirstMoveIsEdge_ThenComputerPlaysEmptyCorner() {
        game.takeTurnAtPosition(.TopMiddle)
        XCTAssertTrue(game.board.lastTurn!.isCorner)
    }
    
    func testGivenView_WhenHumansFirstMoveIsCorner_ThenComputerPlaysEmptyCorner() {
        game.takeTurnAtPosition(.TopRight)
        XCTAssertTrue(game.board.lastTurn!.isCorner)
    }
    
    func testGivenView_WhenHumansFirstMoveIsOppositeCorner_ThenComputerPlaysEmptyCorner() {
        game.takeTurnAtPosition(.BottomRight)
        XCTAssertTrue(game.board.lastTurn!.isCorner)
    }
    
    func testGivenView_WhenHumansFirstMoveIsTopEdge_ThenComputerPlaysCornerNotNextToEdge() {
        game.takeTurnAtPosition(.TopMiddle)
        XCTAssertNotEqual(game.board.lastTurn, .TopRight)
    }
    
    func testGivenView_WhenHumansFirstMoveIsLeftEdge_ThenComputerPlaysCornerNotNextToEdge() {
        game.takeTurnAtPosition(.MiddleLeft)
        XCTAssertNotEqual(game.board.lastTurn, .BottomLeft)
    }
    
    //MARK:- Third Computer Turn Tests
    
    func testGivenView_WhenHumansSecondTurnBlocksMiddleDiagonal_ThenComputerBlocksBottomMiddle() {
        game.takeTurnAtPosition(.TopMiddle)
        XCTAssertEqual(game.board.lastTurn, .BottomRight)
        game.takeTurnAtPosition(.Middle)
        XCTAssertEqual(game.board.lastTurn, .BottomMiddle)
    }
    
    func testGivenView_WhenHumansSecondTurnDoesNotBlockMiddleDiagonal_ThenComputerWins() {
        game.takeTurnAtPosition(.TopMiddle)
        game.takeTurnAtPosition(.TopRight)
        XCTAssertEqual(game.board.lastTurn, .Middle)
        XCTAssertEqual(view.gameStatus, GameStatus.ComputerWins)
    }
    
    //MARK:- Perfect Strategic Computer v Human game test
    
    func testGivenView_WhenTakingBestTurns_ThenGameIsStalemate() {
        game.takeTurnAtPosition(.Middle)
        XCTAssertEqual(view.gameBoard.lastTurn, .BottomRight)
        game.takeTurnAtPosition(.TopMiddle)
        XCTAssertEqual(view.gameBoard.lastTurn, .BottomMiddle)
        game.takeTurnAtPosition(.BottomLeft)
        XCTAssertEqual(view.gameBoard.lastTurn, .TopRight)
        game.takeTurnAtPosition(.MiddleRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.Stalemate)
    }
    
    //MARK: Play 100 Random Game Tests
    
    func testGivenView_WhenPlayingManyRandomGames_ThenComputerAlwaysWinsOrTies(){
        XCTAssertTrue(playGamesAssertingComputersSuperiority())
    }
    
}
