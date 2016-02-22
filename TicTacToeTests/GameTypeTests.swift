import XCTest
@testable import TicTacToe

class GameTypeTests: XCTestCase {
    
    let view = GameViewSpy()
    var game: TicTacToe!
    
    override func setUp() {
        super.setUp()
        game = TicTacToe(view: view)
    }

    //MARK:- Computer V Computer Tests
    
    func testGivenGame_WhenReady_ThenViewsGameTypesNotEmpty() {
        game.ready()
        XCTAssertFalse(view.gameTypes.isEmpty)
    }
    
    func testGivenGame_WhenReady_ThenViewsGameTypesContainsHumanVersusComputer() {
        game.ready()
        XCTAssertTrue(view.gameTypes.contains(.HumanVersusComputer))
    }
    
    // TODO: Game Mode should allow human v. computer
    // TODO: Game Mode should allow human v. human
    
    
}
