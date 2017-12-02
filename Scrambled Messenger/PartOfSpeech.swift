//
//  PartOfSpeech.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/1/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation



enum OxfordRegions: String{
    case north_america
}

enum OxfordAPIEndpoint: String{
    
    case entries, inflections, translations, wordlist
    
    enum OxfordAPIFilters{
        
        case domains
        case lexicalCategory
        case regions
        case registers
        case translations
        case definitions
        case etymologies
        case examples
        case grammaticalFeatures
        case pronunciations
        case variantForms
        
    }
    
    func getAvailableFilters() -> Set<OxfordAPIFilters>{
        switch self {
        case .entries:
            return Set([.definitions,.domains,.etymologies,.examples,.grammaticalFeatures,.lexicalCategory,
                       .pronunciations,.regions,.registers, .variantForms])
        case .inflections:
            return Set([.grammaticalFeatures,.lexicalCategory])
        case .translations:
            return Set()
        case .wordlist:
            return Set([ .domains,.lexicalCategory,.regions,.registers,.translations])
        }
    }
}

enum OxfordDomains: String{
    case air_force, alcoholic,american_civil_war,american_football,amerindian
    case anatomy,ancient_history,angling,anthropology, archaeology, archery, architecture
    case art, artefacts, arts_and_humanities, astrology, astronomy
    case athletics, audio, australian_rules, aviation, ballet, baseball, basketball, bellringing
    case biblical, billiards, biochemistry, biology, bird, bookbinding, botany, bowling, bowls,boxing
    case breed, brewing
    case bridge,broadcasting,buddhism,building,bullfighting,camping,canals,cards,carpentry
    case chemistry, chess, christian,church_architecture,civil_engineering,clock_making
    case clothing, coffee,commerce,commercial_fishing,complementary_medicine,computing
    case cooking,cosmetics,cricket,crime,croquet,crystallography,currency,cycling
    case dance,dentistry,drink,dyeing,early_modern_history,ecclesiastical
    case ecology,economics,education,egyptian_history,electoral,electrical,electronics,element
    case english_civil_war,falconry,farming,fashion,fencing,film,finance,fire_service,first_world_war
    case fish, food, forestr,freemasonry,french_revolution,furniture,gambling,games,gaming,genetics
    case geography,geology,geometry,glassmaking,golf,goods_vehicles,grammar,greek_histroy,gymnastics
    case hairdressing,handwriting,heraldry,hinduism,history,hockey,honour,horology,horticulture,hotels
    case hunting,insect,instruments,intelligence,invertebrate,islam,jazz,jewellery
    case journalism,judaism,knitting,language,law,leather,linguistics
    case literature,logic,lower_plant,mammal,marriage,martial_arts
    case mathematics,measure,mechanics,medicine,medieval_histor
     case metallurgy,meteorology,microbiology,military,military_history
     case mineral,mining,motor_racing,motoring,music,mountaineering,musical_direction,mythology
    case napoleonic_wars,narcotics,nautical,naval,needlework,numismatics,occult,oceanography
    case office, oil_industry,optics,palaeontology,parliament,pathology,penal
   case people,pharmaceutics,philately,philosophy,phonetics,photography,physics
    case physiology,plant,plumbing,politics, police,popular_music,postal,potter,printing,professions
    case prosody,psychiatry,psychology,publishing,racing,railways,rank,relationships
    case religion, reptile,restaurants,retail,rhetoric, riding,roads,rock,roman_catholic_church
    case roman_history,rowing,royalty,rugby,savoury,scouting,second_world_war
    case sex,shoemaking,sikhism,skateboarding,skating,skiing,smoking,snowboarding,soccer
    case sociology,space,sport,statistics,stock_exchange,surfing,surgery,surveying,sweet,swimming
    case tea, team_sports,technology,telecommunications,tennis,textiles,theatre,theology,timber,title
      case tools, trade_unionism,transport,university,variety,veterinar,video
    case war_of_american_independence,weapons,weightlifting,wine,wrestling,yoga,zoology


}

