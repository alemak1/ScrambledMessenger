//
//  DictionaryAPIClient.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 11/29/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation


class DictionaryAPIClient: OxfordDictionaryAPIDelegate{
    
    static let sharedClient = DictionaryAPIClient()
    
    typealias JSONResponse = [String: Any]

    /** Base URL, AppID, and AppKey are stored as static constants **/
    
    private static let baseURLString = "https://od-api.oxforddictionaries.com/api/v1"
    
    private static var baseURL: URL{
        return URL(string: baseURLString)!
    }
    
    private static let appID = "acb61904"
    private static let appKey = "383d6f9739d4974fb81168976b6e991b"
 
    /** Instance variables **/
    
    private var urlSession: URLSession!
    
    private var delegate: OxfordDictionaryAPIDelegate?
    
    private init(){
        urlSession = URLSession.shared
        delegate = self
    }
    
    
    
    /** No validation done here on the filters **/
    
    func downloadJSONData(forURLString endpoint: OxfordAPIEndpoint, forWord word: String, andWithFilters filters: [OxfordAPIEndpoint.OxfordAPIFilter], forLanguage language: String = "en"){
    
        let baseURL = DictionaryAPIClient.baseURL
        
        let endpointStr = "/".appending(endpoint.rawValue)
        
        let modifiedURL1 = URL(string: endpointStr, relativeTo: baseURL)
        
        let languageStr = "/".appending(language)
        
        let modifiedURL2 = URL(string: languageStr, relativeTo: modifiedURL1)

        var wordStr = "/".appending(word)
        
        DictionaryAPIClient.processWordQueryParameter(forWord: &wordStr)
        
        let modifiedURL3 = URL(string: wordStr, relativeTo: modifiedURL2)

        let filtersStr: String = filters.map({$0.getQueryParameterString(isLastQueryParameter: false)}).reduce("", { $0.appending($1) })
        
        let finalURL = URL(string: filtersStr, relativeTo: modifiedURL3)!
        
        let urlRequest = DictionaryAPIClient.configureURLRequest(forURL: finalURL)
        
        self.startDataTask(withURLRequest: urlRequest)
        
    }
  
