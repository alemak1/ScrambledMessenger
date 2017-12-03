//
//  LinguisticTaggerTests.swift
//  DGAnimationComponentTests
//
//  Created by Aleksander Makedonski on 11/29/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

/**
import XCTest

@testable import Scrambled_Messenger

class LinguisticTaggerTests: XCTestCase {
    
    var rawText: String?
    var lexicalClassConfiguration: LexicalClassConfiguration?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
        /** Load the plist with sampe test data  **/
        
        let path = Bundle.main.path(forResource: "TaggerTestData", ofType: "plist")!
        let url = URL(fileURLWithPath: path)
        let testCases = NSArray(contentsOf: url)!
        
        /** Dictionary for the first test case **/
        
        let testCase = testCases.firstObject as! [String: Any]
        
        let dictionary = testCase["LexicalConfiguration"] as! Dictionary<String,Any>
        
        let lexConfiguration = LexicalClassConfiguration(dict: dictionary)
        
        self.lexicalClassConfiguration = lexConfiguration
        self.rawText = testCase["Text"] as! String
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        rawText = nil
        lexicalClassConfiguration = nil
        
        super.tearDown()
    }
    
    func testNumberOfLexicalClassTags(){
        
        
        let lexConfig = LinguisticTaggerHelper.getLexicalClassConfiguration(forText: self.rawText!)
        
        let totalNouns = lexConfig.totalNouns
        let totalVerbs = lexConfig.totalVerbs
        let totalAdjectives = lexConfig.totalAdjectives
        let totalAdverbs = lexConfig.totalAdverbs
        let totalDeterminers = lexConfig.totalDeterminers
        let totalConjunctions = lexConfig.totalConjunctions
        
        let targetNouns = self.lexicalClassConfiguration!.totalNouns
        let targetVerbs = self.lexicalClassConfiguration!.totalVerbs
        let targetAdjectives = self.lexicalClassConfiguration!.totalAdjectives
        let targetAdverbs = self.lexicalClassConfiguration!.totalAdverbs
        let targetDeterminers = self.lexicalClassConfiguration!.totalDeterminers
        let targetConjunctions = self.lexicalClassConfiguration!.totalConjunctions
        
        XCTAssertEqual(totalNouns, targetNouns, "Test failed: number of total nouns counted incorrectly")
        XCTAssertEqual(totalVerbs, targetVerbs, "Test failed: number of total verbs counted incorrectly")
        XCTAssertEqual(totalAdjectives, targetAdjectives, "Test failed: number of total adjectives counted incorrectly")
        XCTAssertEqual(totalAdverbs, targetAdverbs, "Test failed: number of total adverbs counted incorrectly")
        XCTAssertEqual(totalDeterminers, targetDeterminers, "Test failed: number of total determiners counted incorrectly")
        XCTAssertEqual(totalConjunctions, targetConjunctions, "Test failed: number of total conjunctions counted incorrectly")



        
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
**/
