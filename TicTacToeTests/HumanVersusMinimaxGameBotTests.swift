import XCTest
@testable import TicTacToe

class HumanVersusMinimaxGameBotTests: XCTestCase, GameTestCase {

    var view: GameView!
    var game: TicTacToe!
    
    let bot: GameBot? = MinimaxGameBot()
    let type: GameType = .HumanVersusComputer
    
    override func setUp() {
        super.setUp()
        setUpGame()
    }
    
    //MARK:- Human V Computer Basic Setup Tests
    
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
    
    func testGivenGame_WhenHumanPlaysBestMoves_ThenComputerPlaysPerfectMoves() {
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
    
      //Mark:- Various Win / Draw Scenario Tests
    
    func testGivenGame_WhenHumanMissesBlockTopRightToBottomLeftDiagonal_ThenComputerPlaysTopRightAndWins() {
        
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
    
    func testGivenGame_WhenTakingTurnsButHumanMissesBlockAtBottomMiddle_ThenComputerPlaysBottomMiddleAndWins() {
        
        let markers: [BoardMarker] = [
            .Cross, .Nought , .None,
            .None , .Nought , .None ,
            .None , .None , .Cross ,
        ]
        
        setUpGame(markers)
        game.takeTurnAtPosition(.TopRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .BottomMiddle)
        XCTAssertEqual(view.gameStatus, GameStatus.ComputerWins)
    }
    
    func testGivenGame_WhenTakingTurnsHumanTrysLeftEdgeLine_ThenComputerPlaysDiagonalAndWins() {
        
        let markers: [BoardMarker] = [
            .Cross, .None , .None,
            .None, .Nought , .None ,
            .Cross, .None , .None ,
        ]
        
        setUpGame(markers)
        
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleLeft)
        game.takeTurnAtPosition(.TopMiddle)
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleRight)
        XCTAssertEqual(view.gameStatus, GameStatus.ComputerWins)
    }
    
    func testGivenGame_WhenHumanTrysEdgesThenBlocksSuccessfully_ThenGameIsStalemate() {
        game.takeTurnAtPosition(.TopLeft)
        game.takeTurnAtPosition(.TopMiddle)
        XCTAssertEqual(view.gameBoard.lastTurn, .TopRight)
        game.takeTurnAtPosition(.BottomLeft)
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleLeft)
        game.takeTurnAtPosition(.MiddleRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .BottomMiddle)
        game.takeTurnAtPosition(.BottomRight)
        XCTAssertEqual(view.gameStatus, GameStatus.Stalemate)
    }
    
    func testGivenGame_WhenTakingTurnsHumanStartsMiddleAndFirstEmptyPositions_ThenComputerPlaysCornerFirstAndWins() {
        
        game.takeTurnAtPosition(.Middle)
        XCTAssertTrue(view.gameBoard.lastTurn!.isCorner)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        XCTAssertEqual(view.gameBoard.lastTurn, .BottomMiddle)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        XCTAssertEqual(view.gameBoard.lastTurn, .BottomLeft)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        XCTAssertEqual(view.gameBoard.lastTurn, .BottomRight)
        XCTAssertEqual(view.gameStatus, GameStatus.ComputerWins)
    }
    
    func testGivenGame_WhenTakingTurnsComputerWinsAndHumanTriesToTakeTurn_ThenComputerStillWins() {
        game.takeTurnAtPosition(.Middle)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        XCTAssertEqual(view.gameStatus, GameStatus.ComputerWins)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        XCTAssertEqual(view.gameStatus, GameStatus.ComputerWins)
    }
    
    func testGivenGame_WhenTakingTurnsHumanPlaysMiddleThenBottomRight_ThenComputerBlocksTopRight() {
        game.takeTurnAtPosition(.Middle)
        game.takeTurnAtPosition(.BottomRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .TopRight)
    }
    
    func testGivenGame_WhenTakingTurnsHumanStartsMiddle_ThenGameIsStalemate() {
        game.takeTurnAtPosition(.Middle)
        game.takeTurnAtPosition(.BottomRight)
        game.takeTurnAtPosition(.TopMiddle)
        game.takeTurnAtPosition(.BottomLeft)
        game.takeTurnAtPosition(.MiddleRight)
        XCTAssertEqual(view.gameStatus, GameStatus.Stalemate)
    }
}
