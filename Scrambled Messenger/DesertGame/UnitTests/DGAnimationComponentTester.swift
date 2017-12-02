//
//  DGAnimationComponentTester.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 11/27/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class DGAnimationComponentTester{
    
     static func showDebugInformationForAllGuyTextureAtlases1(){
        DGAnimationState.AllGuyAnimationStates.forEach({
            showTextureAtlasDebugInformationForAtlas(
                withName: $0.getGuyTextureAtlasName(),
                imageIdentifier: $0.rawValue,
                forAnimationState: $0)
        })
        
    }
    
    static func showDebugInformationForAllGuyTextureAtlases2(){
        
        DGAnimationState.AllGuyAnimationStates.forEach({
            
            showTextureAtlasDebugInformationForAtlas(withName: "AGuyAtlas.atlas", imageIdentifier: $0.rawValue, forAnimationState: $0)
        })
    
    }
    
    
    private static func showTextureAtlasDebugInformationForAtlas(withName atlasName: String, imageIdentifier: String, forAnimationState animationState: DGAnimationState){
        
        let atlas = SKTextureAtlas(named: atlasName)
        
        let animationsDict = DGAnimationComponent.animationsFromAtlas(atlas: atlas, withImageIdentifier: imageIdentifier, forAnimationState: animationState)
        
        print("Getting information for the animation state: \(animationState.rawValue.uppercased())")
        
        for direction in animationsDict.keys{
            
            if let storedAnimation = animationsDict[direction] as? DGAnimation, storedAnimation.textures.count > 0{
                
                print("For the direction: \(direction.rawValue), there are \(storedAnimation.textures.count) number of animations")
                
            }
            
        
            
        }
        
        
    }
    
}
