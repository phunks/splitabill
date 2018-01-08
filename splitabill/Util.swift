//
//  Util.swift
//  edit data demo
//
//  Created by pnk on 2018/01/06.
//  Copyright © 2018 Apoorv Mote. All rights reserved.
//

//import Foundation
import UIKit

private let formatter: NumberFormatter = NumberFormatter()

public extension Int {
    
    private func formattedString(style: NumberFormatter.Style, localeIdentifier: String) -> String {
        formatter.numberStyle = style
        formatter.locale = Locale(identifier: localeIdentifier)
        return formatter.string(from: self as NSNumber) ?? ""
    }
    
    // カンマ区切りString
    // 1,000,000
    var formattedJPString: String {
        return formattedString(style: .decimal, localeIdentifier: "ja_JP")
    }
    
    // 日本円表記のString
    // ¥1,000,000
    var JPYString: String {
        return formattedString(style: .currency, localeIdentifier: "ja_JP")
    }
    
    // USドル表記のString
    // $1,000,000.00
    var USDString: String {
        return formattedString(style: .currency, localeIdentifier: "en_US")
    }
}
