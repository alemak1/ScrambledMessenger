//
//  DGIntelligenceComponent.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 11/22/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class DGIntelligenceCompoonent: GKComponent{
    
    let stateMachine: GKStateMachine
    
    let initialStateClass: AnyClass
    
    init(states: [GKState]){
        stateMachine = GKStateMachine(states:states)
        let initialState = states.first!
        initialStateClass = type(of: initialState)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func enterInitialState(){
        self.stateMachine.enter(initialStateClass)
    }
}
