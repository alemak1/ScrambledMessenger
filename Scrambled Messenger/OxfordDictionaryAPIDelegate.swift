//
//  OxfordDictionaryAPIDelegate.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 11/29/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

protocol OxfordDictionaryAPIDelegate{
    
    typealias JSONResponse = DictionaryAPIClient.JSONResponse
    
    func didFailToConnectToEndpoint(withError error: Error)
   
    func didFailToGetJSONData(withHTTPResponse httpResponse: HTTPURLResponse)
    
    func didFailToSerializeJSONData(withHTTPResponse httpResponse: HTTPURLResponse)
   
    func didFinishReceivingHTTPResponse(withHTTPResponse httpResponse: HTTPURLResponse)
    
    func didFinishReceivingJSONData(withJSONResponse jsonResponse: JSONResponse, withHTTPResponse httpResponse: HTTPURLResponse)

    
}
