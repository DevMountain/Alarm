//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by James Pacheco on 5/6/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController, SwitchTableViewCellDelegate, AlarmScheduler {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.sharedInstance.alarms.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("alarmCell", forIndexPath: indexPath) as? SwitchTableViewCell ?? SwitchTableViewCell()
        
		cell.alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        cell.delegate = self
        
        return cell
    }
	
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            AlarmController.sharedInstance.deleteAlarm(alarm)
            cancelLocalNotification(alarm)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(cell) else {return}
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        AlarmController.sharedInstance.toggleEnabled(alarm)
        if alarm.enabled {
            scheduleLocalNotification(alarm)
        } else {
            cancelLocalNotification(alarm)
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toAlarmDetail" {
			guard let detailVC = segue.destinationViewController as? AlarmDetailTableViewController,
			let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        }
    }
    
}