    func downloadJSONLemmaDatafor(word: String){
        
        let word_id = word.lowercased() //word id is case sensitive and lowercase is required
        
        let urlString = DictionaryAPIClient.getURLString(forEndpoint: "inflections", forLanguage: "en")

        let url = URL(string: "\(urlString)/\(word_id)")!
        
        let request = DictionaryAPIClient.getConfiguredURLRequest(forURL: url)
    
        self.startDataTask(withURLRequest: request)
    }
    
    
 
    
    func setDictionaryAPIDelegate(with apiDelegate: OxfordDictionaryAPIDelegate){
        
        self.delegate = apiDelegate
        
    }
    
    
    func downloadAllEndpointFiltersJSONData(forEndpoint endpoint: OxfordAPIEndpoint){
        
        let urlRequest = DictionaryAPIClient.getURLRequestForAllEndpointFilter(forEndpoint: endpoint)
        
        self.startDataTask(withURLRequest: urlRequest)

    }
    
    
    func downloadAllRegionsJSONData(){
        
        let urlRequest =  DictionaryAPIClient.getURLRequestForAllRegionParameterValues()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    func downloadAllRegistersJSONData(){
        
        let urlRequest =  DictionaryAPIClient.getAllRegistersURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    func downloadAllDomainsJSONData(){
        
        let urlRequest =  DictionaryAPIClient.getAllDomainsURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    func downloadAllGrammaticalFeaturesJSONData(forLanaguage language: String = "en"){
        
       let urlRequest =  DictionaryAPIClient.getGrammaticalFeaturesURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    func downloadAllLexicalCategoriesJSONData(forLanaguage language: String = "en"){

        let urlRequest =  DictionaryAPIClient.getLexicalCategoryURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)


    }
    
    func downloadJSONDataForCorporaSentences(forWord word: String, forLanguage language: String = "en"){

        let urlRequest = DictionaryAPIClient.getCorporaSentencesURLRequest(forWord: word, forLanguage: language)
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    
    func downloadJSONDataForThesaurusEntry(forWord word: String, hasSynonyms: Bool, hasAntonyms: Bool, forLanguage language: String = "en"){
        
        let urlRequest = DictionaryAPIClient.getThesaurusEntryURLRequest(forWord: word, withSynonyms: hasSynonyms, withAntonyms: hasAntonyms,forLanguage: language)
        
        self.startDataTask(withURLRequest: urlRequest)
    }
  
    
    func downloadJSONDataForDictionaryEntry(forWord word: String, forLexicalCategory lexicalCategory: OxfordLexicalCategory?, withGrammaticalFeatures grammaticalFeatures: [OxfordGrammaticalFeature]?){
        
        let url = DictionaryAPIClient.getDictionaryEntryURL(forWord: word, withLexicalCategory: lexicalCategory, withGrammaticalFeatures: grammaticalFeatures)
        
        let urlRequest = DictionaryAPIClient.getConfiguredURLRequest(forURL: url)
        
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


//MARK: ***** Helper methods for generating URL Strings, URLs, and URL Request objects

extension DictionaryAPIClient{
    
    static func getDictionaryEntryURLRequest(forWord word: String, withLexicalCategory lexicalCategory: OxfordLexicalCategory?, withGrammaticalFeatures grammaticalFeatures: [OxfordGrammaticalFeature]?) -> URLRequest{
        
        let url = getDictionaryEntryURL(forWord: word, withLexicalCategory: lexicalCategory, withGrammaticalFeatures: grammaticalFeatures)
        
        return getConfiguredURLRequest(forURL: url)
    }
    
    static func getGrammaticalFeaturesURLRequest() -> URLRequest{
        
        let url = getURLForGrammaticalFeaturesRequest()
        
        return getConfiguredURLRequest(forURL: url)
        
    }
    
    static func getAllRegistersURLRequest() -> URLRequest{
    
        let url = getURLForAllRegistersRequest()
        
        return getConfiguredURLRequest(forURL: url)

    }
    
    static func getAllDomainsURLRequest() -> URLRequest{
        
        let url = getURLForAllDomainsRequest()
        
        return getConfiguredURLRequest(forURL: url)
    }
    
    static func getThesaurusEntryURLRequest(forWord word: String, withSynonyms hasRequestedSynonyms: Bool, withAntonyms hasRequestedAntonyms: Bool, forLanguage language: String = "en") -> URLRequest{
        
        let url = getThesaurusEntryURL(forWord: word, withSynonyms: hasRequestedSynonyms, withAntonyms: hasRequestedAntonyms, forLanguage: language)
        
        return getConfiguredURLRequest(forURL: url)

        
    }
    
    static func getLexicalCategoryURLRequest() -> URLRequest{
        
        let url = getURLForLexicalCategoriesRequest()
        
        return getConfiguredURLRequest(forURL: url)

        
    }
    
    static func getCorporaSentencesURLRequest(forWord word: String, forLanguage language: String = "en") -> URLRequest{
        
        let url = getCorporaSentencesURL(forWord: word, forLanguage: language)
        
        return configureURLRequest(forURL: url)
    }
    
    static func getURLRequestForAllRegionParameterValues() -> URLRequest{
        let url = getURLForAllRegionsRequest()
        
        return configureURLRequest(forURL: url)
    }
    
    static func getConfiguredURLRequest(forURL url: URL) -> URLRequest{
        
        let urlRequest = configureURLRequest(forURL: url)
        
        return urlRequest
    }
    
    static func configureURLRequest(forURL url: URL) -> URLRequest{
        
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(appID, forHTTPHeaderField: "app_id")
        request.addValue(appKey, forHTTPHeaderField: "app_key")
        
        return request
    }
    
    
    
    static func getCorporaSentencesURL(forWord word: String, forLanguage language: String = "en") -> URL{
        
        var word_id = word
        
        processWordQueryParameter(forWord: &word_id)
        
        let urlString = getURLString(forEndpoint: "entries", forLanguage: language)
        
        var modifiedURLString = "\(urlString)/\(word)/sentences"

        return URL(string: modifiedURLString)!

    }
    
    static func getThesaurusEntryURL(forWord word: String, withSynonyms hasRequestedSynonyms: Bool, withAntonyms hasRequestedAntonyms: Bool, forLanguage language: String = "en") -> URL{
        
        var word_id = word
        
        processWordQueryParameter(forWord: &word_id)
        
        let urlString = getURLString(forEndpoint: "entries", forLanguage: language)
        
        var modifiedURLString = "\(urlString)/\(word)"
        
        switch (hasRequestedAntonyms,hasRequestedSynonyms) {
        case (true,true):
            modifiedURLString = "\(urlString)/\(word)/synonyms;antonyms"
            break
        case (false,true):
            modifiedURLString = "\(urlString)/\(word)/synonyms"
            break
        case (true,false):
            modifiedURLString = "\(urlString)/\(word)/antonyms"
        default:
            break
        }
        
        return URL(string: modifiedURLString)!

    }
    
    static func getDictionaryEntryURL(forWord word: String, withLexicalCategory lexicalCategory: OxfordLexicalCategory?, withGrammaticalFeatures grammaticalFeatures: [OxfordGrammaticalFeature]?, forLanguage language: String = "en") -> URL{
        
        var word_id = word
        
        processWordQueryParameter(forWord: &word_id)
        
        let urlString = getURLString(forEndpoint: "entries", forLanguage: language)
        
        var modifiedURLString = "\(urlString)/\(word)"
        
        configureURLString(urlString: &modifiedURLString, withLexicalCategory: lexicalCategory, andWithGrammaticalFeatures: grammaticalFeatures)
        
        return URL(string: modifiedURLString)!
        
    }
    
    static func processWordQueryParameter(forWord word_id: inout String){
        
        //Make the word lowercased
        word_id = word_id.lowercased()
        
        //Add percent encoding to the query parameter
        let percentEncoded_word_id = word_id.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        word_id = percentEncoded_word_id == nil ? word_id : percentEncoded_word_id!
        
        //Replace spaces with underscores
        word_id = word_id.replacingOccurrences(of: " ", with: "_")
    }
    
    
    static func configureURLString(urlString: inout String, withLexicalCategory lexicalCategory: OxfordLexicalCategory?, andWithGrammaticalFeatures grammaticalFeatures: [OxfordGrammaticalFeature]?){
        
        switch (lexicalCategory,grammaticalFeatures) {
        case (.some,.some):
            configureURLString(urlString: &urlString, withGrammaticalFeatures: grammaticalFeatures!, hasOtherQueryParameters: true)
            configureURLString(urlString: &urlString, withLexicalCategory: lexicalCategory!)
            break
        case (.some,.none):
            configureURLString(urlString: &urlString, withLexicalCategory: lexicalCategory!)
            break
        case (.none,.some):
            configureURLString(urlString: &urlString, withGrammaticalFeatures: grammaticalFeatures!, hasOtherQueryParameters: false)
            
            break
        default:
            break
        }
    }
    
    static func configureURLString(urlString: inout String, withLexicalCategory lexicalCategory: OxfordLexicalCategory){
        
        if(urlString.last! == ";"){
            urlString = "\(urlString)lexicalCategory=\(lexicalCategory.rawValue)"
            return
        }
        
        urlString = "\(urlString)/lexicalCategory=\(lexicalCategory.rawValue)"
        
    }
    
    static func configureURLString(urlString: inout String, withGrammaticalFeatures grammaticalFeatures: [OxfordGrammaticalFeature], hasOtherQueryParameters: Bool){
        
        urlString = "\(urlString)/grammaticalFeatures="
        
        for feature in grammaticalFeatures{
            urlString = urlString.appending("\(feature.rawValue),")
        }
        
        /** Remove the last comma added to the last feature **/
        urlString.removeLast()
        
        if(hasOtherQueryParameters){
            urlString = urlString.appending(";")
        }
    }
    
    static func getURL(forEndpoint endpoint: String, forWord word: String, forLanguage language: String = "en") -> URL{
        
        let modifiedURLString = getURLString(forEndpoint: endpoint, forWord: word, forLanguage: language)
        
        return URL(string: modifiedURLString)!
        
    }
    
    static func getURLString(forEndpoint endpoint: String, forWord word: String, forLanguage language: String = "en") -> String{
        
        let word_id = word.lowercased()
        
        let urlString = getURLString(forEndpoint: endpoint, forLanguage: language)
        
        return "\(urlString)/\(word_id)"
    }
    
    
    
    
    static func getURLForAllRegionsRequest(forLanguage language: String = "en") -> URL{
        
        let urlString = getURLString(forEndpoint: "regions", forLanguage: language)
        
        let url = URL(string: urlString)!
        
        return url
    }
    
    static func getURLForAllRegistersRequest(forLanguage language: String = "en") -> URL{
        
        let urlString = getURLString(forEndpoint: "registers", forLanguage: language)
        
        let url = URL(string: urlString)!
        
        return url
    }
    
    static func getURLForAllDomainsRequest(forLanguage language: String = "en") -> URL{
        
        let urlString = getURLString(forEndpoint: "domains", forLanguage: language)
        
        let url = URL(string: urlString)!
        
        return url
    }
    
    static func getURLRequestForAllEndpointFilter(forEndpoint endpoint: OxfordAPIEndpoint) -> URLRequest{
        
        let urlString = "\(DictionaryAPIClient.baseURL)/filters/\(endpoint.rawValue)"
        
        let url = URL(string: urlString)!
        
        return configureURLRequest(forURL: url)
    }
   
    
    static func getURLForLexicalCategoriesRequest(forLanguage language: String = "en") -> URL{
        
        let urlString = getURLString(forEndpoint: "lexicalcategories", forLanguage: language)
        
        let url = URL(string: urlString)!
        
        return url
    }
    
    static func getURLForGrammaticalFeaturesRequest(forLanguage language: String = "en") -> URL{
        
        let urlString = getURLString(forEndpoint: "grammaticalFeatures", forLanguage: language)
        
        let url = URL(string: urlString)!
        
        return url

    }
    
    static func getURLString(forEndpoint endpoint: String, hasFinalSlash: Bool = false, forLanguage language: String = "en") -> String{
        
        let urlString = hasFinalSlash ?
            "\(DictionaryAPIClient.baseURL)/\(endpoint)/\(language)/" :
            "\(DictionaryAPIClient.baseURL)/\(endpoint)/\(language)"
      
    
        return urlString
    }
    
    
}


//MARK: ********* Conformance to DictionaryAPIClient protocol methods

extension DictionaryAPIClient{
    
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
