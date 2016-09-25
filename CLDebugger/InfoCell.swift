//
//  InfoCell.swift
//  CLDebugger
//
//  Created by Taiju Aoki on 2016/09/25.
//  Copyright © 2016年 Taiju Aoki. All rights reserved.
//

import UIKit

protocol InfoCellDelegate: class {
    func infoCell(_ infoCell: InfoCell, didTapInfoButton info: Info)
}

class InfoCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var infoButton: UIButton!

    weak var delegate: InfoCellDelegate?

    var cellInfo: Info!

    func setUp(_ info: Info, num: Int) -> Self {

        cellInfo = info

        switch info.event {
        case .success:
            backgroundColor = UIColor.white
        case .failer:
            backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        case .status:
            backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 1, alpha: 1)
        }

        let indexString = String(format: "%03d", num)

        let formatter = DateFormatter()
        formatter.locale     = Locale.autoupdatingCurrent
        formatter.dateFormat = "MM/dd HH:mm:ss"
        let dateString = formatter.string(from: Date())

        let firstLine = "\(indexString): \(dateString)"
        let attrText = NSMutableAttributedString(string: "\(firstLine)\n\(info.description)")
        let attr = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)]
        let range = _NSRange(location: 0, length: firstLine.characters.count)
        attrText.setAttributes(attr, range: range)

        label.attributedText = attrText

        return self
    }
    @IBAction func didTapInfoButton(_ sender: UIButton) {
        delegate?.infoCell(self, didTapInfoButton: cellInfo)
    }
}
