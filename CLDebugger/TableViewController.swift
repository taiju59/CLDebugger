//
//  TableViewController.swift
//  CLDebugger
//
//  Created by Taiju Aoki on 2016/09/23.
//  Copyright © 2016年 Taiju Aoki. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, ManagerDelegate {

    private var infoArray = [Info]()

    override func viewDidLoad() {
        super.viewDidLoad()
        Manager.sharedInstance.delegate = self
        Manager.sharedInstance.requestAlwaysAuthorization(Prefix.locationInfoType)
        Manager.sharedInstance.start(Prefix.locationInfoType)

        tableView.tableFooterView = UIView() // delete separaters between empty cells
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    func manager(_ manager: Manager, didUpdateInfo info: Info) {
        infoArray.insert(info, at: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        tableView.endUpdates()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Basic")
        let info = infoArray[indexPath.row]

        switch info.event {
        case .success:
            cell.backgroundColor = UIColor.white
        case .failer:
            cell.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        case .status:
            cell.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 1, alpha: 1)
        }

        let indexString = String(format: "%03d", infoArray.count - indexPath.row)

        let formatter = DateFormatter()
        formatter.locale     = Locale.autoupdatingCurrent
        formatter.dateFormat = "MM/dd HH:mm:ss"
        let dateString = formatter.string(from: Date())

        let firstLine = "\(indexString): \(dateString)"
        let attrText = NSMutableAttributedString(string: "\(firstLine)\n\(info.description)")
        let attr = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)]
        let range = _NSRange(location: 0, length: firstLine.characters.count)
        attrText.setAttributes(attr, range: range)

        cell.textLabel!.attributedText = attrText
        // storyboard からの指定で効かないためコードで指定
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = .byWordWrapping

        return cell
    }

    @IBAction func deleteAll(_ sender: UIBarButtonItem) {
        infoArray = []
        tableView.reloadData()
    }

}