enum OxfordLanguageRegisters: String{
    case allusive
    case archaic
    case allusively
    case army_slang
    case black_english
    case coarse_slang
    case cant
    case college_slang
    case concrete
    case contemptuous
    case dated
    case depreciative,depreciatively
    case derogatory
    case dialect
    case dismissive
    case disused
    case emphatically
    case especially
    case euphemism
    case euphemistic
    case figurative
    case generally
    case historical
    case humorous, humorously
    case hyperbolical, hyperbolically
    case informal
    case ironic, ironically
    case literal
    case literary
    case military_slang
    case nautical_slang
    case non_standard = "non-standard"
    case nonce_use = "nonce-use"
    case nursery = "nursery"
    case obsolete
    case offensive
    case personified
    case poetic
    case police_slang
    case prison_slang
    case proverb
    case pseuodo_archaic
    case rare,rarely
    case RAF_slang = "R.A.F_slang"
    case rhyming_slang
    case school_slang
    case slang
    case technical
    case temporary
    case theatrical_slang
    case trademark
    case trademark_in_uk
    case trademark_in_us
    case transferred
    case university_slang
    case vulgar_slang
    
    /**
    case children%27S_Slang
    case criminals%27_Slang
    case journalists%27_Slang
    case services%27_Slang
    case showmen%27S_Slang
    **/
}

enum OxfordHTTPStatusCode: Int{
    case Success = 200
    case BadRequest = 400
    case AuthenticationFailed = 403
    case NotFound = 404
    case InternalServerError = 500
    case BadGateway = 502
    case ServiceUnavailable = 503
    case GatewayTimeout = 504
    case OtherStatusCode
    
    func statusCodeMessage() -> String{
        switch self {
        case .AuthenticationFailed:
            return "The request failed due to invalid credentials.Please check that the app_id and app_key are correct, and that the URL you are trying to access is correct. These can be found in the API Credentials page"
        case .BadGateway:
            return "Oxford Dictionaries API is down or being upgraded."
        case .BadRequest:
            return "The request was invalid or cannot be otherwise served. An accompanying error message will explain further.For example, when the filters provided are unknown, the source and target languages in the translation endpoint are the same, or a numeric parameter such as offset and limit in the wordlist endpoint cannot be evaluated as a number."
        case .GatewayTimeout:
            return "The Oxford Dictionaries API servers are up, but the request couldn’t be serviced due to some failure within our stack. Please try again later."
        case .InternalServerError:
            return "Something is broken. Please contact us so the Oxford Dictionaries API team can investigate."
        case .NotFound:
            return "No information available or the requested URL was not found on the server.For example, when the headword could not be found, a region or domain identifier do not exist, or the headword does not contain any attribute that match the filters in the request. It may also be the case that the URL is misspelled or incomplete."
        case .ServiceUnavailable:
            return "The Oxford Dictionaries API servers are up, but overloaded with requests. Please try again later."
        case .Success:
            return "Success!"
        case .OtherStatusCode:
            return "Unknown http status code received"
        default:
            return "Unknown http status code received"
        }
    }
    
}

enum OxfordLexicalCategory: String{
    
    case noun, verb
    case combining_form = "combining form"
    case adjective,adverb
    case conjunction, contraction
    case determiner,idiomatic,interjection
    case numeral, particle, other
    case predeterminer, prefix, suffix 
    case preposition,pronoun,residual
    
    
    
    static let allPartsOfSpeech: [OxfordLexicalCategory] = [
        .noun, .verb, .combining_form, .adjective, .adverb, .conjunction, .contraction,
        .determiner, .idiomatic, .interjection, .numeral, .particle, .other,
        .predeterminer, .prefix,.suffix,.preposition,.pronoun,.residual
    ]
}

enum OxfordGrammaticalFeature: String{
    
    //mass
    case mass
    
    //collectivity
    case collective
    
    //adjective function
    case attributive
    case predicative
    
    //subcategorization
    case intransitive
    case transitive
    
    //auxiliary
    case auxiliary
    
    //residual
    case abbreviation
    case symbol
    
    case interrogative
    case possessive
    case relative
    
    //person
    case third
    
    case proper
    
    //unit structure
    case phrasal
    
    //number
    case singular
    case plural
    
    //numeral
    case cardinal
    case ordinal
    
    //tense
    case past
    case present
    
    //degree
    case comparative
    case positive
    case superlative
    
    //event modality
    case modal
    
    //gender
    case feminine
    
    //mood
    case conditional
    case subjunctive
    
    //non finiteness
    case infinitive
    case past_participle = "past participle"
    case present_participle = "present participle"
    
}


