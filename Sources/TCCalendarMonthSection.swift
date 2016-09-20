//
//  TCCalendarMonthSection.swift
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

class TCCalendarMonthSection: TCCalendarSection {
    var month: Date
    var calendar: Calendar
    var numberOfDaysInWeek: Int = 7

    var weekdayOfFirstDay: Int
    var drawSeparatorLine: Bool = true

    var numberOfItems: Int {
        return month.daysOfMonth(inCalendar: calendar) + weekdayOfFirstDay + numberOfDaysInWeek
    }

    var hasDecorationView: Bool {
        return true
    }

    init(month: Date, calendar: Calendar, numberOfDaysInWeek: Int) {
        self.month = month
        self.calendar = calendar
        self.numberOfDaysInWeek = numberOfDaysInWeek

        let weekdayComponents = (calendar as NSCalendar).components(.weekday, from: month)
        self.weekdayOfFirstDay = weekdayComponents.weekday! - 1
    }
}
