//
//  OxfordAPIRequestTests.swift
//  OxfordAPIClientTests
//
//  Created by Aleksander Makedonski on 12/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//


import XCTest

@testable import Scrambled_Messenger

class OxfordAPIRequestTests: XCTestCase {
    
    /** Most basic api requests **/
    
    var oxfordAPIRequest1: OxfordAPIRequest!
    var oxfordAPIRequest2: OxfordAPIRequest!
    var oxfordAPIRequest3: OxfordAPIRequest!
    
    /** Dictionary Entries requests: example sentences, synonyms, antonyms, both synonyms and antonyms **/
    
    var antonymAPIRequest: OxfordAPIRequest!
    var synonymAPIRequest: OxfordAPIRequest!
    var antonymAndSynonymAPIRequest: OxfordAPIRequest!
    var exampleSentencesAPIRequest: OxfordAPIRequest!


    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        /** Basic API Requests **/
        oxfordAPIRequest1 = OxfordAPIRequest(withEndpoint: .entries, withQueryWord: "love", withFilters: nil)
        
        oxfordAPIRequest2 = OxfordAPIRequest(withEndpoint: .inflections, withQueryWord: "eat", withFilters: nil)
        
        oxfordAPIRequest3 = OxfordAPIRequest(withEndpoint: .wordlist, withQueryWord: "practice", withFilters: nil)
        
        /** Dictionary entry API requests **/
        
        antonymAPIRequest = OxfordAPIRequest(withWord: "love", hasRequestedAntonymsQuery: true, hasRequestedSynonymsQuery: false)
        
        synonymAPIRequest = OxfordAPIRequest(withWord: "love", hasRequestedAntonymsQuery: false, hasRequestedSynonymsQuery: true)
        
        antonymAndSynonymAPIRequest = OxfordAPIRequest(withWord: "love", hasRequestedAntonymsQuery: true, hasRequestedSynonymsQuery: true)
        
        exampleSentencesAPIRequest = OxfordAPIRequest(withWord: "love", hasRequestedExampleSentencesQuery: true)

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        oxfordAPIRequest1 = nil
        
        antonymAPIRequest = nil
        
        synonymAPIRequest = nil
        
        antonymAndSynonymAPIRequest = nil
        
        exampleSentencesAPIRequest = nil
        
        super.tearDown()
    }
    
    func testURLNotNil(){
        
        let urlRequest = oxfordAPIRequest1.generateURLRequest()
        
        let url = urlRequest.url
        
        XCTAssertNotNil(url)
    }
    
    func testAPIRequestHeaderFields() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    
        let urlRequest = oxfordAPIRequest1.generateURLRequest()
        
        let contentType_headerFieldValue = urlRequest.value(forHTTPHeaderField: "Accept")
        let appID_headerFieldValue = urlRequest.value(forHTTPHeaderField: "app_id")
        let appKey_headerFieldValue = urlRequest.value(forHTTPHeaderField: "app_key")

        XCTAssertEqual(contentType_headerFieldValue, "application/json", "Test failed: Header field 'Accept' has incorrect value")
        
         XCTAssertEqual(appID_headerFieldValue,"acb61904", "Test failed: Header field for app_id has incorrect value")
        
         XCTAssertEqual(appKey_headerFieldValue,"383d6f9739d4974fb81168976b6e991b", "Test failed: Header field for app_key has incorrect field")
        
   
        
    }
    
    
    func testAntonymAPIRequestURLString(){
        
        let urlRequest = antonymAPIRequest.generateURLRequest()
        
        let urlString = urlRequest.url!.absoluteString
        
        XCTAssertEqual(urlString, "https://od-api.oxforddictionaries.com/api/v1/entries/en/love/antonyms", "Test failed: th url associated with the url request is incorrect")
    }
    
    func testSynonymAPIRequestURLString(){
        
        let urlRequest = synonymAPIRequest.generateURLRequest()
        
        let urlString = urlRequest.url!.absoluteString
        
        XCTAssertEqual(urlString, "https://od-api.oxforddictionaries.com/api/v1/entries/en/love/synonyms", "Test failed: th url associated with the url request is incorrect")

    }
    
    func testSynonymAndAntonymAPIRequestURLString(){
        
        let urlRequest = antonymAndSynonymAPIRequest.generateURLRequest()
        
        let urlString = urlRequest.url!.absoluteString
        
        XCTAssertEqual(urlString, "https://od-api.oxforddictionaries.com/api/v1/entries/en/love/synonyms;antonyms", "Test failed: th url associated with the url request is incorrect")

    }
    
    func testExampleSentencesAPIRequestURLString(){
        
        let urlRequest = exampleSentencesAPIRequest.generateURLRequest()
        
        let urlString = urlRequest.url!.absoluteString
        
        XCTAssertEqual(urlString, "https://od-api.oxforddictionaries.com/api/v1/entries/en/love/sentences", "Test failed: th url associated with the url request is incorrect")

    }
    
    func testAPIRequestURLString(){
        
        let urlRequest = oxfordAPIRequest1.generateURLRequest()
        
        let urlString = urlRequest.url!.absoluteString
        
        XCTAssertEqual(urlString, "https://od-api.oxforddictionaries.com/api/v1/entries/en/love", "Test failed: th url associated with the url request is incorrect")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
 
 
