//
//  DGColliderType.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 11/22/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//


import Foundation
import SpriteKit
import GameplayKit

struct DGColliderType: OptionSet, Hashable, CustomDebugStringConvertible {
    // MARK: Static properties
    
    /// A dictionary to specify which `ColliderType`s should be notified of contacts with other `ColliderType`s.
    static var requestedContactNotifications = [DGColliderType: [DGColliderType]]()
    
    /// A dictionary of which `ColliderType`s should collide with other `ColliderType`s.
    static var definedCollisions = [DGColliderType: [DGColliderType]]()
    
    // MARK: Properties
    
    let rawValue: UInt32
    
    // MARK: Options
    
    static var Obstacle: DGColliderType  { return self.init(rawValue: 1 << 0) }
    static var HumanCharacter: DGColliderType { return self.init(rawValue: 1 << 1) }
    static var Enemy: DGColliderType   { return self.init(rawValue: 1 << 2) }
    
    // MARK: Hashable
    
    var hashValue: Int {
        return Int(rawValue)
    }
    
    // MARK: CustomDebugStringConvertible
    
    var debugDescription: String {
        switch self.rawValue {
        case DGColliderType.Obstacle.rawValue:
            return "ColliderType.Obstacle"
            
        case DGColliderType.HumanCharacter.rawValue:
            return "ColliderType.HumanCharacter"
            
        case DGColliderType.Enemy.rawValue:
            return "ColliderType.Enemy"
            
        default:
            return "UnknownColliderType(\(self.rawValue))"
        }
    }
    
    // MARK: SpriteKit Physics Convenience
    
    /// A value that can be assigned to a 'SKPhysicsBody`'s `categoryMask` property.
    var categoryMask: UInt32 {
        return rawValue
    }
    
    /// A value that can be assigned to a 'SKPhysicsBody`'s `collisionMask` property.
    var collisionMask: UInt32 {
        // Combine all of the collision requests for this type using a bitwise or.
        let mask = DGColliderType.definedCollisions[self]?.reduce(DGColliderType()) { initial, colliderType in
            return initial.union(colliderType)
        }
        
        // Provide the rawValue of the resulting mask or 0 (so the object doesn't collide with anything).
        return mask?.rawValue ?? 0
    }
    
    /// A value that can be assigned to a 'SKPhysicsBody`'s `contactMask` property.
    var contactMask: UInt32 {
        // Combine all of the contact requests for this type using a bitwise or.
        let mask = DGColliderType.requestedContactNotifications[self]?.reduce(DGColliderType()) { initial, colliderType in
            return initial.union(colliderType)
        }
        
        // Provide the rawValue of the resulting mask or 0 (so the object doesn't need contact callbacks).
        return mask?.rawValue ?? 0
    }
    
    // MARK: ContactNotifiableType Convenience
    
    /**
     Returns `true` if the `ContactNotifiableType` associated with this `ColliderType` should be
     notified of contact with the passed `ColliderType`.
     */
    func notifyOnContactWith(_ colliderType: DGColliderType) -> Bool {
        if let requestedContacts = DGColliderType.requestedContactNotifications[self] {
            return requestedContacts.contains(colliderType)
        }
        
        return false
    }
}
