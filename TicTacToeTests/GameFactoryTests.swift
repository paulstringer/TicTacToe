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
    
    func testGivenGameTypes_AllValues_ThenGameTypesContainsAllGamesTypes() {
        XCTAssertEqual(GameType.allValues[0], GameType.humanVersusComputer)
        XCTAssertEqual(GameType.allValues[1], GameType.computerVersusHuman)
        XCTAssertEqual(GameType.allValues[2], GameType.humanVersusHuman)
    }
    
    func testGivenInit_WhenGameTypeNotSet_ThenGameTypeEqualsFirstGameType() {
        XCTAssertEqual(factory.gameType, GameType.humanVersusComputer)
    }
    
    func testGivenGameTypeComputerVersusHuman_WhenNewGame_ThenGameIsComputerVersusHuman() {
        factory.gameType = .computerVersusHuman
        game = factory.gameWithView(gameView)
        
        XCTAssertEqual(gameView.gameBoard.crosses, 1)
        XCTAssertEqual(gameView.gameStatus, GameStatus.playerOneUp)
    }
    
    func testGivenGameTypeHumanVersusHuman_WhenNewGame_ThenGameIsHumanVersusHuman() {
        factory.gameType = .humanVersusHuman
        game = factory.gameWithView(gameView)
        
        XCTAssertEqual(gameView.gameBoard.crosses, 0)
        XCTAssertEqual(gameView.gameStatus, GameStatus.playerOneUp)
    
    }
    
    
}
