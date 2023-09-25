//
//  Data.swift
//  Gratitude
//
//  Created by Bhavesh Singh on 9/23/23.
//

import Foundation

extension Data {
    var stringEncoding: String.Encoding? {
        var nsString: NSString?
        guard case let rawValue = NSString.stringEncoding(for: self, encodingOptions: nil, convertedString: &nsString, usedLossyConversion: nil), rawValue != 0 else { return nil }
        return .init(rawValue: rawValue)
    }
}