//
//  TCCalendarSupplementarySectionView.swift
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

class TCCalendarSupplementarySectionView: UICollectionReusableView {
    override func prepareForReuse() {
        super.prepareForReuse()

        for view in self.subviews {
            view.removeFromSuperview()
        }
    }

    func showSupplementaryView(_ view: UIView, offset: UIOffset) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        let views = ["supplementaryView": view]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(offset.horizontal)-[supplementaryView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(offset.vertical)-[supplementaryView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
}
