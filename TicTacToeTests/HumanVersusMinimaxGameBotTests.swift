import XCTest
@testable import TicTacToe

class HumanVersusMinimaxGameBotTests: XCTestCase, GameTestCase {

    var view: GameView!
    var game: Game!
    
    let bot: GameBot? = MinimaxGameBot(testable: true)
    let type: GameType = .humanVersusComputer
    
    override func setUp() {
        super.setUp()
        setUpGame()
    }
    
    //MARK:- Human V Computer Basic Setup Tests
    
    func testGivenView_WhenNewHumanVersusComputerGameStarted_ThenPlayerOneUp() {
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
    }
    
    func testGivenView_WhenNewHumanVersusComputerGameStarted_ThenLastTurnIsNil() {
        XCTAssertNil(view.gameBoard.lastTurn)
    }
    
    //TODO:- Turn taking tests
    
    func testGivenGame_WhenTakingTurn_ThenPlayerOneIsUp() {
        game.takeTurnAtPosition(.topLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
    }
    
    func testGivenGame_WhenTakingTurn_ThenComputerTookATurn() {
        game.takeTurnAtPosition(.topLeft)
        XCTAssertNotNil(view.gameBoard.lastTurn)
        XCTAssertNotEqual(view.gameBoard.lastTurn, .topLeft)
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
        game.takeTurnAtPosition(.topLeft)
        XCTAssertEqual(view.gameBoard.lastTurn, .middle)
        game.takeTurnAtPosition(.bottomRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .topMiddle)
        game.takeTurnAtPosition(.bottomMiddle)
        XCTAssertEqual(view.gameBoard.lastTurn, .bottomLeft)
        game.takeTurnAtPosition(.topRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .middleRight)
        game.takeTurnAtPosition(.middleLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.stalemate)
    }
    
      //Mark:- Various Win / Draw Scenario Tests
    
    func testGivenGame_WhenHumanMissesBlockTopRightToBottomLeftDiagonal_ThenComputerPlaysTopRightAndWins() {
        
        let markers: [BoardMarker] = [
            .cross, .nought , .none,
            .none , .nought , .none ,
            .nought , .cross , .cross ,
        ]
        
        setUpGame(markers)
        
        game.takeTurnAtPosition(.middleRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .topRight)
        XCTAssertEqual(view.gameStatus, GameStatus.computerWins)
    }
    
    func testGivenGame_WhenTakingTurnsButHumanMissesBlockAtBottomMiddle_ThenComputerPlaysBottomMiddleAndWins() {
        
        let markers: [BoardMarker] = [
            .cross, .nought , .none,
            .none , .nought , .none ,
            .none , .none , .cross ,
        ]
        
        setUpGame(markers)
        game.takeTurnAtPosition(.topRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .bottomMiddle)
        XCTAssertEqual(view.gameStatus, GameStatus.computerWins)
    }
    
    func testGivenGame_WhenTakingTurnsHumanTrysLeftEdgeLine_ThenComputerPlaysDiagonalAndWins() {
        
        let markers: [BoardMarker] = [
            .cross, .none , .none,
            .none, .nought , .none ,
            .cross, .none , .none ,
        ]
        
        setUpGame(markers)
        
        XCTAssertEqual(view.gameBoard.lastTurn, .middleLeft)
        game.takeTurnAtPosition(.topMiddle)
        XCTAssertEqual(view.gameBoard.lastTurn, .middleRight)
        XCTAssertEqual(view.gameStatus, GameStatus.computerWins)
    }
    
    func testGivenGame_WhenHumanTrysEdgesThenBlocksSuccessfully_ThenGameIsStalemate() {
        game.takeTurnAtPosition(.topLeft)
        game.takeTurnAtPosition(.topMiddle)
        XCTAssertEqual(view.gameBoard.lastTurn, .topRight)
        game.takeTurnAtPosition(.bottomLeft)
        XCTAssertEqual(view.gameBoard.lastTurn, .middleLeft)
        game.takeTurnAtPosition(.middleRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .bottomMiddle)
        game.takeTurnAtPosition(.bottomRight)
        XCTAssertEqual(view.gameStatus, GameStatus.stalemate)
    }
    
    func testGivenGame_WhenTakingTurnsHumanStartsMiddleAndFirstEmptyPositions_ThenComputerPlaysCornerFirstAndWins() {
        game.takeTurnAtPosition(.middle)
        XCTAssertTrue(view.gameBoard.lastTurn!.isCorner)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        XCTAssertEqual(view.gameBoard.lastTurn, .bottomMiddle)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        XCTAssertEqual(view.gameBoard.lastTurn, .bottomLeft)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        XCTAssertEqual(view.gameBoard.lastTurn, .bottomRight)
        XCTAssertEqual(view.gameStatus, GameStatus.computerWins)
    }
    
    func testGivenGame_WhenTakingTurnsComputerWinsAndHumanTriesToTakeTurn_ThenComputerStillWins() {
        game.takeTurnAtPosition(.middle)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        XCTAssertEqual(view.gameStatus, GameStatus.computerWins)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        XCTAssertEqual(view.gameStatus, GameStatus.computerWins)
    }
    
    func testGivenGame_WhenTakingTurnsHumanPlaysMiddleThenBottomRight_ThenComputerBlocksTopRight() {
        game.takeTurnAtPosition(.middle)
        game.takeTurnAtPosition(.bottomRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .topRight)
    }
    
    func testGivenGame_WhenTakingTurnsHumanStartsMiddle_ThenGameIsStalemate() {
        game.takeTurnAtPosition(.middle)
        game.takeTurnAtPosition(.bottomRight)
        game.takeTurnAtPosition(.topMiddle)
        game.takeTurnAtPosition(.bottomLeft)
        game.takeTurnAtPosition(.middleRight)
        XCTAssertEqual(view.gameStatus, GameStatus.stalemate)
    }

}
