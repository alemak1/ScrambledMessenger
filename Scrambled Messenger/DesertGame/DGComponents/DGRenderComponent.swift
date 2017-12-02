//
//  DGRenderComponent.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 11/22/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//


import Foundation
import SpriteKit
import GameplayKit

/** The render component is a wrapper for a node that is used to present the object in the scene **/

class DGRenderComponent: GKComponent{
    
    let node = SKNode()
    
    override func didAddToEntity() {
        self.node.entity = self.entity
    }
    
    override func willRemoveFromEntity() {
        self.node.entity = nil
    }
}
