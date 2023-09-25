//
//  String.swift
//  Gratitude
//
//  Created by Shreyash on 9/23/23.
//

import Foundation
extension String {
    var unescaped: String {
        let entities = ["\0": "\\0",
                        "\t": "\\t",
                        "\n": "\\n",
                        "\r": "\\r",
                        "\"": "\\\"",
                        "\'": "\\'",
        ]
        
        return entities
            .reduce(self) { (string, entity) in
                string.replacingOccurrences(of: entity.value, with: entity.key)
            }
            .replacingOccurrences(of: "\\\\(?!\\\\)", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\\\", with: "\\").replacingOccurrences(of: #"\/"#, with: "/")
        
    }
    
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
    
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
    
    static func randomAlphanumericString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    static func randomAlphabeticString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
