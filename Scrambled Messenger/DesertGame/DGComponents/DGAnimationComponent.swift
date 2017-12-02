//
//  DGAnimationComponent.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 11/20/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


/** The player movement states include idling, walking, running, and crouching; movement states can be alternated via swipe - swiping up will either cause the player to jump or climb up, whereas swiping down will cause the player to either crouch or climb down **/

/** The player can attack by shooting, throwing bombs/grenades, or by swiping with a knife (i.e. melee); attack states are initiated via tap gestures; an extra on-screen button will be used to toggle between grenade, knife, and shooting attack modes **/


enum DGAnimationState: String{
    case climb = "Climb"
    case crouch = "Crouch"
    case crouchAim = "Crouch_Aim"
    case crouchMelee = "Crouch_Melee"
    case crouchThrow = "Crouch_Throw"
    case crouchShoot = "Crouch_Shoot"
    case melee = "Melee"
    case jump = "Jump"
    case jumpShoot = "Jump_Shoot"
    case jumpThrow = "Jump_Throw"
    case jumpMelee = "Jump_Melee"
    case run = "Run"
    case runShoot = "Run_Shoot"
    case shoot = "Shoot"
    case throaw = "Throw"
    case walk = "Walk"
    case walkShoot = "Walk_Shoot"
    case idle = "Idle"
    case idleAim = "Idle_Aim"
    case dead = "Dead"
    case happy = "Happy"
    case hurt = "Hurt"
    case attack = "Attack"
    case sting = "Sting"
    
    static let AllGuyAnimationStates: [DGAnimationState] = [
        .climb,.crouch, .happy,.hurt,.idle,.jumpThrow,.jumpMelee,.jumpShoot,.melee,
        .run,.runShoot,.shoot,.walk,.walkShoot,.throaw
    ]
    
    
    func getGuyTextureAtlasName() -> String{
        
        switch self{
            case .climb:
                return "GuyClimb.atlas"
            case .jumpShoot:
                return "GuyJumpShoot.atlas"
            case .jump:
                return "GuyJump.atlas"
            case .jumpMelee:
                return "GuyJumpMelee.atlas"
            case .jumpThrow:
                return "GuyJumpThrow.atlas"
            default:
                return "GuyJumpShoot.atlas"
        }
    }
    /**
     
    /** The actions below have right-facing counterparts **/
    
    
    case meleeRight = "meleeRight"
    
    case jumpRight = "jumpRight"
    case jumpMeleeRight = "jumpMeleeRight"
    case jumpShootRight = "jumpShootRight"
    case jumpThrowRight = "jumpThrowRight"
    
    case runRight = "runRight"
    case runShootRight = "runShootRight"
    
    case shootRight = "shootRight"
    
    case throwRight = "throwRight"
    
    case walkRight = "walkRight"
    case walkShootRight = "walkShootRight"
    
    case idleRight = "idleRight"
    case idleAimRight = "idleAimRight"
    
    case crouchRight = "CrouchRight"
    case crouchAimRight = "CrouchAimRight"
    case crouchMeleeRight = "CrouchMeleeRight"
    case crouchThrowRight = "CrouchThrowRight"
    case crouchShootRight = "CrouchShootRight"
    
    case deadRight = "DeadRight"
    case happyRight = "HappyRight"
    case hurtRight = "HurtRight"
    
    /** The actions below have left-facing counterparts **/
    
    case meleeLeft = "meleeLeft"
    
    case jumpLeft = "jumpLeft"
    case jumpMeleeLeft = "jumpMeleeLeft"
    case jumpShootLeft = "jumpShootLeft"
    case jumpThrowLeft = "jumpThrowLeft"
    
    case runLeft = "runLeft"
    case runShootLeft = "runShootLeft"
    
    case shootLeft = "shootLeft"
    
    case throwLeft = "throwLeft"
    
    case walkLeft = "walkLeft"
    case walkShootLeft = "walkShootLeft"
    
    case idleLeft = "idleLeft"
    case idleAimLeft = "idleAimLeft"
    
    case crouchLeft = "CrouchLeft"
    case crouchAimLeft = "CrouchAimLeft"
    case crouchMeleeLeft = "CrouchMeleeLeft"
    case crouchThrowLeft = "CrouchThrowLeft"
    case crouchShootLeft = "CrouchShootLeft"
    
    case deadLeft = "DeadLeft"
    case happyLeft = "HappyLeft"
    case hurtLeft = "HurtLeft"
    
    /** In addition to walk, idle, and dead states, the beetle and scorpion have attack and sting states, while the mummy only has an attack state **/
    
