import XCTest
@testable import TicTacToe

class HumanVersusHumanTests: XCTestCase, TicTacToeTestCase  {
    
    var view: GameView!
    var game: TicTacToe!
    var bot: TicTacToeBot?
    
    override func setUp() {
        super.setUp()
        newGame(.HumanVersusHuman)
    }
    
    //MARK:- Humam V Human Tests

    func testGivenView_WhenTicTacToeInitialised_ThenViewsGameTypesContainsHumanHuman() {
        XCTAssertTrue(view.gameTypes.contains(.HumanVersusHuman))
    }
    
    func testGivenView_WhenNewHumanVersusHumanGameStarted_ThenPlayerOneUp() {
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
    }
    
    func testGivenView_WhenNewHumanVersusHumanGameStarted_ThenLastTurnIsNil() {
        XCTAssertNil(view.gameBoard.lastTurn)
    }
    
    //MARK:- Humam V Human Turn Order Tests
    
    func testGivenView_WhenTakingTurns_ThenViewsPlayerUpAlternates() {
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
        game.takeTurnAtPosition(.TopLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoUp)
        game.takeTurnAtPosition(.MiddleLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
        game.takeTurnAtPosition(.BottomLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoUp)
        game.takeTurnAtPosition(.TopMiddle)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
        game.takeTurnAtPosition(.MiddleRight)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoUp)
    }
    
    func testGivenGame_WhenTakingTurnWherePositionIsTooSmall_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurnAtPosition(-1)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
    }
    
    func testGivenGame_WhenTakingTurnWherePositionIsTooBig_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurnAtPosition(9)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysSamePositionAsPlayerOne_ThenViewsPlayerRemainsPlayerTwo(){
        game.takeTurnAtPosition(.Middle)
        game.takeTurnAtPosition(.Middle)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoUp)
    }
    
    //MARK:- Horizontal Winning Tests
    
    func testGivenGame_WhenPlayerOnePlaysTopEdge_ThenViewsGameStatusIsPlayerOneWins() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
        game.takeTurnAtPosition(2)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysMiddleRow_ThenViewsGameStatusIsPlayerOneWins() {
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(1)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
        game.takeTurnAtPosition(5)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysBottomEdge_ThenViewsGameStatusIsPlayerOneWins() {
        game.takeTurnAtPosition(6)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(7)
        game.takeTurnAtPosition(1)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
        game.takeTurnAtPosition(8)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysTopEdge_ThenViewsGameStatusIsPlayerTwoWins() {
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(6)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoUp)
        game.takeTurnAtPosition(2)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysMiddleRow_ThenViewsGameStatusIsPlayerOneWins() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(6)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoUp)
        game.takeTurnAtPosition(5)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysBottomEdge_ThenViewsGameStatusIsPlayerTwoWins() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(6)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(7)
        game.takeTurnAtPosition(3)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoUp)
        game.takeTurnAtPosition(8)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysSequentialSquaresNotOnARow_ThenPlayerTwoIsUp() {
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(4)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
        game.takeTurnAtPosition(3)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoUp)
    }

    //MARK:- Horizontal Blocking Tests
    
    func testGivenGame_WhenPlayerTwoBlocksPlayerOnesTopEdge_ThenViewsPlayerUpIsPlayerOne() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(6)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(2)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
    }
    
    func testGivenGame_WhenPlayerOneBlocksPlayerTwosMiddleColumn_ThenViewsPlayerUpIsPlayerTwo() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(5)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoUp)
    }
    
    //MARK:- Vertical Winning Tests
    
    func testGivenGame_WhenPlayerOnePlaysLeftEdge_ThenPlayerOneWins(){
        game.takeTurnAtPosition(.TopLeft)
        game.takeTurnAtPosition(.TopMiddle)
        game.takeTurnAtPosition(.MiddleLeft)
        game.takeTurnAtPosition(.TopRight)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
        game.takeTurnAtPosition(.BottomLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysMiddleColumn_ThenPlayerOneWins(){
        game.takeTurnAtPosition(.TopMiddle)
        game.takeTurnAtPosition(.TopLeft)
        game.takeTurnAtPosition(.Middle)
        game.takeTurnAtPosition(.TopRight)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
        game.takeTurnAtPosition(.BottomMiddle)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysRightEdge_ThenPlayerOneWins(){
        game.takeTurnAtPosition(.TopRight)
        game.takeTurnAtPosition(.TopLeft)
        game.takeTurnAtPosition(.MiddleRight)
        game.takeTurnAtPosition(.TopMiddle)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
        game.takeTurnAtPosition(.BottomRight)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysLeftEdge_ThenPlayerTwoWins(){
        game.takeTurnAtPosition(.TopMiddle)
        game.takeTurnAtPosition(.TopLeft)
        game.takeTurnAtPosition(.TopRight)
        game.takeTurnAtPosition(.MiddleLeft)
        game.takeTurnAtPosition(.BottomRight)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoUp)
        game.takeTurnAtPosition(.BottomLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysMiddleColumn_ThenPlayerTwoWins(){
        game.takeTurnAtPosition(.TopLeft)
        game.takeTurnAtPosition(.TopMiddle)
        game.takeTurnAtPosition(.TopRight)
        game.takeTurnAtPosition(.Middle)
        game.takeTurnAtPosition(.BottomLeft)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoUp)
        game.takeTurnAtPosition(.BottomMiddle)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysRightEdge_ThenPlayerTwoWins(){
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(5)
        game.takeTurnAtPosition(3)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoUp)
        game.takeTurnAtPosition(8)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoWins)
    }
    
    //MARK: Diagonal Winning Tests
    
    func testGivenGame_WhenPlayerOnePlaysDiagonalFromTopLeft_ThenPlayerOneWins(){
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(8)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysDiagonalFromTopRight_ThenPlayerOneWins(){
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(6)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysDiagonalFromBottomLeft_ThenPlayerOneWins(){
        game.takeTurnAtPosition(6)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(2)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysDiagonalFromBottomRight_ThenPlayerOneWins(){
        game.takeTurnAtPosition(8)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(0)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysDiagonalFromLeft_ThenPlayerTwoWins() {
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(8)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysDiagonalFromRight_ThenPlayerTwoWins() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(6)
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerTwoWins)
    }
    
    //MARK: Stalemate Tests
    
    func testGivenGame_WhenPlayersReachStalemate_ThenIsStalemate() {
        takeTurnsAtPositions([0,1,2,3,4,6,5,8,7])
        XCTAssertEqual(view.gameStatus, GameStatus.Stalemate)
        
    }
    
    func testGivenGame_WhenPlayersReachAnotherStalemate_ThenIsStalemate() {
        takeTurnsAtPositions([0,2,1,3,5,4,6,7,8])
        XCTAssertEqual(view.gameStatus, GameStatus.Stalemate)
        
    }
    
    func testGivenGame_WhenStalemateAndPlayerOneTrysToCheat_ThenIsStalemate() {
        takeTurnsAtPositions([0,2,1,3,5,4,6,7,8])
        game.takeTurnAtPosition(2)
        XCTAssertEqual(view.gameStatus, GameStatus.Stalemate)
        
    }

}
