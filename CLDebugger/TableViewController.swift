//
//  TableViewController.swift
//  CLDebugger
//
//  Created by Taiju Aoki on 2016/09/23.
//  Copyright © 2016年 Taiju Aoki. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, ManagerDelegate {

    private var infoArray = [LocationInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        Manager.sharedInstance.requestAlwaysAuthorization(Prefix.locationInfoType)
        Manager.sharedInstance.start(Prefix.locationInfoType)
        Manager.sharedInstance.delegate = self

        tableView.tableFooterView = UIView() // delete separaters between empty cells
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    func manager(_ manager: Manager, didUpdateInfo locationInfo: LocationInfo) {
        infoArray.insert(locationInfo, at: 0)
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
            cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }

        let indexString = String(format: "%03d", infoArray.count - indexPath.row)
        cell.textLabel!.text = "\(indexString)\n\(info.description)"
        // storyboard からの指定で効かないためコードで指定
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = .byWordWrapping

        return cell
    }


}
