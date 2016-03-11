import XCTest
@testable import TicTacToe

class GameBuilderTests: XCTestCase {

    let gameView = GameViewSpy()
    var game: TicTacToe!
    var builder: GameBuilder!
    
    override func setUp() {
        super.setUp()
        builder = GameBuilder()
    }
    
    func testGivenView_WhenInitialised_ThenViewsGameTypesContainsAllGamesTypes() {
        
        XCTAssertTrue(GameBuilder.GameTypes.contains(.ComputerVersusHuman))
        XCTAssertTrue(GameBuilder.GameTypes.contains(.HumanVersusHuman))
        XCTAssertTrue(GameBuilder.GameTypes.contains(.HumanVersusComputer))
    }
    
    func testGivenGameTypeComputerVersusHuman_WhenNewGame_ThenGameIsComputerVersusHuman() {
        builder.gameType = .ComputerVersusHuman
        game = builder.gameWithView(gameView)
        
        XCTAssertEqual(gameView.gameBoard.crosses, 1)
        XCTAssertEqual(gameView.gameStatus, GameStatus.PlayerOneUp)
    }
    
    func testGivenGameTypeHumanVersusHuman_WhenNewGame_ThenGameIsHumanVersusHuman() {
        builder.gameType = .HumanVersusHuman
        game = builder.gameWithView(gameView)
        
        XCTAssertEqual(gameView.gameBoard.crosses, 0)
        XCTAssertEqual(gameView.gameStatus, GameStatus.PlayerOneUp)
    
    }
    
}
