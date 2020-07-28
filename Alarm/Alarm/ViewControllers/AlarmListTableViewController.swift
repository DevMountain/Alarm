//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Marcus Armstrong on 7/28/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AlarmController.sharedInstance.alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell else { return UITableViewCell() }
        
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        
        cell.alarm = alarm
        cell.delegate = self

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            AlarmController.sharedInstance.delete(alarm: alarm)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destination = segue.destination as? AlarmDetailTableViewController
                else { return }
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            destination.alarm = alarm
        }
    }
}

extension AlarmListTableViewController: SwitchTableViewCellDelegate {
    
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let alarm = cell.alarm else { return }
        AlarmController.sharedInstance.toggleEnabled(for: alarm)
    }
}
