//
//  NSDate+month.swift
//  TCCalendar
//
//  Copyright (c) 2015 Cyril Wei
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

extension Date {
    func firstDateOfMonth(inCalendar calendar: Calendar) -> Date {
        var components = (calendar as NSCalendar).components([.year, .month, .day], from: self)

        components.day = 1

        return calendar.date(from: components)!
    }

    func lastDateOfMonth(inCalendar calendar: Calendar) -> Date {
        var components = (calendar as NSCalendar).components([.year, .month, .day], from: self)

        components.day = 0
        if let month = components.month {
            components.month = month + 1
        } else {
            components.month = 1
        }

        return calendar.date(from: components)!
    }

    func daysOfMonth(inCalendar calendar: Calendar) -> Int {
        let components = (calendar as NSCalendar).components(.day, from: self.firstDateOfMonth(inCalendar: calendar), to: self.lastDateOfMonth(inCalendar: calendar), options: [])

        return components.day! + 1
    }

    var longMonthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }

    var shortMonthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: self)
    }

    var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }

    func compareWithoutTime(_ anotherDate: Date, inCalendar calendar: Calendar) -> ComparisonResult {
        let components = (calendar as NSCalendar).components([.year, .month, .day], from: self)
        let anotherComponents = (calendar as NSCalendar).components([.year, .month, .day], from: anotherDate)

        let dateOnly = calendar.date(from: components)!
        let anotherDateOnly = calendar.date(from: anotherComponents)!

        return dateOnly.compare(anotherDateOnly)
    }
}
