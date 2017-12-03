//
//  OxfordAPIClient.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

class OxfordAPIClient: URLSessionDelegate{
    
    typealias JSONResponse = [String: Any]
    static let sharedClient = OxfordAPIClient()
    
    /** Instance variables **/
    
    private var urlSessionConfiguration: URLSessionConfiguration!
    private var urlSession: URLSession!
    
    private init(){
        
        urlSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        urlSession = URLSession(configuration: self.urlSessionConfiguration, delegate: self, delegateQueue: nil)
        
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
    
    
    /** Wrapper function for executing aynchronous download of JSON data from Oxford Dictionary API **/
    
    private func startDataTask(withURLRequest request: URLRequest){
        
   
        let downloadTask = self.urlSession.downloadTask(with: request)
        
    
        
        
    }
    
}



extension OxfordAPIClient{
    
    /** URL Session Delegate methods **/
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
    }
}

