//
//  ViewController.swift
//  RuuviTag
//
//  Created by Rinat Enikeev on 8/4/19.
//  Copyright © 2019 Rinat Enikeev. All rights reserved.
//

import UIKit
import BTKit

class ViewController: UITableViewController {

    private var ruuviTagsSet = Set<RuuviTag>()
    private var ruuviTags = [RuuviTag]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BTKit.scanner.scan(self) { (observer, device) in
            if let ruuviTag = device.ruuvi?.tag {
                observer.ruuviTagsSet.update(with: ruuviTag)
            }
        }
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.ruuviTags = self.ruuviTagsSet.sorted(by: { $0.rssi < $1.rssi })
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ruuviTags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellReuseIdentifier", for: indexPath) as! TableViewCell
        let tag = ruuviTags[indexPath.row]
        cell.uuidValueLabel.text = tag.uuid
        cell.temperatureValueLabel.text = "\(tag.celsius ?? 0) °C"
        cell.humidityValueLabel.text = "\(tag.humidity ?? 0) %"
        cell.pressureValueLabel.text = "\(tag.pressure ?? 0) hPa"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

