//
//  OxfordAPIClientTests.swift
//  OxfordAPIClientTests
//
//  Created by Aleksander Makedonski on 12/1/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

/**
import XCTest

@testable import Scrambled_Messenger

class OxfordAPIClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func getDictionaryEntrURL(){
        
        let url1 = DictionaryAPIClient.getDictionaryEntryURL(forWord: "love", withLexicalCategory: .noun, withGrammaticalFeatures: nil)
        
        let urlString1 = url1.absoluteString
        
        XCTAssertEqual(urlString1, "https://od-api.oxforddictionaries.com/api/v1/entries/en/love/lexicalCategory=noun", "Test failed: failed to construct a valid url object whose url string has  the specified query parameters")
        
        let url2 = DictionaryAPIClient.getDictionaryEntryURL(forWord: "love", withLexicalCategory: nil, withGrammaticalFeatures: [.past,.singular])
        
        let urlString2 = url2.absoluteString
        
        XCTAssertEqual(urlString2, "https://od-api.oxforddictionaries.com/api/v1/entries/en/love/grammaticalFeatures=past,singular", "Test failed: failed to construct a valid url object whose url string has  the specified query parameters")
        
        let url3 = DictionaryAPIClient.getDictionaryEntryURL(forWord: "love", withLexicalCategory: .noun, withGrammaticalFeatures: [.past,.singular])

        let urlString3 = url3.absoluteString
        
        XCTAssertEqual(urlString3, "https://od-api.oxforddictionaries.com/api/v1/entries/en/love/grammaticalFeatures=past,singular;lexicalCategory=noun", "Test failed: failed to construct a valid url object whose url string has  the specified query parameters")

        
    }
    
    
    func testDictionaryEntryURLEndpointWithVariableQueryParameters(){
        
        var urlString1 = DictionaryAPIClient.getURLString(forEndpoint: "entries", hasFinalSlash: false, forLanguage: "en")
        
        var urlString2 = DictionaryAPIClient.getURLString(forEndpoint: "entries", hasFinalSlash: false, forLanguage: "en")
        
        var urlString3 = DictionaryAPIClient.getURLString(forEndpoint: "entries", hasFinalSlash: false, forLanguage: "en")
        
        DictionaryAPIClient.configureURLString(urlString: &urlString1, withLexicalCategory: .noun, andWithGrammaticalFeatures: nil)
        
        XCTAssertEqual(urlString1, "https://od-api.oxforddictionaries.com/api/v1/entries/en/lexicalCategory=noun", "Test failed: failed to build a vaild URL string with query parameter for lexical category specified")
        
        DictionaryAPIClient.configureURLString(urlString: &urlString2, withLexicalCategory: nil, andWithGrammaticalFeatures: [.past,.singular])
        
        XCTAssertEqual(urlString2, "https://od-api.oxforddictionaries.com/api/v1/entries/en/grammaticalFeatures=past,singular", "Test failed: failed to build a vaild URL string with query parameter for grammatical features  specified")

        
        DictionaryAPIClient.configureURLString(urlString: &urlString3, withLexicalCategory: .noun, andWithGrammaticalFeatures: [.past,.singular])
        
        XCTAssertEqual(urlString3, "https://od-api.oxforddictionaries.com/api/v1/entries/en/grammaticalFeatures=past,singular;lexicalCategory=noun", "Test failed: failed to build a vaild URL string with query parameters for lexical category and grammatical features  specified")

    }
    
    func testDictionaryEntryURLEndpointWithLexicalCategoryQueryParameter(){
        
        var urlString = DictionaryAPIClient.getURLString(forEndpoint: "entries", hasFinalSlash: false, forLanguage: "en")
        
        DictionaryAPIClient.configureURLString(urlString: &urlString, withLexicalCategory: .noun)
        
        XCTAssertEqual(urlString, "https://od-api.oxforddictionaries.com/api/v1/entries/en/lexicalCategory=noun", "Test failed: failed to build a valid URL string with query parameter for lexical category specified")

    }
    
    func testDictionaryEntryURLEndpointWithGrammaticalFeaturesQueryParameter(){
        
        var urlString1 = DictionaryAPIClient.getURLString(forEndpoint: "entries", hasFinalSlash: false, forLanguage: "en")
        
        let urlString2 = DictionaryAPIClient.getURLString(forEndpoint: "entries", hasFinalSlash: true, forLanguage: "en")
        
        XCTAssertEqual(urlString1, "https://od-api.oxforddictionaries.com/api/v1/entries/en", "Test failed: failed to build a valid URL string comprising the base URL, endpoint, and language code")
        
        XCTAssertEqual(urlString2, "https://od-api.oxforddictionaries.com/api/v1/entries/en/", "Test failed: failed to build a valid URL string comprising the base URL, endpoint, and language code")

      
        DictionaryAPIClient.configureURLString(urlString: &urlString1, withGrammaticalFeatures: [.past,.singular], hasOtherQueryParameters: false)
        
        
        let targetURLString = "https://od-api.oxforddictionaries.com/api/v1/entries/en/grammaticalFeatures=past,singular"
        
        XCTAssertEqual(urlString1, targetURLString, "Test failed: failed to build a valid URL string comprising the base URL, endpoint, and language code i.e. the constructed url string: \(urlString1) does not equal the target url string: \(targetURLString)")
        
    
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
**/
