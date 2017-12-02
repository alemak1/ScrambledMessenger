//
//  DGDirection.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 11/20/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

enum DGDirection: String{
    case Left,Right,Up,Down,None
    
    static let allDirections: [DGDirection] = [.Left,.Right,.Up,.Down,.None]
}
