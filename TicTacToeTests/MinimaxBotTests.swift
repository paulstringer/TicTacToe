import XCTest
@testable import TicTacToe

class GameTreeBotTests: XCTestCase, TicTacToeTestCase {

    var view: GameView!
    var game: TicTacToe!
    
    override func setUp() {
        super.setUp()
        newGame(.ComputerVersusHuman, bot: TicTacToeMinimaxBot())
    }
    
    // MARK:- Performance Tests (keep the bot fast)
    
    func testGivenMeasureBlock_WhenBotTakesFirstTurn_MeasureBotPerformance() {
        measureBlock { () -> Void in
            self.newGame(.ComputerVersusHuman, bot: TicTacToeMinimaxBot())
        }
    }
    
    func testGivenMeasureBlock_WhenBotTakesSecondTurn_MeasureBotPerformance() {
        measureBlock { () -> Void in
            if let position = self.view.gameBoard.emptyPositions.first {
            self.game.takeTurnAtPosition(position)
            }
        }
    }
    
    func testGivenView_WhenNewComputerVersusHumanGameStarted_ThenPlayerOneUp() {
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
    }
    
    func testGivenView_WhenNewComputerVersusHumanGameStarted_ThenLastTurnNotNil() {
        XCTAssertNotNil(view.gameBoard.lastTurn)
    }
    
    // MARK:- First Move Tests
    
    func testGivenView_WhenBotTakesFirstTurn_FirstTurnEqualsCorner() {
        XCTAssertTrue(view.gameBoard.lastTurn!.isCorner)
    }

    func testGivenEmptyBoard_WhenComputerVersusHumanGameStarted_ThenComputerTakesTurn() {
        XCTAssertEqual(view.gameBoard.emptyPositions.count,8)
    }
    
    func testGivenBoardWithOddNumberOfMarkers_WhenComputerVersusHumanGameStarted_ThenComputerDoesNotTakeTurn() {
        let markers: [BoardMarker] = [
            .Nought,.Cross,.Cross,
            .None,.None,.None,
            .None,.None,.None]
        self.newGame(.ComputerVersusHuman, bot: TicTacToeMinimaxBot(), markers: markers)
        XCTAssertEqual(view.gameBoard.emptyPositions.count,6)
    }
    
    //MARK: - Second Move Tests
    
    func testGivenView_WhenHumanPlaysEdgeNextToFirstCorner_ThenComputerPlaysOppositeStraightCorner(){
        XCTAssertEqual(view.gameBoard.lastTurn, .TopLeft)
        game.takeTurnAtPosition(.TopMiddle)
        XCTAssertEqual(view.gameBoard.lastTurn, .BottomLeft)
    }
    
    //MARK:- End Game Tests
    
    func testGivenTieOrWinBoardMoves_WhenBotTakesTurn_ThenTurnTakenIsWinMove() {
        let markers: [BoardMarker] = [
            .Nought,.Nought,.Cross,
            .None,.Cross,.None,
            .Nought,.Cross,.None]
        
        self.newGame(.ComputerVersusHuman, bot: TicTacToeMinimaxBot(), markers: markers)
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleLeft)

    }
    
    func testGivenTieOrWinBoard_WhenHumanDoesntBlock_ThenComputerWins() {
        let markers: [BoardMarker] = [
            .Nought,.Nought,.Cross,
            .Cross,.Cross,.None,
            .Nought,.Cross,.None]
        
        newGame(.ComputerVersusHuman, bot: TicTacToeMinimaxBot(), markers: markers)
        game.takeTurnAtPosition(.BottomRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleRight)
        XCTAssertEqual(view.gameStatus, GameStatus.ComputerWins)

    }
    
    func testGivenTieOrWinBoardMoves_WhenBotTakesTurnAndHumanBlocks_ThenStalemate() {
        let markers: [BoardMarker] = [
            .Nought,.Nought,.Cross,
            .None,.Cross,.None,
            .Nought,.Cross,.None]
        
        self.newGame(.ComputerVersusHuman, bot: TicTacToeMinimaxBot(), markers: markers)
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleLeft)
        game.takeTurnAtPosition(.MiddleRight)
        XCTAssertEqual(view.gameStatus, GameStatus.Stalemate)
        
    }

}
