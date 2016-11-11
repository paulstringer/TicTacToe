import XCTest
@testable import TicTacToe

class HumanVersusHeuristicGameBotTests: XCTestCase, GameTestCase {

    var view: GameView!
    var game: Game!
    
    var bot:GameBot? = HeuristicGameBot()
    var type:GameType = .humanVersusComputer
    
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
    
    //MARK:- Turn taking Tests
    
    func testGivenGame_WhenTakingTurn_ThenPlayerOneIsUp() {
        game.takeTurnAtPosition(.topLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
    }
    
    func testGivenGame_WhenTakingTurn_ThenComputerTookATurn() {
        game.takeTurnAtPosition(.topLeft)
        XCTAssertNotNil(view.gameBoard.lastTurn)
        XCTAssertNotEqual(view.gameBoard.lastTurn, .topLeft)
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
    
    //Mark:- Perfect Strategic Human V Computer Game
    
    func testGivenGame_WhenTakingWinOrTieMoves_ThenGameIsStalemate() {
        game.takeTurnAtPosition(.topLeft)
        XCTAssertEqual(view.gameBoard.lastTurn, .middle)
        game.takeTurnAtPosition(.bottomRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .topMiddle)
        game.takeTurnAtPosition(.bottomMiddle)
        XCTAssertEqual(view.gameBoard.lastTurn, .bottomLeft)
        game.takeTurnAtPosition(.topRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .middleRight)
        game.takeTurnAtPosition(.middleLeft)
        XCTAssertEqual(view.gameBoard.lastTurn, .middleLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.stalemate)
    }
    
    //Mark:- Various Win / Draw Scenario Tests
    
    func testGivenGame_WhenHumanMissesBlockTopRightToBottomLeftDiagonal_ThenComputerPlaysTopRightAndWins() {
        game.takeTurnAtPosition(.topLeft)
        game.takeTurnAtPosition(.bottomRight)
        game.takeTurnAtPosition(.bottomMiddle)
        game.takeTurnAtPosition(.middleRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .topRight)
        XCTAssertEqual(view.gameStatus, GameStatus.computerWins)
    }
    
    func testGivenGame_WhenTakingTurnsButHumanMissesBlockAtBottomMiddle_ThenComputerPlaysBottomMiddleAndWins() {
        game.takeTurnAtPosition(.topLeft)
        game.takeTurnAtPosition(.bottomRight)
        game.takeTurnAtPosition(.topRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .bottomMiddle)
        XCTAssertEqual(view.gameStatus, GameStatus.computerWins)
    }
    
    func testGivenGame_WhenTakingTurnsHumanTrysLeftEdgeLine_ThenComputerPlaysDiagonalAndWins() {
        game.takeTurnAtPosition(.topLeft)
        game.takeTurnAtPosition(.bottomLeft)
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
        XCTAssertEqual(view.gameBoard.lastTurn, .bottomRight)
        game.takeTurnAtPosition(.bottomMiddle)
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
    
    func testGivenGame_WhenTakingTurnsHumanStartsMiddleThenBottomRight_ThenComputerBlocksTopRight() {
        game.takeTurnAtPosition(.middle)
        game.takeTurnAtPosition(.bottomRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .topRight)
    }
    
    func testGivenGame_WhenTakingTurnsHumanStartsMiddle_ThenGameIsDraw() {
        game.takeTurnAtPosition(.middle)
        game.takeTurnAtPosition(.bottomRight)
        game.takeTurnAtPosition(.topMiddle)
        game.takeTurnAtPosition(.bottomLeft)
        game.takeTurnAtPosition(.middleRight)
        XCTAssertEqual(view.gameStatus, GameStatus.stalemate)
    }
    
}
