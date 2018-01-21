//
//  StringExt.swift
//  splitabill
//
//  Created by kan manzawa on 2018/01/06.
//  Copyright © 2018 kan manzawa. All rights reserved.
//

import Foundation

extension String {
    func removeLastString() -> String {
        return String(prefix(self.count - 1))
    }
    
    func regexMatch(pattern: String, options: NSRegularExpression.Options = []) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return false
        }
        let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        return matches.count > 0
    }
    
    func regexReplace(pattern: String, with: String, options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: with)
    }
}
