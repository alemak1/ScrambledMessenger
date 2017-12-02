//
//  LinguisticTaggerHelper.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 11/29/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

struct TokenTypeConfiguration{
    var totalWords: Int = 0
    var totalPunctuationMarks: Int = 0
    var totalWhiteSpace: Int = 0
    var totalOther: Int = 0
}

struct LexicalClassConfiguration{
    var totalWords: Int = 0
    var totalNouns: Int = 0
    var totalVerbs: Int = 0
    var totalAdjectives: Int = 0
    var totalAdverbs: Int = 0
    var totalPronouns: Int = 0
    var totalPrepositions: Int = 0
    var totalDeterminers: Int = 0
    var totalConjunctions: Int = 0
    
    init(){
    
    }
    
    init(totalWords: Int, totalNouns: Int, totalVerbs: Int, totalAdjectives: Int, totalAdverbs: Int, totalPronouns: Int, totalPrepositions: Int, totalDeterminers: Int, totalConjunctions: Int){
        
        self.totalWords = totalWords
        self.totalPronouns = totalPronouns
        self.totalAdjectives = totalAdjectives
        self.totalAdverbs = totalAdverbs
        self.totalNouns = totalNouns
        self.totalVerbs = totalVerbs
        self.totalPrepositions = totalPrepositions
        self.totalPronouns = totalPronouns
        self.totalDeterminers = totalDeterminers
        self.totalConjunctions = totalConjunctions

    }

    
    init(dict: Dictionary<String,Any>){
        
        if let nouns = dict["noun"] as? Int{
            self.totalNouns = nouns
        }
        
        if let verbs = dict["verb"] as? Int{
            self.totalVerbs = verbs
        }
        
        if let adjectives = dict["adjective"] as? Int{
            self.totalAdjectives = adjectives
        }
        
        if let adverbs = dict["adverb"] as? Int{
            self.totalAdverbs = adverbs
        }
        
        if let conjunctions = dict["conjunction"] as? Int{
            self.totalConjunctions = conjunctions
        }
        
        if let determiners = dict["determiner"] as? Int{
            self.totalDeterminers = determiners
        }
        
        if let pronouns = dict["pronoun"] as? Int{
            self.totalPronouns = pronouns
        }
        
        if let prepositions = dict["preposition"] as? Int{
            self.totalPronouns = prepositions
        }


    }
    
}


class LinguisticTaggerHelper{
    
    static func getLexicalClassConfiguration(forText rawText: String) -> LexicalClassConfiguration{
        
        let range = NSRange(location: 0, length: rawText.utf16.count)
        
        let tagger = NSLinguisticTagger.init(tagSchemes: [.lexicalClass], options: 0)
        
        tagger.string = rawText
        
        let options: NSLinguisticTagger.Options = [.omitPunctuation,.omitWhitespace]
        
        
        
        var lexicalClassConfiguration = LexicalClassConfiguration()
        
        
        
        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options, using: {
            
            tag,substringRange,shouldStopEnumeration in
           
            
            
            if let linguisticTag = tag{
                
                switch linguisticTag{
                case NSLinguisticTag.noun:
                    lexicalClassConfiguration.totalNouns += 1
                    break
                case NSLinguisticTag.adjective:
                    lexicalClassConfiguration.totalAdjectives += 1
                    break
                case NSLinguisticTag.verb:
                    lexicalClassConfiguration.totalVerbs += 1
                    break
                case NSLinguisticTag.adverb:
                    lexicalClassConfiguration.totalAdverbs += 1
                    break
                case NSLinguisticTag.pronoun:
                    lexicalClassConfiguration.totalPronouns += 1
                    break
                case NSLinguisticTag.preposition:
                    lexicalClassConfiguration.totalPrepositions += 1
                    break
                case NSLinguisticTag.determiner:
                    lexicalClassConfiguration.totalDeterminers += 1
                    break
                case NSLinguisticTag.conjunction:
                    lexicalClassConfiguration.totalConjunctions += 1
                    break
                default:
                    break
                }
                
                
            }
            
        })
        
        
        return lexicalClassConfiguration
        
    }
    
    
    static func getTokenTypeConfiguration(forText rawText: String) -> TokenTypeConfiguration{
        
        let range = NSRange(location: 0, length: rawText.utf16.count)
        
        let tagger = NSLinguisticTagger.init(tagSchemes: [.tokenType], options: 0)
        
        tagger.string = rawText
        
        let options: NSLinguisticTagger.Options = [.omitPunctuation,.omitWhitespace]
        
        var tokenTypeConfiguration = TokenTypeConfiguration()
        
        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options, using: {
            
            tag,range,_ in
            
            if let linguisticTag = tag{
                
                
                switch linguisticTag{
                case NSLinguisticTag.word:
                    tokenTypeConfiguration.totalWords += 1
                    break
                case NSLinguisticTag.punctuation:
                    tokenTypeConfiguration.totalPunctuationMarks += 1
                    break
                case NSLinguisticTag.whitespace:
                    tokenTypeConfiguration.totalWhiteSpace += 1
                    break
                case NSLinguisticTag.other:
                    tokenTypeConfiguration.totalOther += 1
                    break
                    
                default:
                    break
                    
                    
                }
            }
            
            
            
        })
        
        return tokenTypeConfiguration
        
    }
    
    
}
