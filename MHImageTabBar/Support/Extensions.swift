//  TKLBSDB/PRAYRDB Swift Extensions
//  Copyright (c) 2010-2015 Bill Weinman. All rights reserved.

import Foundation
import UIKit




extension NSUserDefaults {
    class func groupUserDefaults() -> NSUserDefaults {
        return NSUserDefaults(suiteName: "group.\(ComplexConstants.bundle())")!
    }
}

extension Double {
    func formattedPercentage() -> String {
        let percentageFormatter = NSNumberFormatter()
        percentageFormatter.numberStyle = .PercentStyle
        return percentageFormatter.stringFromNumber(round(self) / 100.0) ?? "\(self)%"
    }
}

extension NSRange {
    func toRange(string: String) -> Range<String.Index> {
        let startIndex = string.startIndex.advancedBy(location)
        let endIndex = startIndex.advancedBy(length)
        return startIndex..<endIndex
    }
}

extension NSDate {
    var startOfDay: NSDate {
        return NSCalendar.currentCalendar().startOfDayForDate(self)
    }
    
    var startOfTomorrow: NSDate? {
        let components = NSDateComponents()
        components.day = 1
        return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: startOfDay, options: NSCalendarOptions())
    }
}

extension String {
    func trunc(length: Int, trailing: String? = "...") -> String {
        if self.characters.count > length {
            return self.substringToIndex(self.startIndex.advancedBy(length)) + (trailing ?? "")
        } else {
            return self
        }
    }
}


