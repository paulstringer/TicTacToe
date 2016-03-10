import XCTest
@testable import TicTacToe

class HumanVersusGameTreeBotTests: XCTestCase, TicTacToeTestCase {

    var view: GameView!
    var game: TicTacToe!
    var bot: TicTacToeBot?
    var type: GameType!
    
    override func setUp() {
        super.setUp()
        type = .HumanVersusComputer
        bot = TicTacToeGameTreeBot()
        setUpGame()
    }
    
    //MARK:- Human V Computer Basic Setup Tests
    
    func testGivenView_WhenInitialised_ThenViewsGameTypesContainsHumanVersusComputer() {
        XCTAssertTrue(view.gameTypes.contains(.HumanVersusComputer))
    }
    
    func testGivenView_WhenNewHumanVersusComputerGameStarted_ThenPlayerOneUp() {
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
    }
    
    func testGivenView_WhenNewHumanVersusComputerGameStarted_ThenLastTurnIsNil() {
        XCTAssertNil(view.gameBoard.lastTurn)
    }
    
    //TODO:- Turn taking tests
    
    func testGivenGame_WhenTakingTurn_ThenPlayerOneIsUp() {
        game.takeTurnAtPosition(.TopLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
    }
    
    func testGivenGame_WhenTakingTurn_ThenComputerTookATurn() {
        game.takeTurnAtPosition(.TopLeft)
        XCTAssertNotNil(view.gameBoard.lastTurn)
        XCTAssertNotEqual(view.gameBoard.lastTurn, .TopLeft)
    }
    
    func testGivenGame_WhenTakingTurn_ThenBoardHasOneCrossAndOneNought() {
        game.takeTurnAtPosition(0)
        XCTAssertEqual(view.gameBoard.noughts, 1)
        XCTAssertEqual(view.gameBoard.crosses, 1)
    }
    
    func testGivenGame_WhenTakingTurn_ThenBoardHasTwoNoughtsAndCrosses() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        XCTAssertEqual(view.gameBoard.noughts, 2)
        XCTAssertEqual(view.gameBoard.crosses, 2)
    }
    
    //Mark:- Perfect Strategic Human V Computer Game
    
    func testGivenGame_WhenHumanPlaysBestMovesAndComputerRespondsPerfectly_ThenGameIsStalemate() {

        game.takeTurnAtPosition(.TopLeft)
        XCTAssertEqual(view.gameBoard.lastTurn, .Middle)
        game.takeTurnAtPosition(.BottomRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .TopMiddle)
        game.takeTurnAtPosition(.BottomMiddle)
        XCTAssertEqual(view.gameBoard.lastTurn, .BottomLeft)
        game.takeTurnAtPosition(.TopRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleRight)
        game.takeTurnAtPosition(.MiddleLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.Stalemate)
    }
    
    func testGivenGame_WhenTakingTurnsHumanMissesBlockTopRightToBottomLeftDiagonal_ThenComputerPlaysTopRightAndWins() {
        
        let markers: [BoardMarker] = [
            .Cross, .Nought , .None,
            .None , .Nought , .None ,
            .Nought , .Cross , .Cross ,
        ]
        
        setUpGame(markers)
        
        game.takeTurnAtPosition(.MiddleRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .TopRight)
        XCTAssertEqual(view.gameStatus, GameStatus.ComputerWins)
    }
}
