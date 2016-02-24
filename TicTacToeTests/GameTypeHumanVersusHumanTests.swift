import XCTest
@testable import TicTacToe

class GameTypeHumanVersusHumanTests: XCTestCase {
    
    let view = GameViewSpy()
    var game: TicTacToe!
    
    override func setUp() {
        super.setUp()
        game = TicTacToe(view: view)
        game.ready()
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
        game.takeTurnAtRow(1, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtRow(2, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtRow(3, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtRow(1, column: 2)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtRow(2, column: 2)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
    }
    
    func testGivenGame_WhenTakingTurnWhereRowIsLessThanOne_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurnAtRow(0, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenTakingTurnWhereRowIsGreaterThanThree_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurnAtRow(4, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenTakingTurnWhereColumnIsLessThanOne_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurnAtRow(1, column: 0)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenTakingTurnWhereColumnIsGreaterThanThree_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurnAtRow(1, column: 4)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysSameSquareAsPlayerOne_ThenViewsPlayerRemainsPlayerTwo(){
        game.takeTurnAtRow(1, column: 3)
        game.takeTurnAtRow(1, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
    }
    
    //MARK:- Horizontal Winning Tests
    
    func testGivenGame_WhenPlayerOnePlaysTopEdge_ThenViewsGameStateIsPlayerOneWins() {
        game.takeTurnAtRow(1, column: 1)
        game.takeTurnAtRow(2, column: 1)
        game.takeTurnAtRow(1, column: 2)
        game.takeTurnAtRow(2, column: 2)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtRow(1, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysMiddleRow_ThenViewsGameStateIsPlayerOneWins() {
        game.takeTurnAtRow(2, column: 1)
        game.takeTurnAtRow(1, column: 1)
        game.takeTurnAtRow(2, column: 2)
        game.takeTurnAtRow(1, column: 2)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtRow(2, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysBottomEdge_ThenViewsGameStateIsPlayerOneWins() {
        game.takeTurnAtRow(3, column: 1)
        game.takeTurnAtRow(1, column: 1)
        game.takeTurnAtRow(3, column: 2)
        game.takeTurnAtRow(1, column: 2)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtRow(3, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysTopEdge_ThenViewsGameStateIsPlayerTwoWins() {
        game.takeTurnAtRow(2, column: 1)
        game.takeTurnAtRow(1, column: 1)
        game.takeTurnAtRow(2, column: 2)
        game.takeTurnAtRow(1, column: 2)
        game.takeTurnAtRow(3, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtRow(1, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysMiddleRow_ThenViewsGameStateIsPlayerOneWins() {
        game.takeTurnAtRow(1, column: 1)
        game.takeTurnAtRow(2, column: 1)
        game.takeTurnAtRow(1, column: 2)
        game.takeTurnAtRow(2, column: 2)
        game.takeTurnAtRow(3, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtRow(2, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysBottomEdge_ThenViewsGameStateIsPlayerTwoWins() {
        game.takeTurnAtRow(1, column: 1)
        game.takeTurnAtRow(3, column: 1)
        game.takeTurnAtRow(1, column: 2)
        game.takeTurnAtRow(3, column: 2)
        game.takeTurnAtRow(2, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtRow(3, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }

    //MARK:- Horizontal Blocking Tests
    
    func testGivenGame_WhenPlayerTwoBlocksPlayerOnesTopEdge_ThenViewsPlayerUpIsPlayerOne() {
        game.takeTurnAtRow(1, column: 1)
        game.takeTurnAtRow(3, column: 1)
        game.takeTurnAtRow(1, column: 2)
        game.takeTurnAtRow(1, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenPlayerOneBlocksPlayerTwosMiddleColumn_ThenViewsPlayerUpIsPlayerTwo() {
        game.takeTurnAtRow(1, column: 1)
        game.takeTurnAtRow(2, column: 1)
        game.takeTurnAtRow(1, column: 2)
        game.takeTurnAtRow(2, column: 2)
        game.takeTurnAtRow(2, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
    }
    
    //MARK:- Vertical Winning Tests
    
    func testGivenGame_WhenPlayerOnePlaysLeftEdge_ThenPlayerOneWins(){
        game.takeTurnAtSquare(.TopLeft)
        game.takeTurnAtSquare(.TopMiddle)
        game.takeTurnAtSquare(.MiddleLeft)
        game.takeTurnAtSquare(.TopRight)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtSquare(.BottomLeft)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysMiddleColumn_ThenPlayerOneWins(){
        game.takeTurnAtSquare(.TopMiddle)
        game.takeTurnAtSquare(.TopLeft)
        game.takeTurnAtSquare(.Middle)
        game.takeTurnAtSquare(.TopRight)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtSquare(.BottomMiddle)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysRightEdge_ThenPlayerOneWins(){
        game.takeTurnAtSquare(.TopRight)
        game.takeTurnAtSquare(.TopLeft)
        game.takeTurnAtSquare(.MiddleRight)
        game.takeTurnAtSquare(.TopMiddle)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtSquare(.BottomRight)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysLeftEdge_ThenPlayerTwoWins(){
        game.takeTurnAtSquare(.TopMiddle)
        game.takeTurnAtSquare(.TopLeft)
        game.takeTurnAtSquare(.TopRight)
        game.takeTurnAtSquare(.MiddleLeft)
        game.takeTurnAtSquare(.BottomRight)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtSquare(.BottomLeft)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysMiddleColumn_ThenPlayerTwoWins(){
        game.takeTurnAtSquare(.TopLeft)
        game.takeTurnAtSquare(.TopMiddle)
        game.takeTurnAtSquare(.TopRight)
        game.takeTurnAtSquare(.Middle)
        game.takeTurnAtSquare(.BottomLeft)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtSquare(.BottomMiddle)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysRightEdge_ThenPlayerTwoWins(){
        game.takeTurnAtSquare(0)
        game.takeTurnAtSquare(2)
        game.takeTurnAtSquare(1)
        game.takeTurnAtSquare(5)
        game.takeTurnAtSquare(3)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtSquare(8)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }

    
}
