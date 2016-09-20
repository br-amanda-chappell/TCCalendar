//
//  ViewController.swift
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

class ViewController: UIViewController {

    @IBOutlet var calendarView: TCCalendarView!
    
    var startDate: Date?
    var endDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        TCCalendarMonthTitleView.appearance().setFont(UIFont.boldSystemFont(ofSize: 20))
        TCCalendarMonthTitleView.appearance().setTextColor(UIColor.blue)
        TCCalendarMonthTitleView.appearance().setSeparatorColor(UIColor.red)

        TCCalendarViewSectionBackgroundView.appearance().setTextColor(UIColor.yellow)

        TCCalendarViewWeekdayCell.appearance().setFont(UIFont.boldSystemFont(ofSize: 12))
        TCCalendarViewWeekdayCell.appearance().setTextColor(UIColor.orange)

        calendarView.fromDate = Date()
        calendarView.toDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 180)

        let headerLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 100.0))
        headerLabel.font = UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)
        headerLabel.text = "Calendar Header"
        calendarView.headerView = headerLabel

        let footerLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 50.0))
        footerLabel.font = UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)
        footerLabel.text = "Calendar Footer"
        calendarView.footerView = footerLabel

        calendarView.cellDecorateClosure = { cell, calendar, isEnabled in
            if !isEnabled {
                cell.dayLabel.textColor = UIColor.lightGray
                return
            }
            
            var color: UIColor = UIColor.clear
            
            if let startDate = self.startDate {
                if cell.date == startDate {
                    color = UIColor.orange
                }

                if let endDate = self.endDate {
                    if cell.date == endDate {
                        if startDate == endDate {
                            color = UIColor.purple
                        } else {
                            color = UIColor.blue
                        }
                    } else if cell.date.compare(startDate) == .orderedDescending && cell.date.compare(endDate) == .orderedAscending {
                        color = UIColor.gray
                    }
                }
            }

            if cell.date.compareWithoutTime(Date(), inCalendar: calendar) == .orderedSame {
                cell.dayLabel.font = UIFont.boldSystemFont(ofSize: 18)
            }

            let view = UIView(frame: cell.bounds)
            view.backgroundColor = color
            cell.backgroundView = view
            
            cell.dayLabel.textColor = UIColor.black
        }

        calendarView.shouldEnableDateClosure = { date, calendar in
            return date.compareWithoutTime(Date(), inCalendar: calendar) != ComparisonResult.orderedAscending
        }
//
//        calendarView.shouldSelectDateClosure = { date, calendar in
//            return date.compareWithoutTime(NSDate(), inCalendar: calendar) != NSComparisonResult.OrderedSame
//        }
        
        calendarView.didSelectDateClosure = { date, calendar in
            if let startDate = self.startDate {
                if self.endDate == nil {
                    if date.compareWithoutTime(startDate, inCalendar: calendar) == ComparisonResult.orderedAscending {
                        self.startDate = date as Date
                    } else {
                        self.endDate = date as Date
                    }
                } else {
                    self.startDate = date as Date
                    self.endDate = nil
                }
            } else {
                self.startDate = date as Date
            }
            
            self.calendarView.reloadData()
        }
    }
}

extension TCCalendarSupplementarySection {
    var offset: UIOffset {
        return UIOffsetMake(15.0, 15.0)
    }
}
