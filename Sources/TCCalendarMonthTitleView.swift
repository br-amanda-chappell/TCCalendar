//
//  TCCalendarMonthTitleView.swift
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

class TCCalendarMonthTitleView: UICollectionReusableView {
    var titleLabel: UILabel!

    var separatorLineColor: UIColor = UIColor.black
    var drawSeparatorLine: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.drawSeparatorLine = true
    }
    
    func initialize() {
        self.backgroundColor = UIColor.clear

        initTitleLabel()
    }

    fileprivate func initTitleLabel() {
        titleLabel = UILabel(frame: self.bounds)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(titleLabel)

        let views = ["titleLabel": titleLabel]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLabel]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[titleLabel]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }

    override func draw(_ rect: CGRect) {
        guard drawSeparatorLine else { return }

        let context = UIGraphicsGetCurrentContext()

        context?.setAllowsAntialiasing(false)
        context?.setStrokeColor(separatorLineColor.cgColor)
        context?.setLineWidth(1.0)
        context?.move(to: CGPoint(x: 0.0, y: 0.0))
        context?.addLine(to: CGPoint(x: self.bounds.width, y: 0.0))
        context?.strokePath()
        context?.setAllowsAntialiasing(true)
    }
}

extension TCCalendarMonthTitleView {
    dynamic func setFont(_ font: UIFont) {
        self.titleLabel?.font = font
    }

    dynamic func setTextColor(_ color: UIColor) {
        self.titleLabel?.textColor = color
    }

    dynamic func setSeparatorColor(_ color: UIColor) {
        separatorLineColor = color
    }
}
