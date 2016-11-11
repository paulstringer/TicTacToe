import XCTest
@testable import TicTacToe

class MinixmaxGameBotVersusHumanTests: XCTestCase, GameTestCase {

    var view: GameView!
    var game: Game!
    var bot: GameBot? = MinimaxGameBot(testable: true)
    var type: GameType = .computerVersusHuman
    
    override func setUp() {
        super.setUp()
        setUpGame()
    }
    
    // MARK:- Performance Tests (keep the bot fast)
    
    func testGivenMeasureBlock_WhenBotTakesFirstTurn_MeasureBotPerformance() {
        measure { () -> Void in
            self.setUpGame()
        }
    }
    
    // MARK:- Initial Game State Tests
    
    func testGivenView_WhenNewComputerVersusHumanGameStarted_ThenPlayerOneUp() {
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
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
            .nought,.cross,.cross,
            .none,.none,.none,
            .none,.none,.none]
        setUpGame(markers)
        XCTAssertEqual(view.gameBoard.emptyPositions.count,6)
    }
    
    //MARK: - Second Move Tests
    
    func testGivenView_WhenHumanPlaysEdgeNextToFirstCorner_ThenComputerPlaysNextEdge(){
        XCTAssertEqual(view.gameBoard.lastTurn, .topLeft)
        game.takeTurnAtPosition(.topMiddle)
        XCTAssertEqual(view.gameBoard.lastTurn, .middleLeft)
        game.takeTurnAtPosition(.bottomLeft)
    }
    
    //MARK:- Human Second Move Plays Edge / End Game Tests
    
    func testGivenWinnableBoard_WhenTakingTurn_ThenComputerPlaysWinningMiddlePosition() {
        let markers: [BoardMarker] = [
            .cross,.nought,.none,
            .cross,.none,.none,
            .nought,.none,.none]
        
        setUpGame(markers)
        XCTAssertEqual(view.gameBoard.lastTurn, .middle)
    }
    
    func testGivenWinnableBoard_WhenHumanBlocksDiagonal_ThenComputerPlaysWinningRow() {
        let markers: [BoardMarker] = [
            .cross,.nought,.none,
            .cross,.cross,.none,
            .nought,.none,.none]
        
        setUpGame(markers)
            game.takeTurnAtPosition(.middleRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .bottomRight)
        XCTAssertEqual(view.gameStatus, GameStatus.computerWins)
    }
    
    func testGivenWinnableBoard_WhenHumanBlocksRow_ThenComputerPlaysWinningDiagonal() {
        let markers: [BoardMarker] = [
            .cross,.nought,.none,
            .cross,.cross,.none,
            .nought,.none,.none]
        
        setUpGame(markers)
        game.takeTurnAtPosition(.bottomRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .middleRight)
        XCTAssertEqual(view.gameStatus, GameStatus.computerWins)
    }
    
    //MARK:- End Game Tests
    
    func testGivenTieOrWinBoard_WhenBotTakesTurn_ThenTurnTakenIsWinMove() {
        let markers: [BoardMarker] = [
            .nought,.nought,.cross,
            .none,.cross,.none,
            .nought,.cross,.none]
        
        setUpGame(markers)
        XCTAssertEqual(view.gameBoard.lastTurn, .middleLeft)

    }
    
    func testGivenTieOrWinBoard_WhenHumanDoesntBlock_ThenComputerWins() {
        let markers: [BoardMarker] = [
            .nought,.nought,.cross,
            .cross,.cross,.none,
            .nought,.cross,.none]
        
        setUpGame(markers)
        game.takeTurnAtPosition(.bottomRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .middleRight)
        XCTAssertEqual(view.gameStatus, GameStatus.computerWins)

    }
    
    func testGivenTieOrWinBoard_WhenBotTakesTurnAndHumanBlocks_ThenStalemate() {
        let markers: [BoardMarker] = [
            .nought,.nought,.cross,
            .none,.cross,.none,
            .nought,.cross,.none]
        
        setUpGame(markers)
        XCTAssertEqual(view.gameBoard.lastTurn, .middleLeft)
        game.takeTurnAtPosition(.middleRight)
        XCTAssertEqual(view.gameStatus, GameStatus.stalemate)
        
    }
    
    func testGivenWinnableCenterDiagonalBoard_WhenBotTakesTurn_ThenComputerWins() {
        let markers: [BoardMarker] = [
            .nought,.none,.cross,
            .cross,.none,.none,
            .cross,.nought,.nought]
        
        setUpGame(markers)
        XCTAssertEqual(view.gameBoard.lastTurn, .middle)
        XCTAssertEqual(view.gameStatus, GameStatus.computerWins)
        
    }

}
