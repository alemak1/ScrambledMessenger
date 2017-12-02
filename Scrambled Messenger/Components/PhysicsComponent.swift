//
//  PhysicsComponent.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 11/20/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import GameplayKit

class PhysicsComponent: GKComponent{
    
    var physicsBody: SKPhysicsBody
    
    init(physicsBody: SKPhysicsBody, colliderType: ColliderType){
        self.physicsBody = physicsBody
        
        self.physicsBody.categoryBitMask = colliderType.categoryMask
        self.physicsBody.collisionBitMask = colliderType.collisionMask
        self.physicsBody.contactTestBitMask = colliderType.contactMask
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