    case attackRight = "AttackRight"
    case stingRight = "StingRight"
    
    case attackLeft = "AttackLeft"
    case stingLeft = "StingLeft"
    
    **/
}


/** The DGAnimation struct is a wrapper struct that contains configuration data for configuring an animation; Configuration parameters include:
 
     animationState -   the animation state for the animation
     direction  -   the direction the character is facing, since animation states are mutually exclusive
                         with respect to direction
     textures   -   the textures required to run the action, whether it be an action that runs on a
                         loop, or an action that runs one time
     frameOffset
 
     frameOffsetTextures
 
     bodyActionName
     bodyAction
 
     The AnimationComponent will then contain a dictionary in which animation states are mapped to nested dictionaries which contain the animations correspeonding to specific directions
 
 
 **/
struct DGAnimation{
    
    let animationState: DGAnimationState
    
    let direction: DGDirection
    
    let textures: [SKTexture]
    
    var offsetTextures: [SKTexture]{
        if frameOffset == 0{
            return textures
        }
        
        let offsetToEnd = Array(textures[frameOffset..<textures.count])
        let startToBeforeOffset = Array(textures[0..<frameOffset])
        
        return offsetToEnd + startToBeforeOffset
    }
    
    let repeatTexturesForever: Bool
    
    let bodyActionName: String?
    let bodyAction: SKAction?
    
    var frameOffset = 0
    
    
}

class DGAnimationComponent: GKComponent{
    
    static let bodyActionKey = "bodyAction"
    static let textureActionKey = "textureAction"
    static let timePerFrame = TimeInterval(1.0/10.0)
    
    
    var requestedAnimationState: DGAnimationState?
    let node: SKSpriteNode
    var animations: [DGAnimationState: [DGDirection:DGAnimation]]
    private(set) var currentAnimation: DGAnimation?
    private var elapsedAnimationDuration: TimeInterval = 0.0
    
