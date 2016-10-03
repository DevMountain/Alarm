//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by James Pacheco on 5/6/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController, AlarmScheduler {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateViews()
	}
	
	// MARK: Actions
	
	@IBAction func saveButtonTapped(_ sender: AnyObject) {
		guard let title = alarmTitleTextField.text,
			let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else { return }
		let timeIntervalSinceMidnight = alarmDatePicker.date.timeIntervalSince(thisMorningAtMidnight as Date)
		if let alarm = alarm {
			AlarmController.sharedInstance.updateAlarm(alarm, fireTimeFromMidnight: timeIntervalSinceMidnight, name: title)
			cancelLocalNotification(alarm)
			scheduleLocalNotification(alarm)
		} else {
			let alarm = AlarmController.sharedInstance.addAlarm(timeIntervalSinceMidnight, name: title)
			self.alarm = alarm
			scheduleLocalNotification(alarm)
		}
		let _ = navigationController?.popViewController(animated: true)
	}
	
	@IBAction func enableButtonTapped(_ sender: AnyObject) {
		guard let alarm = alarm else {return}
		AlarmController.sharedInstance.toggleEnabled(alarm)
		if alarm.enabled {
			scheduleLocalNotification(alarm)
		} else {
			cancelLocalNotification(alarm)
		}
		updateViews()
	}
	
	// MARK: Actions
	
	private func updateViews() {
		guard let alarm = alarm,
			let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else {
				enableButton.isHidden = true
				return
		}
		
		alarmDatePicker.setDate(Date(timeInterval: alarm.fireTimeFromMidnight, since: thisMorningAtMidnight), animated: false)
		alarmTitleTextField.text = alarm.name
		
		enableButton.isHidden = false
		if alarm.enabled {
			enableButton.setTitle("Disable", for: UIControlState())
			enableButton.setTitleColor(.white, for: UIControlState())
			enableButton.backgroundColor = .red
		} else {
			enableButton.setTitle("Enable", for: UIControlState())
			enableButton.setTitleColor(.blue, for: UIControlState())
			enableButton.backgroundColor = .gray
		}
		
		self.title = alarm.name
	}
	
	// MARK: Properties
	
	var alarm: Alarm? {
		didSet {
			updateViews()
		}
	}
	
	@IBOutlet weak var alarmDatePicker: UIDatePicker!
	@IBOutlet weak var alarmTitleTextField: UITextField!
	@IBOutlet weak var enableButton: UIButton!
}
