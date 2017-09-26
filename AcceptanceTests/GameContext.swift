//
//  GameContext.swift
//  AcceptanceTests
//
//  Created by Paul Stringer on 26/09/2017.
//  Copyright © 2017 stringerstheory. All rights reserved.
//

import Foundation

class GameContext: GameView {

    private let gameFactory: GameFactory
    private var game: Game?
    var gameStatus: GameStatus!
    var gameBoard: GameBoard!

    init(gameType: GameType) {
        
        self.gameFactory = GameFactory(gameType: gameType)
        
    }

    func play(turns: String) {
        
        game = gameFactory.gameWithView(self)
        
        let positions = mapTurnsToPositions(turns)
        
        positions.forEach { (value) in
            game?.takeTurnAtPosition(value)
        }
        
    }

    //MARK:- Private

    private func mapTurnsToPositions(_ turns: String) -> [Int] {
        
        guard turns.isEmpty == false else {
            return []
        }
        
        return turns.components(separatedBy: ",").map { (turn) -> Int in
            return Int(turn)!
        }
    }

}
