import XCTest
@testable import TicTacToe

class GameTreeBotVersusHumanTests: XCTestCase, TicTacToeTestCase {

    var view: GameView!
    var game: TicTacToe!
    var bot: TicTacToeBot?
    
    override func setUp() {
        super.setUp()
        newGame(.ComputerVersusHuman, bot: TicTacToeGameTreeBot())
    }
    
    // MARK:- Performance Tests (keep the bot fast)
    
    func testGivenMeasureBlock_WhenBotTakesFirstTurn_MeasureBotPerformance() {
        measureBlock { () -> Void in
            self.newGame(.ComputerVersusHuman, bot: TicTacToeGameTreeBot())
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
        self.newGame(.ComputerVersusHuman, bot: TicTacToeGameTreeBot(), markers: markers)
        XCTAssertEqual(view.gameBoard.emptyPositions.count,6)
    }
    
    //MARK: - Second Move Tests
    
    func testGivenView_WhenHumanPlaysEdgeNextToFirstCorner_ThenComputerPlaysNextEdge(){
        XCTAssertEqual(view.gameBoard.lastTurn, .TopLeft)
        game.takeTurnAtPosition(.TopMiddle)
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleLeft)
        game.takeTurnAtPosition(.BottomLeft)
    }
    
    //MARK:- Human Second Move Plays Edge / End Game Tests
    
    func testGivenWinnableBoard_WhenTakingTurn_ThenComputerPlaysWinningMiddlePosition() {
        let markers: [BoardMarker] = [
            .Cross,.Nought,.None,
            .Cross,.None,.None,
            .Nought,.None,.None]
        
        self.newGame(.ComputerVersusHuman, bot: TicTacToeGameTreeBot(), markers: markers)
        XCTAssertEqual(view.gameBoard.lastTurn, .Middle)
    }
    
    func testGivenWinnableBoard_WhenHumanBlocksDiagonal_ThenComputerPlaysWinningRow() {
        let markers: [BoardMarker] = [
            .Cross,.Nought,.None,
            .Cross,.Cross,.None,
            .Nought,.None,.None]
        
        self.newGame(.ComputerVersusHuman, bot: TicTacToeGameTreeBot(), markers: markers)
            game.takeTurnAtPosition(.MiddleRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .BottomRight)
        XCTAssertEqual(view.gameStatus, GameStatus.ComputerWins)
    }
    
    func testGivenWinnableBoard_WhenHumanBlocksRow_ThenComputerPlaysWinningDiagonal() {
        let markers: [BoardMarker] = [
            .Cross,.Nought,.None,
            .Cross,.Cross,.None,
            .Nought,.None,.None]
        
        self.newGame(.ComputerVersusHuman, bot: TicTacToeGameTreeBot(), markers: markers)
        game.takeTurnAtPosition(.BottomRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleRight)
        XCTAssertEqual(view.gameStatus, GameStatus.ComputerWins)
    }
    
    //MARK:- End Game Tests
    
    func testGivenTieOrWinBoard_WhenBotTakesTurn_ThenTurnTakenIsWinMove() {
        let markers: [BoardMarker] = [
            .Nought,.Nought,.Cross,
            .None,.Cross,.None,
            .Nought,.Cross,.None]
        
        self.newGame(.ComputerVersusHuman, bot: TicTacToeGameTreeBot(), markers: markers)
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleLeft)

    }
    
    func testGivenTieOrWinBoard_WhenHumanDoesntBlock_ThenComputerWins() {
        let markers: [BoardMarker] = [
            .Nought,.Nought,.Cross,
            .Cross,.Cross,.None,
            .Nought,.Cross,.None]
        
        newGame(.ComputerVersusHuman, bot: TicTacToeGameTreeBot(), markers: markers)
        game.takeTurnAtPosition(.BottomRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleRight)
        XCTAssertEqual(view.gameStatus, GameStatus.ComputerWins)

    }
    
    func testGivenTieOrWinBoard_WhenBotTakesTurnAndHumanBlocks_ThenStalemate() {
        let markers: [BoardMarker] = [
            .Nought,.Nought,.Cross,
            .None,.Cross,.None,
            .Nought,.Cross,.None]
        
        self.newGame(.ComputerVersusHuman, bot: TicTacToeGameTreeBot(), markers: markers)
        XCTAssertEqual(view.gameBoard.lastTurn, .MiddleLeft)
        game.takeTurnAtPosition(.MiddleRight)
        XCTAssertEqual(view.gameStatus, GameStatus.Stalemate)
        
    }
    
    func testGivenWinnableCenterDiagonalBoard_WhenBotTakesTurn_ThenComputerWins() {
        let markers: [BoardMarker] = [
            .Nought,.None,.Cross,
            .Cross,.None,.None,
            .Cross,.Nought,.Nought]
        
        self.newGame(.ComputerVersusHuman, bot: TicTacToeGameTreeBot(), markers: markers)
        XCTAssertEqual(view.gameBoard.lastTurn, .Middle)
        XCTAssertEqual(view.gameStatus, GameStatus.ComputerWins)
        
    }

}