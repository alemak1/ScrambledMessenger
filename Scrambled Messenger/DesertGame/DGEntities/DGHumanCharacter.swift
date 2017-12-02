//
//  HumanCharacter.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 11/22/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class DGHumanCharacter: GKEntity{
    
    
    
    /// The animations to use for a `HumanCharacter`.
    static var animations: [DGAnimationState: [DGDirection: DGAnimation]]?
    
    /// The agent used to pathfind to the the human character
    let agent: GKAgent2D
    
    override init() {
        
        agent = GKAgent2D()
        agent.radius = DGGameplayConfiguration.HumanCharacter.agentRadius
        
        super.init()
        
        let renderComponent = DGRenderComponent()
        addComponent(renderComponent)
        
        let orientationComponent = DGOrientationComponent()
        addComponent(orientationComponent)
        
        let pbTexture = DGGameplayConfiguration.HumanCharacter.pbTexture
        let pbSize = DGGameplayConfiguration.HumanCharacter.pbSize
        let physicsBody = SKPhysicsBody(texture: pbTexture, size: pbSize)
        let physicsComponent = DGPhysicsComponent(physicsBody: physicsBody, colliderType: .HumanCharacter)
        addComponent(physicsComponent)
        
        renderComponent.node.physicsBody = physicsBody
        
        
        guard let animations = DGHumanCharacter.animations else {
            
            fatalError("Attempt to access human character animations before they have been loaded")
            
        }
        
        let animationsComponent = DGAnimationComponent(textureSize: DGGameplayConfiguration.HumanCharacter.textureSize, animations: animations)

        addComponent(animationsComponent)
        
        renderComponent.node.addChild(animationsComponent.node)
        
        let intelligenceComponent = DGIntelligenceCompoonent(states: [
            DGHumanWinState(entity: self),
            DGHumanDeadState(entity: self),
            DGHumanHurtState(entity: self)
            ])
        
        addComponent(intelligenceComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
