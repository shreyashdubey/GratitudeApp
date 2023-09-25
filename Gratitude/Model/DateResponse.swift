//
//  DayResponse.swift
//  Gratitude
//
//  Created by Bhavesh Singh on 9/23/23.
//

import Foundation

struct DateResponse: Codable, DictionaryEncodable, Identifiable{
    var id = UUID()
    let text: String?
    let author: String?
    let uniqueId: String?
    let type: String?
    let dzType: String?
    let language: String?
    let bgImageUrl: String?
    let theme: String?
    let themeTitle: String?
    let articleUrl: String?
    let dzImageUrl: String?
    let primaryCTAText: String?
    let sharePrefix: String?
    
    enum CodingKeys: String, CodingKey {
            case text
            case author
            case uniqueId
            case type
            case dzType
            case language
            case bgImageUrl
            case theme
            case themeTitle
            case articleUrl
            case dzImageUrl
            case primaryCTAText
            case sharePrefix
        }
}

