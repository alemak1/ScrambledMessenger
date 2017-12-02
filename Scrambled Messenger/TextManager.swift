//
//  TextManager.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 11/19/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
/**
class TextManager{
    
    /** Create functions to get quoted text as well as text in parenthesis **/
    
        
    static let sharedManager = TextManager()
    
    var tagger: NSLinguisticTagger
    
    var rawText: String?
    
    var words: [String]?
    var nouns: [String]?
    var verbs: [String]?
    var adjectives: [String]?
    
    private init(){
        tagger = NSLinguisticTagger(tagSchemes: [.lexicalClass,.tokenType,.nameType], options: 0)
    }
    
    
    
    func configureSampleText(text: String, withFullLexicalAnalysis hasRequestedFullLexicalAnalysis: Bool = false){
        
        clearPreviousWordCaches()
        
        rawText = text
        
        if(hasRequestedFullLexicalAnalysis){
            self.performFullLexicalAnalysis()
        }
        
    }
    
    
    
    
    func getNumberOfWords(forLexicalClass lexicalClass: PartOfSpeech) -> Int{
        
        if(self.rawText == nil){
            print("Error: number of words for lexical class \(lexicalClass.rawValue) could not be determined because no sample text has been provided for linguistic analysis")
            return 0
        }
        
        
        switch lexicalClass {
        case .noun:
            return getNumberOfNouns()
        case .adjective:
            return getNumberOfAdjectives()
        case .verb:
            return getNumberOfVerbs()
        default:
            return 0
        }
        
    }
    
    
    
    func getNumberOfVerbs() -> Int{
        
        if(self.rawText == nil){
            print("Error: no sample text provided")
            return 0
        }
        
        if self.verbs == nil{
            processText(forPartOfSpeech: .verb)
            return self.verbs!.count
        } else {
            return self.verbs!.count
        }
    }
    
    func getNumberOfAdjectives() -> Int{
        
        if(self.rawText == nil){
            print("Error: no sample text provided")
            return 0
        }
        
        if self.adjectives == nil{
            processText(forPartOfSpeech: .adjective)
            return self.adjectives!.count
        } else {
            return self.adjectives!.count
        }
    }
    
    func getNumberOfNouns() -> Int{
        
        if(self.rawText == nil){
            print("Error: no sample text provided")
            return 0
        }
        
        if self.nouns == nil{
            processText(forPartOfSpeech: .noun)
            return self.nouns!.count
        } else {
            return self.nouns!.count
        }
    }
    
    func processText(forPartOfSpeech partOfSpeech: PartOfSpeech){
        
        guard let rawText = self.rawText else {
            print("Error: failed to process text; no sample text has been provided")
            return
        }
        
        let range = NSRange(location: 0, length: rawText.utf16.count)

        let options: NSLinguisticTagger.Options = [.omitPunctuation,.omitWhitespace]

        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options, using: {
            
            tag,substringRange,shouldStopEnumeration in
            
            let word = (rawText as NSString).substring(with: substringRange)
            
            addToStoredWords(word: word)
            
            if let linguisticTag = tag{
                performAnalysisFor(word: word, andForTag: linguisticTag, andForPartOfSpeech: partOfSpeech)
            }
            
        })
    }
    
    
    private func performFullLexicalAnalysis(){
        PartOfSpeech.allPartsOfSpeech.forEach({
            
            partOfSpeech in
            
            self.processText(forPartOfSpeech: partOfSpeech)
            
        })

    }
    
    private func performAnalysisFor(word: String, andForTag tag: NSLinguisticTag, andForPartOfSpeech partOfSpeech: PartOfSpeech){
    
        if tag.rawValue == partOfSpeech.rawValue{
            switch partOfSpeech{
            case .noun:
                addToStoredNouns(word: word)
                break
            case .verb:
                addToStoredVerbs(word: word)
                break
            case .adjective:
                addToStoredAdjectives(word: word)
                break
            default:
                break
                
            }
            
        }
    }
    
    private func addToStoredWords(word: String){
        if self.words == nil{
            self.words = [String]()
            words!.append(word)
        } else {
            words!.append(word)
        }
    }
    
    private func addToStoredNouns(word: String){
        if self.nouns == nil{
            self.nouns = [String]()
            nouns!.append(word)
        } else {
            nouns!.append(word)
        }
    }
    
    private func addToStoredVerbs(word: String){
        if self.verbs == nil{
            self.verbs = [String]()
            verbs!.append(word)
        } else {
            verbs!.append(word)
        }
    }
    
    private func addToStoredAdjectives(word: String){
        if self.adjectives == nil{
            self.adjectives = [String]()
            adjectives!.append(word)
        } else {
            adjectives!.append(word)
        }
    }
    
    private func clearPreviousWordCaches(){
        self.rawText = nil
        self.words = nil
        self.nouns = nil
        self.adjectives = nil
        self.verbs = nil
    }
    
}
 **/
