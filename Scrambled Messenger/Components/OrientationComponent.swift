//
//  OrientationComponent.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 11/20/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import GameplayKit

class OrientationComponent: GKComponent{
    // MARK: Properties
    
    var zRotation: CGFloat = 0.0 {
        didSet {
            let twoPi = CGFloat.pi * 2
            zRotation = (zRotation + twoPi).truncatingRemainder(dividingBy: twoPi)
        }
    }
    
    var compassDirection: CompassDirection {
        get {
            return CompassDirection(zRotation: zRotation)
        }
        
        set {
            zRotation = newValue.zRotation
        }
    }
    
}
