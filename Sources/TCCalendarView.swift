//
//  TCCalendarView.swift
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

let TCCalendarViewDayCellIdentifier = "TCCalendarViewDayCellIdentifier"
let TCCalendarViewWeekdayCellIdentifier = "TCCalendarViewWeekdayCellIdentifier"

let TCCalendarMonthTitleViewIdentifier = "TCCalendarMonthTitleViewIdentifier"

let TCCalendarViewSectionBackgroundKind = "TCCalendarViewSectionBackgroundKind"
let TCCalendarViewSectionBackgroundViewIdentifier = "TCCalendarViewSectionBackgroundViewIdentifier"

let TCCalendarSupplementarySectionViewIdentifier = "TCCalendarSupplementarySectionViewIdentifier"

class TCCalendarView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var sections = [TCCalendarSection]()

    var weekdaySymbols: [String]!
    var numberOfDaysInWeek: Int = 7

    var calendar: Calendar!

    var shouldEnableDateClosure: ((_ date: Date, _ calendar: Calendar) -> (Bool))?
    var shouldSelectDateClosure: ((_ date: Date, _ calendar: Calendar) -> (Bool))?
    var didSelectDateClosure: ((_ date: Date, _ calendar: Calendar) -> ())?

    var cellDecorateClosure: ((_ cell: TCCalendarViewDayCell, _ calendar: Calendar, _ isEnabled: Bool) -> ())?

    var headerView: UIView? {
        didSet {
            updateData()
        }
    }

    var footerView: UIView? {
        didSet {
            updateData()
        }
    }

    var fromDate: Date! {
        didSet {
            updateData()
        }
    }

    var toDate: Date! {
        didSet {
            updateData()
        }
    }

    fileprivate func updateData() {
        if fromDate != nil && toDate != nil {
            sections.removeAll(keepingCapacity: true)

            if let headerView = headerView {
                sections.append(TCCalendarSupplementarySection(view: headerView))
            }

            var dateForMonth = fromDate.firstDateOfMonth(inCalendar: calendar)

            var monthComponents = DateComponents()
            monthComponents.month = 1

            var section = TCCalendarMonthSection(month: dateForMonth, calendar: calendar, numberOfDaysInWeek: numberOfDaysInWeek)
            section.drawSeparatorLine = false

            repeat {
                sections.append(section)

                dateForMonth = calendar.date(byAdding: monthComponents, to: dateForMonth, wrappingComponents: false)!

                section = TCCalendarMonthSection(month: dateForMonth, calendar: calendar, numberOfDaysInWeek: numberOfDaysInWeek)
            } while(dateForMonth.compare(toDate) != ComparisonResult.orderedDescending)

            if let footerView = footerView {
                sections.append(TCCalendarSupplementarySection(view: footerView))
            }
        }

        self.reloadData()
    }

    func registerClasses() {
        self.register(TCCalendarViewDayCell.self, forCellWithReuseIdentifier: TCCalendarViewDayCellIdentifier)
        self.register(TCCalendarViewWeekdayCell.self, forCellWithReuseIdentifier: TCCalendarViewWeekdayCellIdentifier)

        self.register(TCCalendarMonthTitleView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: TCCalendarMonthTitleViewIdentifier)
        self.register(TCCalendarViewSectionBackgroundView.self, forSupplementaryViewOfKind: TCCalendarViewSectionBackgroundKind, withReuseIdentifier: TCCalendarViewSectionBackgroundViewIdentifier)

        self.register(TCCalendarSupplementarySectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: TCCalendarSupplementarySectionViewIdentifier)
    }

    func initialize() {
        registerClasses()

        self.calendar = Calendar.current

        let formatter = DateFormatter()
        formatter.calendar = self.calendar
        self.weekdaySymbols = formatter.veryShortWeekdaySymbols as [String]
        self.numberOfDaysInWeek = self.weekdaySymbols.count

        self.dataSource = self
        self.delegate = self

        self.collectionViewLayout = TCCalendarLayout()
        self.backgroundColor = UIColor.clear

        self.fromDate = Date()
        self.toDate = Date().addingTimeInterval(60 * 60 * 24 * 365)
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath as NSIndexPath).item < numberOfDaysInWeek {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TCCalendarViewWeekdayCellIdentifier, for: indexPath) as! TCCalendarViewWeekdayCell

            cell.weekdayLabel.text = weekdaySymbols[(indexPath as NSIndexPath).item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TCCalendarViewDayCellIdentifier, for: indexPath) as! TCCalendarViewDayCell

            let monthSection = sections[(indexPath as NSIndexPath).section] as! TCCalendarMonthSection

            let weekday = monthSection.weekdayOfFirstDay
            if (indexPath as NSIndexPath).item >= weekday + numberOfDaysInWeek {
                let day = (indexPath as NSIndexPath).item - weekday - numberOfDaysInWeek + 1

                let month = monthSection.month
                var components = calendar.dateComponents([.year, .month], from: month as Date)
                components.day = day

                let realDate = calendar.date(from: components)!

                cell.date = realDate

                cellDecorateClosure?(cell, calendar, shouldEnableDate(realDate))
            }

            return cell
        }
    }

    fileprivate func shouldEnableDate(_ date: Date) -> Bool {
        guard date.compareWithoutTime(self.fromDate, inCalendar: calendar) != .orderedAscending else { return false }
        guard date.compareWithoutTime(self.toDate, inCalendar: calendar) != .orderedDescending else { return false }

        return self.shouldEnableDateClosure?(date, calendar) ?? true
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let monthSection = sections[(indexPath as NSIndexPath).section] as! TCCalendarMonthSection

        let weekday = monthSection.weekdayOfFirstDay
        if (indexPath as NSIndexPath).item < weekday + numberOfDaysInWeek {
            return false
        }

        let cell = collectionView.cellForItem(at: indexPath) as! TCCalendarViewDayCell
        var result = true

        result = result && shouldEnableDate(cell.date as Date)
        result = result && (shouldSelectDateClosure?(cell.date as Date, calendar) ?? true)

        return result
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TCCalendarViewDayCell

        didSelectDateClosure?(cell.date as Date, calendar)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let monthSection = sections[(indexPath as NSIndexPath).section] as? TCCalendarMonthSection {
            if kind == UICollectionElementKindSectionHeader {
                let titleView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TCCalendarMonthTitleViewIdentifier, for: indexPath) as! TCCalendarMonthTitleView
                titleView.titleLabel.text = monthSection.month.longMonthString
                titleView.drawSeparatorLine = monthSection.drawSeparatorLine

                return titleView
            } else {
                let bgView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TCCalendarViewSectionBackgroundViewIdentifier, for: indexPath) as! TCCalendarViewSectionBackgroundView

                bgView.monthLabel.text = monthSection.month.shortMonthString
                bgView.monthLabel.sizeToFit()
                bgView.setNeedsUpdateConstraints()

                return bgView
            }
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TCCalendarSupplementarySectionViewIdentifier, for: indexPath) as! TCCalendarSupplementarySectionView

            if let section = sections[(indexPath as NSIndexPath).section] as? TCCalendarSupplementarySection {
                view.showSupplementaryView(section.view, offset: section.offset)
            }

            return view
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.bounds.width
        let itemWidth = floor(width / CGFloat(numberOfDaysInWeek))
        let itemHeight = itemWidth
        
        let miss = width - itemWidth * CGFloat(numberOfDaysInWeek)
        let halfMiss = floor(miss / 2.0)
        let missRemains = miss - halfMiss * 2.0

        let itemColumnIndex = (indexPath as NSIndexPath).item % numberOfDaysInWeek

        let widthFix = (itemColumnIndex == 0 || itemColumnIndex == numberOfDaysInWeek - 1) ? halfMiss : ((itemColumnIndex == numberOfDaysInWeek / 2) ? missRemains : 0)

        return CGSize(width: itemWidth + widthFix, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0.0, height: sections[section].headerHeight)
    }
}
