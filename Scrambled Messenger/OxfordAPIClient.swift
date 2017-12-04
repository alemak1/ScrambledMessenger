//
//  OxfordAPIClient.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

class OxfordAPIClient: OxfordDictionaryAPIDelegate{
    
    static let sharedClient = OxfordAPIClient()
    
    /** Instance variables **/
    
    private var urlSession: URLSession!
    private var delegate: OxfordDictionaryAPIDelegate?
    
    private init(){
        urlSession = URLSession.shared
        delegate = self
    }
    
    func setOxfordDictionaryAPIClientDelegate(with apiDelegate: OxfordDictionaryAPIDelegate){
        
        self.delegate = apiDelegate
        
    }
    
    func resetDefaultDelegate(){
        self.delegate = self
    }
    
    
    func downloadLemmatronJSONData(forHeadWord headWord: String, andWithFilters filters: [OxfordAPIEndpoint.OxfordAPIFilter]?){
        
        let apiRequest = OxfordAPIRequest()
        
        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
        
    }
    
    func downloadWordListJSONData(forDomainFilters domainFilters: [OxfordAPIEndpoint.OxfordAPIFilter], forRegionFilters regionFilters: [OxfordAPIEndpoint.OxfordAPIFilter], forRegisterFilters registerFilters: [OxfordAPIEndpoint.OxfordAPIFilter], forTranslationFilters translationFilters: [OxfordAPIEndpoint.OxfordAPIFilter], forLexicalCategoryFilters lexicalCategoryFilters: [OxfordAPIEndpoint.OxfordAPIFilter]){
        
        let apiRequest = OxfordAPIRequest(withDomainFilters: domainFilters, withRegionFilters: regionFilters, withRegisterFilters: registerFilters, withTranslationsFilters: translationFilters, withLexicalCategoryFilters: lexicalCategoryFilters)
        
        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    func downloadDictionaryEntryJSONData(forWord word: String, withFilters filters: [OxfordAPIEndpoint.OxfordAPIFilter]?){
        
        let apiRequest = OxfordAPIRequest(withWord: word, withFilters: filters)

        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    func downloadExampleSentencesJSONData(forWord word: String){
        
        let apiRequest = OxfordAPIRequest(withWord: word, hasRequestedExampleSentencesQuery: true, forLanguage: OxfordAPILanguage.English)
        
        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    func downloadThesaurusJSONData(forWord word: String, withAntonyms hasRequestedAntonyms: Bool, withSynonyms hasRequestedSynonyms: Bool){
        
        let apiRequest = OxfordAPIRequest(withWord: word, hasRequestedAntonymsQuery: hasRequestedAntonyms, hasRequestedSynonymsQuery: hasRequestedSynonyms)
        
        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    
    func downloadWordlistJSONDataWithValidation(forFilters filters: [OxfordAPIEndpoint.OxfordAPIFilter]?, forLanguage language: OxfordAPILanguage = OxfordAPILanguage.English){
        
        let apiRequest = OxfordAPIRequest(withEndpoint: OxfordAPIEndpoint.wordlist, withQueryWord: String(), withFilters: filters, withQueryLanguage: language)
        
        do {
            
            let urlRequest = try apiRequest.generateValidatedURLRequest()
            
            self.startDataTask(withURLRequest: urlRequest)

        } catch let error as NSError {
            
            guard let apiDelegate = self.delegate else {
                fatalError("Error: no delegate specified for Oxford API download task")
            }
            
            apiDelegate.didFailToConnectToEndpoint(withError: error)
        }
        
        
    }
    
    /** Wrapper function for executing aynchronous download of JSON data from Oxford Dictionary API **/
    
    private func startDataTask(withURLRequest request: URLRequest){
        
        guard let delegate = self.delegate else {
            fatalError("Error: no delegate specified for Oxford API download task")
        }
        
        _ = self.urlSession.dataTask(with: request, completionHandler: { data, response, error in
            
            switch (data,response,error){
            case (.some,.some,.none),(.some,.some,.some): //Able to connect to the server, data received
                
                let httpResponse = (response! as! HTTPURLResponse)
                
                
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! JSONResponse{
                    //Data received, and JSON serialization successful
                    
                    delegate.didFinishReceivingJSONData(withJSONResponse: jsonResponse, withHTTPResponse: httpResponse)
                    
                } else{
                    //Data received, but JSON serialization not successful
                    delegate.didFailToGetJSONData(withHTTPResponse: httpResponse)
                }
                
                break
            case (.none,.some,.none),(.none,.some,.some): //Able to connect to the server but failed to get data or received a bad HTTP Response
                if let httpResponse = (response as? HTTPURLResponse){
                    delegate.didFailToGetJSONData(withHTTPResponse: httpResponse)
                }
                break
            case (.none,.none,.some): //Unable to connect to the server, with an error received
                delegate.didFailToConnectToEndpoint(withError: error!)
                break
            case (.none,.none,.none): //Unable to connect to the server, no error received
                let error = NSError(domain: "Failed to get a response: Error occurred while attempting to connect to the server", code: 0, userInfo: nil)
                delegate.didFailToConnectToEndpoint(withError: error)
                break
            default:
                break
            }
            
        }).resume()
    }
    
}



//MARK: ********* Conformance to DictionaryAPIClient protocol methods

extension OxfordAPIClient{
    
    /** Unable to establish a connection with the server **/
    
    internal func didFailToConnectToEndpoint(withError error: Error) {
        
        print("Error occurred while attempting to connect to the server: \(error.localizedDescription)")
        
        
    }
    
    /** Proper credentials are provided, the API request can be authenticated; an HTTP Response is received but no data is provided **/
    
    
    internal func didFailToGetJSONData(withHTTPResponse httpResponse: HTTPURLResponse){
        print("Unable to get JSON data with http status code: \(httpResponse.statusCode)")
        showOxfordStatusCodeMessage(forHTTPResponse: httpResponse)
        
        
        
    }
    
    /** Proper credentials are provided, and the API request is fully authenticated; an HTTP Response is received and the data is provided by the raw data could not be parsed into a JSON object **/
    
    internal func didFailToSerializeJSONData(withHTTPResponse httpResponse: HTTPURLResponse){
        
        print("Unable to serialize the data into a json response, http status code: \(httpResponse.statusCode)")
        showOxfordStatusCodeMessage(forHTTPResponse: httpResponse)
        
    }
    
    
    
    /** If erroneous credentials are provided, the API request can't be authenticated; an HTTP Response is received but no data is provided **/
    
    internal func didFinishReceivingHTTPResponse(withHTTPResponse httpResponse: HTTPURLResponse){
        
        print("HTTP response received with status code: \(httpResponse.statusCode)")
        showOxfordStatusCodeMessage(forHTTPResponse: httpResponse)
    }
    
    /** Proper credentials are provided, and the API request is fully authenticated; an HTTP Response is received and serialized JSON data is provided **/
    
    internal func didFinishReceivingJSONData(withJSONResponse jsonResponse: JSONResponse, withHTTPResponse httpResponse: HTTPURLResponse) {
        
        print("JSON response received, http status code: \(httpResponse.statusCode)")
        showOxfordStatusCodeMessage(forHTTPResponse: httpResponse)
        
        
        print("JSON data received as follows:")
        print(jsonResponse)
    }
    
    func showOxfordStatusCodeMessage(forHTTPResponse httpResponse: HTTPURLResponse){
        
        if let oxfordStatusCode = OxfordHTTPStatusCode(rawValue: httpResponse.statusCode){
            let statusCodeMessage = oxfordStatusCode.statusCodeMessage()
            print("Status Code Message: \(statusCodeMessage)")
        }
        
        
    }
}
