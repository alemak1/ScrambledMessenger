//
//  DGHumanDeadState.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 11/22/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import SpriteKit
import GameplayKit

class DGHumanDeadState: GKState {
    // MARK: Properties
    
    unowned var entity: DGHumanCharacter
    
    
    // MARK: Initializers
    
    required init(entity: DGHumanCharacter) {
        self.entity = entity
    }
    
    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        default:
            return false
        }
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        
    }
}
