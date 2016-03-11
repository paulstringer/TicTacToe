import XCTest
@testable import TicTacToe

class GameChooserTests: XCTestCase {
    
    let view = GameChooserViewSpy()
    var gameChooser: GameChooser!
    
    override func setUp() {
        super.setUp()
        gameChooser = GameChooser(view: view)
    }
    
    func testGivenView_WhenInitialised_ThenViewsGameTypesContainsAllGamesTypes() {
        XCTAssertTrue(view.gameTypes.contains(.ComputerVersusHuman))
        XCTAssertTrue(view.gameTypes.contains(.HumanVersusHuman))
        XCTAssertTrue(view.gameTypes.contains(.HumanVersusComputer))
    }
    
}
