//
//  GameRules.swift
//  AcceptanceTests
//
//  Created by Paul Stringer on 26/09/2017.
//  Copyright © 2017 stringerstheory. All rights reserved.
//

import Foundation

@objc(GameRules)

class GameRules: NSObject, SlimDecisionTable {
    
    let gameContext = GameContext(gameType: GameType.humanVersusHuman)
    
    var turns: String?
    
    var gameMessage: String {
        switch gameContext.gameStatus! {
        case .playerOneUp:
            return "Player One Up"
        case .playerTwoUp:
            return "Player Two Up"
        case .playerOneWins:
            return "Player One Wins"
        case .playerTwoWins:
            return "Player Two Wins"
        case .stalemate:
            return "Stalemate"
        default:
            return "UNDEFINED"
        }
    }
    
    func execute() {
        guard let turns = turns else { return }
        gameContext.play(turns: turns)
    }
}
