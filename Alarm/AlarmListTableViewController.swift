//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by James Pacheco on 5/6/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController, SwitchTableViewCellDelegate, AlarmScheduler {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.sharedInstance.alarms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell ?? SwitchTableViewCell()
        
		cell.alarm = AlarmController.sharedInstance.alarms[(indexPath as NSIndexPath).row]
        cell.delegate = self
        
        return cell
    }
	
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.sharedInstance.alarms[(indexPath as NSIndexPath).row]
            AlarmController.sharedInstance.deleteAlarm(alarm)
            cancelLocalNotification(alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func switchCellSwitchValueChanged(_ cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let alarm = AlarmController.sharedInstance.alarms[(indexPath as NSIndexPath).row]
        AlarmController.sharedInstance.toggleEnabled(alarm)
        if alarm.enabled {
            scheduleLocalNotification(alarm)
        } else {
            cancelLocalNotification(alarm)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlarmDetail" {
			guard let detailVC = segue.destination as? AlarmDetailTableViewController,
			let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.alarm = AlarmController.sharedInstance.alarms[(indexPath as NSIndexPath).row]
        }
    }
    
}
