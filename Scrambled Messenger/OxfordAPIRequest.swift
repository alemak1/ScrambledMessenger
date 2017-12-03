//
//  OxfordAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

struct OxfordAPIRequest{
    
    private static let baseURLString = "https://od-api.oxforddictionaries.com/api/v1"
    private static let appID = "acb61904"
    private static let appKey = "383d6f9739d4974fb81168976b6e991b"
    
    private static var baseURL: URL{
        return URL(string: baseURLString)!
    }
    
    var endpoint: OxfordAPIEndpoint
    var word: String
    var language: OxfordAPILanguage
    var filters: [OxfordAPIEndpoint.OxfordAPIFilter]?
    
    var hasRequestedSynonyms: Bool = false
    var hasRequestAntonyms: Bool = false
    var hasRequestedExampleSentences: Bool = false
    
    /** Different Initializers are used to restrict the range of possible URL strings that can be generated **/
    
    
    
    init(withWord queryWord: String, hasRequestedExampleSentencesQuery: Bool,forLanguage queryLanguage: OxfordAPILanguage = .English){
        
        self.endpoint = OxfordAPIEndpoint.entries
        self.word = queryWord
        self.language = OxfordAPILanguage.English
        self.filters = nil
        
        self.hasRequestedExampleSentences = hasRequestedExampleSentencesQuery
        self.hasRequestedSynonyms = false
        self.hasRequestAntonyms = false
    }
    
    init(withWord queryWord: String, hasRequestedAntonymsQuery: Bool, hasRequestedSynonymsQuery: Bool, forLanguage queryLanguage: OxfordAPILanguage = .English){
        
        self.endpoint = OxfordAPIEndpoint.entries
        self.word = queryWord
        self.language = OxfordAPILanguage.English
        self.filters = nil
        
        self.hasRequestedExampleSentences = false
        self.hasRequestedSynonyms = hasRequestedSynonymsQuery
        self.hasRequestAntonyms = hasRequestedAntonymsQuery
    }
    
    init(withEndpoint queryEndpoint: OxfordAPIEndpoint, withQueryWord queryWord: String, withFilters queryFilters: [OxfordAPIEndpoint.OxfordAPIFilter]?, withQueryLanguage queryLanguage: OxfordAPILanguage = .English){
        
        self.endpoint = queryEndpoint
        self.word = queryWord
        self.filters = queryFilters
        self.language = queryLanguage
        
        self.hasRequestedExampleSentences = false
        self.hasRequestAntonyms = false
        self.hasRequestedSynonyms = false
    }
    
    /** Generic default initializers with placeholder values for variables is provided for convenience  **/
    init(){
        self.endpoint = OxfordAPIEndpoint.entries
        self.word = "love"
        self.language = OxfordAPILanguage.English
        self.filters = nil
        
        self.hasRequestedExampleSentences = false
        self.hasRequestedSynonyms = false
        self.hasRequestAntonyms = false
        
    }
    
    
    func generateURLRequest() -> URLRequest{
        
        let urlString = getURLString()
        
        let url = URL(string: urlString)!
        
        let urlRequest = getURLRequest(forURL: url)
    
        return getURLRequest(forURL: url)
    }
    
    private func getURLRequest(forURL url: URL) -> URLRequest{
        
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(OxfordAPIRequest.appID, forHTTPHeaderField: "app_id")
        request.addValue(OxfordAPIRequest.appKey, forHTTPHeaderField: "app_key")
        
        return request
    }
    
    private func getProcessedWord() -> String{
        
        //Declare mutable, local version of word parameter
        var word_id = self.word
        
        //Make the word lowercased
        word_id = word_id.lowercased()
        
        //Add percent encoding to the query parameter
        let percentEncoded_word_id = word_id.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        word_id = percentEncoded_word_id == nil ? word_id : percentEncoded_word_id!
        
        //Replace spaces with underscores
        word_id = word_id.replacingOccurrences(of: " ", with: "_")
        
        return word_id
    }
    
    private func validateFilterParameters(){
        
    }
    
    
    private func getURLString() -> String{
        
        
        let baseURLString = OxfordAPIRequest.baseURLString.appending("/")
        
        let endpointStr = self.endpoint.rawValue.appending("/")
        
        let endpointURLString = baseURLString.appending(endpointStr)
        
        let languageStr = self.language.rawValue.appending("/")
        
        var languageURLString = endpointURLString.appending(languageStr)
        
        
        if(self.endpoint == .wordlist){
            
            if(self.filters == nil){
                
                /** Remove the final slash **/
                languageURLString.removeLast()
                
                return languageURLString
                
            } else {
                //TODO: Add filters for register,domain,region,etc
            }
            
        } else {
            
            let wordStr = self.getProcessedWord().appending("/")
            
            var wordURLString = languageURLString.appending(wordStr)
            
            if(self.endpoint == .entries){
                
                if(hasRequestAntonyms || hasRequestedSynonyms){
                    
                    if(hasRequestedSynonyms && hasRequestAntonyms){
                        
                        let finalURLString = wordURLString.appending("synonyms;antonyms")
                        
                        return finalURLString
                        
                    } else if(hasRequestedSynonyms){
                        
                        let finalURLString = wordURLString.appending("synonyms")
                        
                        return finalURLString
                        
                    } else if(hasRequestAntonyms){
                        
                        let finalURLString = wordURLString.appending("antonyms")
                        
                        return finalURLString
                    }
                    
                } else if(hasRequestedExampleSentences) {
                    
                    let finalURLString = wordURLString.appending("sentences")
                    
                    return finalURLString
                    
                } else if(self.filters != nil) {
                    //Add filters for dictionary entries request for the given word
                    
                    
                } else {
                    
                    wordURLString.removeLast()
                    
                    return wordURLString
                    
                }
                
            } else {
                
                if(self.filters != nil){
                    
                }
            }
            
        }
        
        return String()
    }
    
    

}
