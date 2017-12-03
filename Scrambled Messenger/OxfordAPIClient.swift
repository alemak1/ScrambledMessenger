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
    
    
    func downloadJSONLemmaDatafor(word: String, withFilters filters: [OxfordAPIEndpoint.OxfordAPIFilter]?){
        
        let apiRequest = OxfordAPIRequest(withEndpoint: .inflections, withQueryWord: word, withFilters: filters)
        
        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    
    /** Wrapper function for executing aynchronous download of JSON data from Oxford Dictionary API **/
    
    private func startDataTask(withURLRequest request: URLRequest){
        
        
        _ = self.urlSession.dataTask(with: request, completionHandler: { data, response, error in
            
            switch (data,response,error){
            case (.some,.some,.none),(.some,.some,.some): //Able to connect to the server, data received
                
                let httpResponse = (response! as! HTTPURLResponse)
                
                
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! JSONResponse{
                    //Data received, and JSON serialization successful
                    
                    self.didFinishReceivingJSONData(withJSONResponse: jsonResponse, withHTTPResponse: httpResponse)
                    
                } else{
                    //Data received, but JSON serialization not successful
                    self.didFailToGetJSONData(withHTTPResponse: httpResponse)
                }
                
                break
            case (.none,.some,.none),(.none,.some,.some): //Able to connect to the server but failed to get data or received a bad HTTP Response
                if let httpResponse = (response as? HTTPURLResponse){
                    self.didFailToGetJSONData(withHTTPResponse: httpResponse)
                }
                break
            case (.none,.none,.some): //Unable to connect to the server, with an error received
                self.didFailToConnectToEndpoint(withError: error!)
                break
            case (.none,.none,.none): //Unable to connect to the server, no error received
                let error = NSError(domain: "Failed to get a response: Error occurred while attempting to connect to the server", code: 0, userInfo: nil)
                self.didFailToConnectToEndpoint(withError: error)
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