    init(textureSize: CGSize, animations: [DGAnimationState:[DGDirection:DGAnimation]]){
        node = SKSpriteNode(texture: nil, size: textureSize)
        self.animations = animations
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func runAnimationForAnimationState(animationState: DGAnimationState, direction: DGDirection, deltaTime: TimeInterval) {
        
        // Update the tracking of how long we have been animating.
        elapsedAnimationDuration += deltaTime
        
        // Check if we are already running this animation. There's no need to do anything if so.
        if currentAnimation != nil && currentAnimation!.animationState == animationState && currentAnimation!.direction == direction { return }
        
        /*
         Retrieve a copy of the stored animation for the requested state and compass direction.
         `Animation` is a structure - i.e. a value type - so the `animation` variable below
         will contain a unique copy of the animation's data.
         We request this copy as a variable (rather than a constant) so that the
         `animation` variable's `frameOffset` property can be modified later in this method
         if we choose to offset the animation's start point from zero.
         */
        guard let unwrappedAnimation = animations[animationState]?[direction] else {
            print("Unknown animation for state \(animationState.rawValue), compass direction \(direction.rawValue).")
            return
        }
        var animation = unwrappedAnimation
        
        // Check if the action for the body node has changed.
        if currentAnimation?.bodyActionName != animation.bodyActionName {
            // Remove the existing body action if it exists.
            node.removeAction(forKey: DGAnimationComponent.bodyActionKey)
            
            // Reset the node's position in its parent (it may have been animating with a move action).
            node.position = CGPoint.zero
            
            // Add the new body action to the node if an action exists.
            if let bodyAction = animation.bodyAction {
                node.run(SKAction.repeatForever(bodyAction), withKey: DGAnimationComponent.bodyActionKey)
            }
        }
        
       
        
        // Remove the existing texture animation action if it exists.
        node.removeAction(forKey: DGAnimationComponent.textureActionKey)
        
        // Create a new action to display the appropriate animation textures.
        let texturesAction: SKAction
        
        if animation.textures.count == 1 {
            // If the new animation only has a single frame, create a simple "set texture" action.
            texturesAction = SKAction.setTexture(animation.textures.first!)
        }
        else {
            
            if currentAnimation != nil && animationState == currentAnimation!.animationState {
                /*
                 We have just changed facing direction within the same animation state.
                 To make the animation feel smooth as we change direction,
                 begin the animation for the new direction on the frame after
                 the last frame displayed for the old direction.
                 This prevents (e.g.) a walk cycle from resetting to its start
                 every time a character turns to the left or right.
                 */
                
                // Work out how many frames of this animation have played since the animation began.
                let numberOfFramesInCurrentAnimation = currentAnimation!.textures.count
                let numberOfFramesPlayedSinceCurrentAnimationBegan = Int(elapsedAnimationDuration / DGAnimationComponent.timePerFrame)
                
                /*
                 Work out how far into the animation loop the next frame would be.
                 This takes into account the fact that the current animation may have been
                 started from a non-zero offset.
                 */
                animation.frameOffset = (currentAnimation!.frameOffset + numberOfFramesPlayedSinceCurrentAnimationBegan + 1) % numberOfFramesInCurrentAnimation
            }
            
            // Create an appropriate action from the (possibly offset) animation frames.
            if animation.repeatTexturesForever {
                texturesAction = SKAction.repeatForever(SKAction.animate(with: animation.offsetTextures, timePerFrame: DGAnimationComponent.timePerFrame))
            }
            else {
                texturesAction = SKAction.animate(with: animation.offsetTextures, timePerFrame: DGAnimationComponent.timePerFrame)
            }
        }
        
        // Add the textures animation to the body node.
        node.run(texturesAction, withKey: DGAnimationComponent.textureActionKey)
        
        // Remember the animation we are currently running.
        currentAnimation = animation
        
        // Reset the "how long we have been animating" counter.
        elapsedAnimationDuration = 0.0
    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        
        super.update(deltaTime: seconds)
        
        if let animationState = self.requestedAnimationState{
            guard let orientationComponent = entity?.component(ofType: DGOrientationComponent.self) else {
                fatalError("An animation component's entity must have an orientation component")
                return
            }
            
            runAnimationForAnimationState(animationState: animationState, direction: orientationComponent.direction, deltaTime: seconds)
            
        }
       
        
    }
    
    
    /// Returns the first texture in an atlas for a given `Direction`.
    
    /***
     Prefixes include:
         Walk (WalkLeft)
         Walk (
     ***/
    class func firstTextureForOrientation(direction: DGDirection, inAtlas atlas: SKTextureAtlas, withImageIdentifier identifier: String) -> SKTexture {
        // Filter for this facing direction, and sort the resulting texture names alphabetically.
        let textureNames = atlas.textureNames.filter {
            
            
                $0.hasPrefix("\(identifier)\(direction.rawValue)_")
            
            
            }.sorted()
        

        // Find and return the first texture for this direction.
        return atlas.textureNamed(textureNames.first!)
    }
    
    /// Returns the first texture in an atlas for a given `CompassDirection`.
    class func firstTextureForOrientation(compassDirection: CompassDirection, inAtlas atlas: SKTextureAtlas, withImageIdentifier identifier: String) -> SKTexture {
        // Filter for this facing direction, and sort the resulting texture names alphabetically.
        let textureNames = atlas.textureNames.filter {
            $0.hasPrefix("\(identifier)_\(compassDirection.rawValue)_")
            }.sorted()
        
        // Find and return the first texture for this direction.
        return atlas.textureNamed(textureNames.first!)
    }
    
    /// Creates an `Animation` from textures in an atlas and actions loaded from file.
    class func animationsFromAtlas(atlas: SKTextureAtlas, withImageIdentifier identifier: String, forAnimationState animationState: DGAnimationState, bodyActionName: String? = nil, repeatTexturesForever: Bool = true, playBackwards: Bool = false) -> [DGDirection: DGAnimation] {
        
        // Load a body action from an actions file if requested.
        let bodyAction: SKAction?
        if let name = bodyActionName {
            bodyAction = SKAction(named: name)
        }
        else {
            bodyAction = nil
        }
        
    
        
        /// A dictionary of animations with an entry for each compass direction.
        var animations = [DGDirection: DGAnimation]()
        
        for direction in DGDirection.allDirections {
            
            // Find all matching texture names, sorted alphabetically, and map them to an array of actual textures.
            let textures = atlas.textureNames.filter {
                $0.hasPrefix("\(identifier)\(direction.rawValue)_")
                }.sorted {
                    playBackwards ? $0 > $1 : $0 < $1
                }.map {
                    atlas.textureNamed($0)
            }
            
            // Create a new `Animation` for these settings.
            animations[direction] = DGAnimation(animationState: animationState,
                                                direction: direction,
                                                textures: textures,
                                                repeatTexturesForever: repeatTexturesForever,
                                                bodyActionName: bodyActionName,
                                                bodyAction: bodyAction,
                                                frameOffset: 0)
            
            
        }
        
        return animations
    }
    
    

}

