//
//  ViewController.swift
//  CLDebugger
//
//  Created by Taiju Aoki on 2016/09/23.
//  Copyright © 2016年 Taiju Aoki. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ManagerDelegate, InfoCellDelegate {

    lazy private var realm = try! Realm()
    private var infoDataArray: Results<InfoData>!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        infoDataArray = realm.objects(InfoData.self).sorted(byProperty: "insertDate", ascending: false)

        Manager.sharedInstance.delegate = self
        Manager.sharedInstance.requestAlwaysAuthorization(Prefix.locationInfoType)
        Manager.sharedInstance.start(Prefix.locationInfoType)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView() // delete separaters between empty cells
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension

        setLocation()
    }

    func manager(_ manager: Manager, didUpdateInfo info: Info) {
        DispatchQueue.main.async {
            try! self.realm.write {
                self.realm.add(info.toInfoData())
            }
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as! InfoCell
        cell.delegate = self

        let info = infoDataArray[indexPath.row].toInfo()
        let num = infoDataArray.count - indexPath.row

        return cell.setUp(info, num: num)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = infoDataArray[indexPath.row].toInfo()
        if let location = info.location {
            setLocation(location)
        }
    }

    @IBAction func deleteAll(_ sender: UIBarButtonItem) {
        try! realm.write {
            realm.deleteAll()
        }
        tableView.reloadData()
    }

    func infoCell(_ infoCell: InfoCell, didTapInfoButton info: Info) {
        performSegue(withIdentifier: "toDetail", sender: info)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toDetail" {
            let vc = segue.destination as! DetailViewController
            vc.detailDescription = (sender as! Info).description
        }
    }

    func setLocation(_ location: CLLocationCoordinate2D? = nil) {

        // 縮尺を設定
        var region = mapView.region
        region.span.latitudeDelta = 0.001
        region.span.longitudeDelta = 0.001
        mapView.setRegion(region, animated: false)

        // 全てのピンを削除
        mapView.removeAnnotations(mapView.annotations)

        if let coordinate = location {
            // 緯度・軽度を設定
            mapView.setCenter(coordinate, animated: false)
            // ピンを刺す
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }

}
