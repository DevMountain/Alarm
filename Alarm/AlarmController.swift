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
	
	func addAlarm(_ fireTimeFromMidnight: TimeInterval, name: String) -> Alarm {
		let alarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
		alarms.append(alarm)
		saveToPersistentStorage()
		return alarm
	}
	
	func updateAlarm(_ alarm: Alarm, fireTimeFromMidnight: TimeInterval, name: String) {
		alarm.fireTimeFromMidnight = fireTimeFromMidnight
		alarm.name = name
		saveToPersistentStorage()
	}
	
	func deleteAlarm(_ alarm: Alarm) {
		guard let index = alarms.index(of: alarm) else {return}
		alarms.remove(at: index)
		saveToPersistentStorage()
	}
	
	func toggleEnabled(_ alarm: Alarm) {
		alarm.enabled = !alarm.enabled
		saveToPersistentStorage()
	}
	
	// MARK: Load/Save
	
	func saveToPersistentStorage() {
		guard let filePath = type(of: self).persistentAlarmsFilePath else { return }
		NSKeyedArchiver.archiveRootObject(self.alarms, toFile: filePath)
	}
	
	func loadFromPersistentStorage() {
		guard let filePath = type(of: self).persistentAlarmsFilePath else { return }
		guard let alarms = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Alarm] else { return }
		self.alarms = alarms
	}
	
	// MARK: Helpers
	
	static var persistentAlarmsFilePath: String? {
		let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
		guard let documentsDirectory = directories.first as NSString? else { return nil }
		return documentsDirectory.appendingPathComponent("Alarms.plist")
	}
	
	// MARK: Properties
	
	var alarms: [Alarm] = []
}

// MARK: - AlarmScheduler

protocol AlarmScheduler {
	func scheduleLocalNotification(_ alarm: Alarm)
	func cancelLocalNotification(_ alarm: Alarm)
}

extension AlarmScheduler {
	func scheduleLocalNotification(_ alarm: Alarm) {
		let localNotification = UILocalNotification()
		localNotification.userInfo = ["UUID" : alarm.uuid]
		localNotification.alertTitle = "Time's up!"
		localNotification.alertBody = "Your alarm titled \(alarm.name) is done"
		localNotification.fireDate = alarm.fireDate as Date?
		localNotification.repeatInterval = .day
		UIApplication.shared.scheduleLocalNotification(localNotification)
	}
	
	func cancelLocalNotification(_ alarm: Alarm) {
		guard let scheduledNotifications = UIApplication.shared.scheduledLocalNotifications else {return}
		for notification in scheduledNotifications {
			guard let uuid = notification.userInfo?["UUID"] as? String
				, uuid == alarm.uuid else { continue }
			UIApplication.shared.cancelLocalNotification(notification)
		}
	}
}
