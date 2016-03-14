import XCTest
@testable import TicTacToe

class GameFactoryTests: XCTestCase {

    let gameView = GameViewSpy()
    var game: Game!
    var factory: GameFactory!
    
    override func setUp() {
        super.setUp()
        factory = GameFactory()
    }
    
    func testGivenView_WhenInitialised_ThenViewsGameTypesContainsAllGamesTypes() {
        
        XCTAssertTrue(GameFactory.GameTypes.contains(.ComputerVersusHuman))
        XCTAssertTrue(GameFactory.GameTypes.contains(.HumanVersusHuman))
        XCTAssertTrue(GameFactory.GameTypes.contains(.HumanVersusComputer))
    }
    
    func testGivenGameTypeComputerVersusHuman_WhenNewGame_ThenGameIsComputerVersusHuman() {
        factory.gameType = .ComputerVersusHuman
        game = factory.gameWithView(gameView)
        
        XCTAssertEqual(gameView.gameBoard.crosses, 1)
        XCTAssertEqual(gameView.gameStatus, GameStatus.PlayerOneUp)
    }
    
    func testGivenGameTypeHumanVersusHuman_WhenNewGame_ThenGameIsHumanVersusHuman() {
        factory.gameType = .HumanVersusHuman
        game = factory.gameWithView(gameView)
        
        XCTAssertEqual(gameView.gameBoard.crosses, 0)
        XCTAssertEqual(gameView.gameStatus, GameStatus.PlayerOneUp)
    
    }
    
}
