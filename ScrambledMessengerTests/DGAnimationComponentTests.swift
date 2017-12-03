//
//  DGAnimationComponentTests.swift
//  DGAnimationComponentTests
//
//  Created by Aleksander Makedonski on 11/28/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

/**
import XCTest
import SpriteKit

@testable import Scrambled_Messenger


struct TextureAtlasConfiguration{
    var numberOfUpTextures: Int
    var numberOfDownTextures: Int
    var numberOfLeftTextures: Int
    var numberOfRightTextures: Int
}

class DGAnimationComponentTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testGuyJumpAtlasLoadsCorrectNumberOfTextures(){
        
        
        let atlasConfiguration = getTextureAtlasConfiguration(forAtlasName: "AGuyAtlas.atlas", andWithImageIdentifier: "Jump", andForAnimationState: .jump)

        
        let numberOfDownTextures = atlasConfiguration.numberOfDownTextures
        let numberOfUpTextures = atlasConfiguration.numberOfUpTextures
        let numberOfRightTextures = atlasConfiguration.numberOfRightTextures
        let numberOfLeftTextures = atlasConfiguration.numberOfLeftTextures

        
        XCTAssertEqual(numberOfLeftTextures, 10, "Test failed: failed to load the correct number of jump left textures")
        
        XCTAssertEqual(numberOfRightTextures, 10, "Test failed: failed to load the correct number of jump right textures")
        
        XCTAssertEqual(numberOfDownTextures, 0, "Test failed: failed to load the correct number of jump down textures")
        
        XCTAssertEqual(numberOfUpTextures, 0, "Test failed: failed to load the correct number of jump up textures")



    }
    
    
    func testGuyClimbAtlasLoadesCorrectNumberOfTextures(){
    
        let atlasConfiguration = getTextureAtlasConfiguration(forAtlasName: "AGuyAtlas.atlas", andWithImageIdentifier: "Climb", andForAnimationState: .climb)
        
        let numberOfDownTextures = atlasConfiguration.numberOfDownTextures
        let numberOfUpTextures = atlasConfiguration.numberOfUpTextures
        let numberOfRightTextures = atlasConfiguration.numberOfRightTextures
        let numberOfLeftTextures = atlasConfiguration.numberOfLeftTextures


        XCTAssertEqual(numberOfDownTextures, 10, "Test Failed: Failed to load all of the climb down textures; total number of climb down textures should be 10, only \(numberOfDownTextures) textures loaded")
        
        XCTAssertEqual(numberOfUpTextures, 10, "Test Failed: Failed to load all of the climb up textures; total number of climb up textures should be 10, only \(numberOfDownTextures) textures loaded")
        
        
        XCTAssertEqual(numberOfRightTextures, 0, "Test failed: textures loaded for the climb animation state, where orientation is specified as right ")
        
        XCTAssertEqual(numberOfLeftTextures, 0, "Test failed: textures loaded for the climb animation state, where orientation is specified as left ")
        
        

    }
    
    
    
    func testGuyClimbAtlasLoadsSameNumberOfUpAndDownTextures(){
        
        
     
           // XCTAssertEqual(numberOfUpTextures, numberOfDownTextures, "Test failed: the number of up textures does not equal the number of down textures")
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    
    
    
     func getTextureAtlasConfiguration(forAtlasName atlasName: String, andWithImageIdentifier identifier: String, andForAnimationState animationState: DGAnimationState) -> TextureAtlasConfiguration{
        
        let animationsDict = getAnimationsDict(forAtlasName: atlasName, andImageIdentifier: identifier, andForAnimationState: animationState)
        
        let downAnimation = animationsDict[DGDirection.Down]!
        let upAnimation = animationsDict[DGDirection.Up]!
        let leftAnimation = animationsDict[DGDirection.Left]!
        let rightAnimation = animationsDict[DGDirection.Right]!
    
        let numberOfDownTextures = downAnimation.textures.count
        let numberOfUpTextures = upAnimation.textures.count
        let numberOfLeftTextures = leftAnimation.textures.count
        let numberOfRightTextures = rightAnimation.textures.count
        
        return TextureAtlasConfiguration(numberOfUpTextures: numberOfUpTextures,numberOfDownTextures: numberOfDownTextures, numberOfLeftTextures: numberOfLeftTextures, numberOfRightTextures: numberOfRightTextures)
    
    }
    
    private func getAnimationsDict(forAtlasName atlasName: String, andImageIdentifier identifier: String, andForAnimationState animationState: DGAnimationState) -> [DGDirection:DGAnimation]{
        
        let atlas = SKTextureAtlas(named: atlasName)
        
        return DGAnimationComponent.animationsFromAtlas(atlas: atlas, withImageIdentifier: identifier, forAnimationState: animationState)
        
    }
    
    
}
**/
