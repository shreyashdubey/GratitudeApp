//
//  DictionaryEncodable.swift
//  Gratitude
//
//  Created by Shreyash on 9/23/23.
//

import Foundation
import Foundation
import SwiftUI
import UIKit
import AVFoundation

//converting struct to dictionary
protocol DictionaryEncodable: Encodable {}
extension DictionaryEncodable {
    func dictionary() -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        guard let json = try? encoder.encode(self),
              let dict = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
            return [String: Any]()
        }
        return dict
    }
    
    func jsonString() -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        if let jsonData = try? encoder.encode(self), let jsonToString = String(data: jsonData, encoding: .utf8) {
            return jsonToString
       }
        return ""
    }
}
