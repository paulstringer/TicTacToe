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
        XCTAssertEqual(GameType.allValues[0], GameType.HumanVersusComputer)
        XCTAssertEqual(GameType.allValues[1], GameType.ComputerVersusHuman)
        XCTAssertEqual(GameType.allValues[2], GameType.HumanVersusHuman)
    }
    
    func testGivenInit_WhenGameTypeNotSet_ThenGameTypeEqualsFirstGameType() {
        XCTAssertEqual(factory.gameType, GameType.HumanVersusComputer)
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
