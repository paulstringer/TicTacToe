import XCTest
@testable import TicTacToe

class HumanVersusHumanTests: XCTestCase, GameTestCase  {
    
    var view: GameView!
    var game: Game!
    
    var bot: GameBot? = nil
    var type: GameType = .humanVersusHuman
    
    override func setUp() {
        super.setUp()
        setUpGame()
    }
    
    //MARK:- Humam V Human Tests

    func testGivenView_WhenNewHumanVersusHumanGameStarted_ThenPlayerOneUp() {
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
    }
    
    func testGivenView_WhenNewHumanVersusHumanGameStarted_ThenLastTurnIsNil() {
        XCTAssertNil(view.gameBoard.lastTurn)
    }
    
    //MARK:- Humam V Human Turn Order Tests
    
    func testGivenView_WhenTakingTurns_ThenViewsPlayerUpAlternates() {
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
        game.takeTurnAtPosition(.topLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoUp)
        game.takeTurnAtPosition(.middleLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
        game.takeTurnAtPosition(.bottomLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoUp)
        game.takeTurnAtPosition(.topMiddle)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
        game.takeTurnAtPosition(.middleRight)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoUp)
    }
    
    func testGivenGame_WhenTakingTurnWherePositionIsTooSmall_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurnAtPosition(-1)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
    }
    
    func testGivenGame_WhenTakingTurnWherePositionIsTooBig_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurnAtPosition(9)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysSamePositionAsPlayerOne_ThenViewsPlayerRemainsPlayerTwo(){
        game.takeTurnAtPosition(.middle)
        game.takeTurnAtPosition(.middle)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoUp)
    }
    
    //MARK:- Horizontal Winning Tests
    
    func testGivenGame_WhenPlayerOnePlaysTopEdge_ThenViewsGameStatusIsPlayerOneWins() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
        game.takeTurnAtPosition(2)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysMiddleRow_ThenViewsGameStatusIsPlayerOneWins() {
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(1)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
        game.takeTurnAtPosition(5)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysBottomEdge_ThenViewsGameStatusIsPlayerOneWins() {
        game.takeTurnAtPosition(6)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(7)
        game.takeTurnAtPosition(1)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
        game.takeTurnAtPosition(8)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysTopEdge_ThenViewsGameStatusIsPlayerTwoWins() {
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(6)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoUp)
        game.takeTurnAtPosition(2)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysMiddleRow_ThenViewsGameStatusIsPlayerOneWins() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(6)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoUp)
        game.takeTurnAtPosition(5)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysBottomEdge_ThenViewsGameStatusIsPlayerTwoWins() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(6)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(7)
        game.takeTurnAtPosition(3)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoUp)
        game.takeTurnAtPosition(8)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysSequentialSquaresNotOnARow_ThenPlayerTwoIsUp() {
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(4)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
        game.takeTurnAtPosition(3)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoUp)
    }

    //MARK: Horizontal Blocking Tests
    
    func testGivenGame_WhenPlayerTwoBlocksPlayerOnesTopEdge_ThenViewsPlayerUpIsPlayerOne() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(6)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(2)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
    }
    
    func testGivenGame_WhenPlayerOneBlocksPlayerTwosMiddleColumn_ThenViewsPlayerUpIsPlayerTwo() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(5)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoUp)
    }
    
    //MARK:- Vertical Winning Tests
    
    func testGivenGame_WhenPlayerOnePlaysLeftEdge_ThenPlayerOneWins(){
        game.takeTurnAtPosition(.topLeft)
        game.takeTurnAtPosition(.topMiddle)
        game.takeTurnAtPosition(.middleLeft)
        game.takeTurnAtPosition(.topRight)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
        game.takeTurnAtPosition(.bottomLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysMiddleColumn_ThenPlayerOneWins(){
        game.takeTurnAtPosition(.topMiddle)
        game.takeTurnAtPosition(.topLeft)
        game.takeTurnAtPosition(.middle)
        game.takeTurnAtPosition(.topRight)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
        game.takeTurnAtPosition(.bottomMiddle)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysRightEdge_ThenPlayerOneWins(){
        game.takeTurnAtPosition(.topRight)
        game.takeTurnAtPosition(.topLeft)
        game.takeTurnAtPosition(.middleRight)
        game.takeTurnAtPosition(.topMiddle)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneUp)
        game.takeTurnAtPosition(.bottomRight)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysLeftEdge_ThenPlayerTwoWins(){
        game.takeTurnAtPosition(.topMiddle)
        game.takeTurnAtPosition(.topLeft)
        game.takeTurnAtPosition(.topRight)
        game.takeTurnAtPosition(.middleLeft)
        game.takeTurnAtPosition(.bottomRight)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoUp)
        game.takeTurnAtPosition(.bottomLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysMiddleColumn_ThenPlayerTwoWins(){
        game.takeTurnAtPosition(.topLeft)
        game.takeTurnAtPosition(.topMiddle)
        game.takeTurnAtPosition(.topRight)
        game.takeTurnAtPosition(.middle)
        game.takeTurnAtPosition(.bottomLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoUp)
        game.takeTurnAtPosition(.bottomMiddle)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysRightEdge_ThenPlayerTwoWins(){
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(5)
        game.takeTurnAtPosition(3)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoUp)
        game.takeTurnAtPosition(8)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoWins)
    }
    
    //MARK:- Diagonal Winning Tests
    
    func testGivenGame_WhenPlayerOnePlaysDiagonalFromTopLeft_ThenPlayerOneWins(){
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(8)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysDiagonalFromTopRight_ThenPlayerOneWins(){
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(6)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysDiagonalFromBottomLeft_ThenPlayerOneWins(){
        game.takeTurnAtPosition(6)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(2)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysDiagonalFromBottomRight_ThenPlayerOneWins(){
        game.takeTurnAtPosition(8)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(0)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysDiagonalFromLeft_ThenPlayerTwoWins() {
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(8)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysDiagonalFromRight_ThenPlayerTwoWins() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(6)
        XCTAssertEqual(view.gameStatus, GameStatus.playerTwoWins)
    }
    
    //MARK:- Stalemate Tests
    
    func testGivenGame_WhenPlayersReachStalemate_ThenIsStalemate() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(6)
        game.takeTurnAtPosition(5)
        game.takeTurnAtPosition(8)
        game.takeTurnAtPosition(7)
        XCTAssertEqual(view.gameStatus, GameStatus.stalemate)
        
    }
    
    func testGivenGame_WhenPlayersReachAnotherStalemate_ThenIsStalemate() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(5)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(6)
        game.takeTurnAtPosition(7)
        game.takeTurnAtPosition(8)
        XCTAssertEqual(view.gameStatus, GameStatus.stalemate)
        
    }
    
    func testGivenStalemate_WhenPlayerOneTrysToCheat_ThenGameRemainsStalemate() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(5)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(6)
        game.takeTurnAtPosition(7)
        game.takeTurnAtPosition(8)
        
        game.takeTurnAtPosition(2)
        XCTAssertEqual(view.gameStatus, GameStatus.stalemate)
        
    }
    
    //MARK:- Completed Game Tests

    func testGivenCompletedGame_WhenAttemptingToTakingTurn_ThenBoardDoesNotChange() {
        let markers: [BoardMarker] = [.cross, .cross, .none,  .nought, .nought, .none,  .none, .none, .none]
        setUpGame(markers)
        game.takeTurnAtPosition(.topRight)
        game.takeTurnAtPosition(.middleRight)
        XCTAssertEqual(view.gameBoard.lastTurn, .topRight)
    }
    
    func testGivenGame_WhenWinningLineEqualsTopRow_ThenGameStateValueEqualsTopRow() {
        let markers: [BoardMarker] = [.cross, .cross, .none,  .nought, . nought, .cross,  .cross, .nought , .nought]
        setUpGame(markers)
        game.takeTurnAtPosition(.topRight)
        XCTAssertEqual(view.gameStatus, GameStatus.playerOneWins)
        XCTAssertEqual(view.gameBoard.winningLine!, [BoardPosition.topLeft, BoardPosition.topMiddle, BoardPosition.topRight])
    }
}
