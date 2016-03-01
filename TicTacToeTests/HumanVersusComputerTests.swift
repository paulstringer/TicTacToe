import XCTest
@testable import TicTacToe

class HumanVersusComputerTests: XCTestCase, TicTacToeTestCase {

    var view: GameViewSpy!
    var game: TicTacToe!
    
    override func setUp() {
        super.setUp()
        view = GameViewSpy()
        game = TicTacToe(view: view)
        game.ready()
        game.gameType = .HumanVersusComputer
    }
    
    //MARK:- Humam V Human Tests
    
    func testGivenGame_WhenReady_ThenViewsGameTypesContainsHumanVersusComputer() {
        XCTAssertTrue(view.gameTypes.contains(.HumanVersusComputer))
    }
    
    func testGivenGame_WhenReady_ThenPlayerOneUp() {
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenReady_ThenLastTurnIsNil() {
        XCTAssertNil(view.gameBoard.lastTurn)
    }
    
    func testGivenGame_WhenReady_ThenPlayerOneIsUp() {
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    //MARK:- Turn taking Tests
    
    func testGivenGame_WhenTakingTurn_ThenPlayerOneIsUp() {
        game.takeTurnAtPosition(0)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenTakingTurn_ThenComputerTookATurn() {
        game.takeTurnAtPosition(.TopLeft)
        XCTAssertNotNil(view.gameBoard.lastTurn)
        XCTAssertNotEqual(view.gameBoard.lastTurn, .TopLeft)
    }
    
    func testGivenGame_WhenTakingTurnAtSecondPosition_ThenComputerTakesTurnAtDifferentPosition() {
        game.takeTurnAtPosition(1)
        XCTAssertNotEqual(view.gameBoard.lastTurn, BoardPosition(rawValue: 1))
    }
    
    func testGivenGame_WhenTakingSecondTurn_ThenComputersSecondTurnIsAtDifferentPosition() {
        game.takeTurnAtPosition(0)
        let position = view.gameBoard.emptyPositions.first!
        game.takeTurnAtPosition(position)
        XCTAssertNotEqual(view.gameBoard.lastTurn, position)
    }
    
    func testGivenGame_WhenTakingTurn_ThenBoardHasOneCrossAndOneNought() {
        game.takeTurnAtPosition(0)
        XCTAssertEqual(view.gameBoard.noughts, 1)
        XCTAssertEqual(view.gameBoard.crosses, 1)
    }
    
    func testGivenGame_WhenTakingTwoTurns_ThenBoardHasTwoCrossesAndTwoNoughts() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        XCTAssertEqual(view.gameBoard.noughts, 2)
        XCTAssertEqual(view.gameBoard.noughts, 2)
    }

    // http://www.wikihow.com/Win-at-Tic-Tac-Toe
    
    //Mark:- Perfect Human V Computer Game
    
    func testGivenGame_WhenTakingTurnsForPerfectStrategies_ThenGameIsStalemate() {
        game.takeTurnAtPosition(.TopLeft)
        XCTAssertEqual(view.gameBoard.lastTurn, .Middle)
        game.takeTurnAtPosition(.BottomRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .TopMiddle)
        game.takeTurnAtPosition(.BottomMiddle)
        XCTAssertEqual(view.gameBoard.lastTurn, .BottomLeft)
        game.takeTurnAtPosition(.TopRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleRight)
        game.takeTurnAtPosition(.MiddleLeft)
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleLeft)
        XCTAssertEqual(view.gameState, GameState.Stalemate)
    }
    
    func testGivenGame_WhenTakingTurnsButHumanMissesBlockTopRightToBottomLeftDiagonal_ThenComputerPlaysTopRightAndWins() {
        game.takeTurnAtPosition(.TopLeft)
        game.takeTurnAtPosition(.BottomRight)
        game.takeTurnAtPosition(.BottomMiddle)
        game.takeTurnAtPosition(.MiddleRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .TopRight)
        XCTAssertEqual(view.gameState, GameState.ComputerWins)
    }
    
    func testGivenGame_WhenTakingTurnsButHumanMissesBlockAtBottomMiddle_ThenComputerPlaysBottomMiddleAndWins() {
        game.takeTurnAtPosition(.TopLeft)
        game.takeTurnAtPosition(.BottomRight)
        game.takeTurnAtPosition(.TopRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .BottomMiddle)
        XCTAssertEqual(view.gameState, GameState.ComputerWins)
    }
    
    func testGivenGame_WhenTakingTurnsHumanTrysLeftEdgeLine_ThenComputerPlaysDiagonalAndWins() {
        game.takeTurnAtPosition(.TopLeft)
        game.takeTurnAtPosition(.BottomLeft)
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleLeft)
        game.takeTurnAtPosition(.TopMiddle)
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleRight)
        XCTAssertEqual(view.gameState, GameState.ComputerWins)
    }
    

}
