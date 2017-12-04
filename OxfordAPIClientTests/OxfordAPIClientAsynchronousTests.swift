//
//  OxfordAPIClientAsynchronousTests.swift
//  OxfordAPIClientTests
//
//  Created by Aleksander Makedonski on 12/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import XCTest

@testable import Scrambled_Messenger

/** Each test should be run individually **/

class OxfordAPIClientAsynchronousTests: XCTestCase, OxfordDictionaryAPIDelegate {
    
    typealias JSONResponse = [String: Any]

    var promise: XCTestExpectation!

    var sharedClient: OxfordAPIClient{
        return OxfordAPIClient.sharedClient
    }
    
    override func setUp() {
        
        sharedClient.setOxfordDictionaryAPIClientDelegate(with: self)
        
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        sharedClient.resetDefaultDelegate()
        
        promise = nil
        
        super.tearDown()
    }
    
    func testWordListAPIRequesWithValidationt(){
        
        promise = expectation(description: "Promise fulfilled: JSON data for example sentences API request received and serialized successfully, http status code: 200")
        
        sharedClient.setOxfordDictionaryAPIClientDelegate(with: self)
        
        
        
        sharedClient.downloadWordlistJSONDataWithValidation(forFilters: [
            OxfordAPIEndpoint.OxfordAPIFilter.registers([
                OxfordLanguageRegisters.archaic.rawValue
                ])
            ])
        
        waitForExpectations(timeout: 20.00, handler: nil)
        
    }
    
    func testWordListWithRegisterAndRegionFiltersAPIRequest(){
        
        
        promise = expectation(description: "Promise fulfilled: JSON data for example sentences API request received and serialized successfully, http status code: 200")
        
        sharedClient.setOxfordDictionaryAPIClientDelegate(with: self)
        
        
        
        sharedClient.downloadWordListJSONData(
            forDomainFilters: [],
            forRegionFilters: [OxfordAPIEndpoint.OxfordAPIFilter.regions([OxfordRegion.us.rawValue])],
            forRegisterFilters: [OxfordAPIEndpoint.OxfordAPIFilter.registers([OxfordLanguageRegisters.dialect.rawValue])],
            forTranslationFilters: [],
            forLexicalCategoryFilters: [])
        
        waitForExpectations(timeout: 20.00, handler: nil)
        
    }
    
    
    
    func testWordListWithRegisterFiltersAPIRequest(){
        
        
        promise = expectation(description: "Promise fulfilled: JSON data for example sentences API request received and serialized successfully, http status code: 200")
        
        sharedClient.setOxfordDictionaryAPIClientDelegate(with: self)
        
        
        
        sharedClient.downloadWordListJSONData(
            forDomainFilters: [],
            forRegionFilters: [],
            forRegisterFilters: [OxfordAPIEndpoint.OxfordAPIFilter.registers([OxfordLanguageRegisters.army_slang.rawValue])],
            forTranslationFilters: [],
            forLexicalCategoryFilters: [])
        
        waitForExpectations(timeout: 20.00, handler: nil)
        
    }
    
    func testWordListWithDomainFiltersAPIRequest(){
        
        
        promise = expectation(description: "Promise fulfilled: JSON data for example sentences API request received and serialized successfully, http status code: 200")
        
        sharedClient.setOxfordDictionaryAPIClientDelegate(with: self)
        
    
        
        sharedClient.downloadWordListJSONData(
            forDomainFilters: [OxfordAPIEndpoint.OxfordAPIFilter.domains([OxfordDomains.anatomy.rawValue])],   forRegionFilters: [],
            forRegisterFilters: [],
          forTranslationFilters: [],
          forLexicalCategoryFilters: [])
        
        waitForExpectations(timeout: 20.00, handler: nil)

    }
    
    func testDictionaryEntryWithRegionFiltersAPIRequest() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        promise = expectation(description: "Promise fulfilled: JSON data for example sentences API request received and serialized successfully, http status code: 200")
        
        sharedClient.setOxfordDictionaryAPIClientDelegate(with: self)
       
        sharedClient.downloadDictionaryEntryJSONData(forWord: "love", withFilters: [OxfordAPIEndpoint.OxfordAPIFilter.regions([OxfordRegion.us.rawValue])])
        
        waitForExpectations(timeout: 20.00, handler: nil)
        
        
    }
    
    
    func testExampleSentencesAPIRequest() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        

        promise = expectation(description: "Promise fulfilled: JSON data for example sentences API request received and serialized successfully, http status code: 200")

        sharedClient.setOxfordDictionaryAPIClientDelegate(with: self)

        sharedClient.downloadExampleSentencesJSONData(forWord: "love")
        
        waitForExpectations(timeout: 20.00, handler: nil)

        

        
    }
    
    func testAntonymsAndSynonymsAPIRequest() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        promise = expectation(description: "Promise fulfilled: JSON data for antonym and synonym API request received and serialized successfully, http status code: 200")

        sharedClient.setOxfordDictionaryAPIClientDelegate(with: self)


        sharedClient.downloadThesaurusJSONData(forWord: "love", withAntonyms: true, withSynonyms: true)
        
        waitForExpectations(timeout: 20.00, handler: nil)

    }
    
    
    func testSynonymsAPIRequest() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        promise = expectation(description: "Promise fulfilled: JSON data for synonym API request received and serialized successfully, http status code: 200")

        sharedClient.setOxfordDictionaryAPIClientDelegate(with: self)

        sharedClient.downloadThesaurusJSONData(forWord: "love", withAntonyms: false, withSynonyms: true)
        
        waitForExpectations(timeout: 20.00, handler: nil)
    }
    
    func testAntonymsAPIRequest() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        promise = expectation(description: "Promise fulfilled: JSON data for antonym API request received and serialized successfully, http status code: 200")

        sharedClient.setOxfordDictionaryAPIClientDelegate(with: self)

        sharedClient.downloadThesaurusJSONData(forWord: "love", withAntonyms: true, withSynonyms: false)
        
        waitForExpectations(timeout: 20.00, handler: nil)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func didFailToConnectToEndpoint(withError error: Error) {
        XCTFail("Error occurred while attempting to connect to the server: \(error.localizedDescription)")

    }
    
    /** Proper credentials are provided, the API request can be authenticated; an HTTP Response is received but no data is provided **/
    
    
    func didFailToGetJSONData(withHTTPResponse httpResponse: HTTPURLResponse) {
        XCTFail("Unable to get JSON data with http status code: \(httpResponse.statusCode)")

    }
    
    /** Proper credentials are provided, and the API request is fully authenticated; an HTTP Response is received and the data is provided by the raw data could not be parsed into a JSON object **/
    
    func didFailToSerializeJSONData(withHTTPResponse httpResponse: HTTPURLResponse) {
        XCTFail("Unable to serialize the data into a json response, http status code: \(httpResponse.statusCode)")

    }
    
    
    
    /** If erroneous credentials are provided, the API request can't be authenticated; an HTTP Response is received but no data is provided **/
    

    func didFinishReceivingHTTPResponse(withHTTPResponse httpResponse: HTTPURLResponse) {
        XCTFail("HTTP response received with status code: \(httpResponse.statusCode)")

    }
    
    /** Proper credentials are provided, and the API request is fully authenticated; an HTTP Response is received and serialized JSON data is provided **/
    
    func didFinishReceivingJSONData(withJSONResponse jsonResponse: OxfordDictionaryAPIDelegate.JSONResponse, withHTTPResponse httpResponse: HTTPURLResponse) {
        
        promise.fulfill()
        print("JSON response is as follows: \(jsonResponse)")
    }
    
   

    
}
