//
//  String+Extension.swift
//  splitabill
//
//  Created by pnk on 2018/01/13.
//  Copyright © 2018 Apoorv Mote. All rights reserved.
//

import Foundation

/*
 text.substring(1...5)
 text.substring(1..<5)
 text.substring(1...)
 text.substring(...5)
*/

extension String {
    
    func substring(_ r: CountableRange<Int>) -> String {
        
        let length = self.count
        let fromIndex = (r.startIndex > 0) ? self.index(self.startIndex, offsetBy: r.startIndex) : self.startIndex
        let toIndex = (length > r.endIndex) ? self.index(self.startIndex, offsetBy: r.endIndex) : self.endIndex
        
        if fromIndex >= self.startIndex && toIndex <= self.endIndex {
            return String(self[fromIndex..<toIndex])
        }
        
        return String(self)
    }
    
    func substring(_ r: CountableClosedRange<Int>) -> String {
        
        let from = r.lowerBound
        let to = r.upperBound
        
        return self.substring(from..<(to+1))
    }
    
    func substring(_ r: CountablePartialRangeFrom<Int>) -> String {
        
        let from = r.lowerBound
        let to = self.count
        
        return self.substring(from..<to)
    }
    
    func substring(_ r: PartialRangeThrough<Int>) -> String {
        
        let from = 0
        let to = r.upperBound
        
        return self.substring(from..<to)
    }
}
