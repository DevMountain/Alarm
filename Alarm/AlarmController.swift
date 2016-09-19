//
//  AlarmController.swift
//  Alarm
//
//  Created by James Pacheco on 5/9/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation
import UIKit

class AlarmController {
	
	static let sharedInstance = AlarmController()
	
	init() {
		loadFromPersistentStorage()
	}
	
	// MARK: Model Controller Methods
	
	func addAlarm(fireTimeFromMidnight: NSTimeInterval, name: String) -> Alarm {
		let alarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
		alarms.append(alarm)
		saveToPersistentStorage()
		return alarm
	}
	
	func updateAlarm(alarm: Alarm, fireTimeFromMidnight: NSTimeInterval, name: String) {
		alarm.fireTimeFromMidnight = fireTimeFromMidnight
		alarm.name = name
		saveToPersistentStorage()
	}
	
	func deleteAlarm(alarm: Alarm) {
		guard let index = alarms.indexOf(alarm) else {return}
		alarms.removeAtIndex(index)
		saveToPersistentStorage()
	}
	
	func toggleEnabled(alarm: Alarm) {
		alarm.enabled = !alarm.enabled
		saveToPersistentStorage()
	}
	
	// MARK: Load/Save
	
	func saveToPersistentStorage() {
		guard let filePath = self.dynamicType.persistentAlarmsFilePath else { return }
		NSKeyedArchiver.archiveRootObject(self.alarms, toFile: filePath)
	}
	
	func loadFromPersistentStorage() {
		guard let filePath = self.dynamicType.persistentAlarmsFilePath else { return }
		guard let alarms = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [Alarm] else { return }
		self.alarms = alarms
	}
	
	// MARK: Helpers
	
	static var persistentAlarmsFilePath: String? {
		let directories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true)
		guard let documentsDirectory = directories.first as NSString? else { return nil }
		return documentsDirectory.stringByAppendingPathComponent("Alarms.plist")
	}
	
	// MARK: Properties
	
	var alarms: [Alarm] = []
}

// MARK: - AlarmScheduler

protocol AlarmScheduler {
	func scheduleLocalNotification(alarm: Alarm)
	func cancelLocalNotification(alarm: Alarm)
}

extension AlarmScheduler {
	func scheduleLocalNotification(alarm: Alarm) {
		let localNotification = UILocalNotification()
		localNotification.userInfo = ["UUID" : alarm.uuid]
		localNotification.alertTitle = "Time's up!"
		localNotification.alertBody = "Your alarm titled \(alarm.name) is done"
		localNotification.fireDate = alarm.fireDate
		localNotification.repeatInterval = .Day
		UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
	}
	
	func cancelLocalNotification(alarm: Alarm) {
		guard let scheduledNotifications = UIApplication.sharedApplication().scheduledLocalNotifications else {return}
		for notification in scheduledNotifications {
			guard let uuid = notification.userInfo?["UUID"] as? String
				where uuid == alarm.uuid else { continue }
			UIApplication.sharedApplication().cancelLocalNotification(notification)
		}
	}
}
