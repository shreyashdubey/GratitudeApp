//
//  GratitudeFonts.swift
//  Gratitude
//
//  Created by Bhavesh Singh on 9/23/23.
//

import Foundation
import SwiftUI

struct GratitudeFonts {
    static let regular =  "Inter-Regular"
    static let Medium =  "Inter-Medium"
    static let Semibold =  "Inter-SemiBold"
    static let bold = "Inter-Bold"
    static let extraBold = "Inter-ExtraBold"
}

enum CustomGratitudeFont: String {
    case regular =  "Inter-Regular"
    case Medium =  "Inter-Medium"
    case Semibold =  "Inter-SemiBold"
    case bold = "Inter-Bold"
    case extraBold = "Inter-ExtraBold"
}

extension Font.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle: return 50
        case .title: return 30//was20
        case .title2: return 25
        case .title3: return 20
        case .headline: return 18//was16
        case .subheadline: return 16//was 14
        case .body: return 16//was10.7
        case .callout: return 18//was12
        case .footnote: return 14
        case .caption: return 12
        case .caption2: return 10//was8
        @unknown default:
            return 8
        }
    }
}

//Usage: Text("").font(.custom(.regular, relativeTo: .body))
extension Font {
    static func inter(_ font: CustomGratitudeFont, relativeTo style: Font.TextStyle) -> Font {
        custom(font.rawValue, size: style.size, relativeTo: style)
    }
    
    static func inter(_ font: CustomGratitudeFont, relativeTo style: CGFloat) -> Font {
        custom(font.rawValue, size: style, relativeTo: .body)
    }
}

//Text("").font(.museFont)
extension Font {
    static let InterRegular = inter(.regular, relativeTo: .body)
    static let InterMedium = inter(.bold, relativeTo: .largeTitle)
}


extension UIFont {
  class func preferredFont(from font: Font) -> UIFont {
      let style: UIFont.TextStyle
      switch font {
        case .largeTitle:  style = .largeTitle
        case .title:       style = .title1
        case .title2:      style = .title2
        case .title3:      style = .title3
        case .headline:    style = .headline
        case .subheadline: style = .subheadline
        case .callout:     style = .callout
        case .caption:     style = .caption1
        case .caption2:    style = .caption2
        case .footnote:    style = .footnote
        case .body: fallthrough
        default:           style = .body
     }
     return  UIFont.preferredFont(forTextStyle: style)
   }
}

extension UIFont {
    static func Inter(_ font: CustomGratitudeFont, relativeTo textStyle: UIFont.TextStyle) -> UIFont {
        let baseFont = UIFont.preferredFont(forTextStyle: textStyle)
        let size = baseFont.pointSizeForInterStyle(font)
        return UIFont(name: font.rawValue, size: size) ?? baseFont
    }
    
    static func Inter(_ font: CustomGratitudeFont, relativeTo size: CGFloat) -> UIFont {
        let baseFont = UIFont.preferredFont(forTextStyle: .body)
        let fontSize = baseFont.pointSizeForInterStyle(font) * size
        return UIFont(name: font.rawValue, size: fontSize) ?? baseFont
    }
}

private extension UIFont {
    func pointSizeForInterStyle(_ font: CustomGratitudeFont) -> CGFloat {
        let bodyFont = UIFont.preferredFont(forTextStyle: .body)
        let bodyPointSize = bodyFont.pointSize
        switch font {
        case .regular: return bodyPointSize
        case .Medium: return bodyPointSize * 1.2
        case .Semibold: return bodyPointSize * 1.4
        case .bold: return bodyPointSize
        case .extraBold: return bodyPointSize 
        }
    }
}
