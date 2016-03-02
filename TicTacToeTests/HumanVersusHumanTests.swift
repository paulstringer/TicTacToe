import XCTest
@testable import TicTacToe

class HumanVersusHumanTests: XCTestCase, TicTacToeTestCase  {
    
    var view: GameViewSpy!
    var game: TicTacToe!
    
    override func setUp() {
        super.setUp()
        view = GameViewSpy()
        game = TicTacToe(view: view)
        game.startGame(.HumanVersusHuman)
    }
    
    //MARK:- Humam V Human Tests
    
    func testGivenGame_WhenReady_ThenViewsGameTypesNotEmpty() {
        XCTAssertFalse(view.gameTypes.isEmpty)
    }
    
    func testGivenGame_WhenReady_ThenViewsGameTypesContainsHumanHuman() {
        XCTAssertTrue(view.gameTypes.contains(.HumanVersusHuman))
    }
 
    func testGivenGame_WhenTakingTurns_ThenViewsPlayerUpAlternates() {
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtPosition(.TopLeft)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtPosition(.MiddleLeft)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtPosition(.BottomLeft)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtPosition(.TopMiddle)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtPosition(.MiddleRight)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
    }
    
    func testGivenGame_WhenTakingTurnWherePositionIsTooSmall_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurnAtPosition(-1)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenTakingTurnWherePositionIsTooBig_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurnAtPosition(9)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysSamePositionAsPlayerOne_ThenViewsPlayerRemainsPlayerTwo(){
        game.takeTurnAtPosition(.Middle)
        game.takeTurnAtPosition(.Middle)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
    }
    
    //MARK:- Horizontal Winning Tests
    
    func testGivenGame_WhenPlayerOnePlaysTopEdge_ThenViewsGameStateIsPlayerOneWins() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtPosition(2)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysMiddleRow_ThenViewsGameStateIsPlayerOneWins() {
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(1)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtPosition(5)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysBottomEdge_ThenViewsGameStateIsPlayerOneWins() {
        game.takeTurnAtPosition(6)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(7)
        game.takeTurnAtPosition(1)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtPosition(8)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysTopEdge_ThenViewsGameStateIsPlayerTwoWins() {
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(6)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtPosition(2)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysMiddleRow_ThenViewsGameStateIsPlayerOneWins() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(6)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtPosition(5)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysBottomEdge_ThenViewsGameStateIsPlayerTwoWins() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(6)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(7)
        game.takeTurnAtPosition(3)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtPosition(8)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysSequentialSquaresNotOnARow_ThenPlayerTwoIsUp() {
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(4)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtPosition(3)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
    }

    //MARK:- Horizontal Blocking Tests
    
    func testGivenGame_WhenPlayerTwoBlocksPlayerOnesTopEdge_ThenViewsPlayerUpIsPlayerOne() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(6)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(2)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenPlayerOneBlocksPlayerTwosMiddleColumn_ThenViewsPlayerUpIsPlayerTwo() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(5)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
    }
    
    //MARK:- Vertical Winning Tests
    
    func testGivenGame_WhenPlayerOnePlaysLeftEdge_ThenPlayerOneWins(){
        game.takeTurnAtPosition(.TopLeft)
        game.takeTurnAtPosition(.TopMiddle)
        game.takeTurnAtPosition(.MiddleLeft)
        game.takeTurnAtPosition(.TopRight)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtPosition(.BottomLeft)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysMiddleColumn_ThenPlayerOneWins(){
        game.takeTurnAtPosition(.TopMiddle)
        game.takeTurnAtPosition(.TopLeft)
        game.takeTurnAtPosition(.Middle)
        game.takeTurnAtPosition(.TopRight)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtPosition(.BottomMiddle)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysRightEdge_ThenPlayerOneWins(){
        game.takeTurnAtPosition(.TopRight)
        game.takeTurnAtPosition(.TopLeft)
        game.takeTurnAtPosition(.MiddleRight)
        game.takeTurnAtPosition(.TopMiddle)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtPosition(.BottomRight)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysLeftEdge_ThenPlayerTwoWins(){
        game.takeTurnAtPosition(.TopMiddle)
        game.takeTurnAtPosition(.TopLeft)
        game.takeTurnAtPosition(.TopRight)
        game.takeTurnAtPosition(.MiddleLeft)
        game.takeTurnAtPosition(.BottomRight)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtPosition(.BottomLeft)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysMiddleColumn_ThenPlayerTwoWins(){
        game.takeTurnAtPosition(.TopLeft)
        game.takeTurnAtPosition(.TopMiddle)
        game.takeTurnAtPosition(.TopRight)
        game.takeTurnAtPosition(.Middle)
        game.takeTurnAtPosition(.BottomLeft)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtPosition(.BottomMiddle)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysRightEdge_ThenPlayerTwoWins(){
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(5)
        game.takeTurnAtPosition(3)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtPosition(8)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }
    
    //MARK: Diagonal Winning Tests
    
    func testGivenGame_WhenPlayerOnePlaysDiagonalFromTopLeft_ThenPlayerOneWins(){
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(8)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysDiagonalFromTopRight_ThenPlayerOneWins(){
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(6)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysDiagonalFromBottomLeft_ThenPlayerOneWins(){
        game.takeTurnAtPosition(6)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(2)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysDiagonalFromBottomRight_ThenPlayerOneWins(){
        game.takeTurnAtPosition(8)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(0)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysDiagonalFromLeft_ThenPlayerTwoWins() {
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(8)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysDiagonalFromRight_ThenPlayerTwoWins() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(2)
        game.takeTurnAtPosition(1)
        game.takeTurnAtPosition(4)
        game.takeTurnAtPosition(3)
        game.takeTurnAtPosition(6)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }
    
    //MARK: Stalemate Tests
    
    func testGivenGame_WhenPlayersReachStalemate_ThenIsStalemate() {
        takeTurnsAtPositions([0,1,2,3,4,6,5,8,7])
        XCTAssertEqual(view.gameState, GameState.Stalemate)
        
    }
    
    func testGivenGame_WhenPlayersReachAnotherStalemate_ThenIsStalemate() {
        takeTurnsAtPositions([0,2,1,3,5,4,6,7,8])
        XCTAssertEqual(view.gameState, GameState.Stalemate)
        
    }
    
    func testGivenGame_WhenStalemateAndPlayerOneTrysToCheat_ThenIsStalemate() {
        takeTurnsAtPositions([0,2,1,3,5,4,6,7,8])
        game.takeTurnAtPosition(2)
        XCTAssertEqual(view.gameState, GameState.Stalemate)
        
    }

}
