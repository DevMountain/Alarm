//
//  DateHelper.swift
//  Alarm
//
//  Created by James Pacheco on 5/9/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

enum DateHelper {
	
	static var thisMorningAtMidnight: NSDate? {
		let calendar = NSCalendar.currentCalendar()
		let now = NSDate()
		return calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: now, options: [])
	}
	
	static var tomorrowMorningAtMidnight: NSDate? {
		let calendar = NSCalendar.currentCalendar()
		guard let thisMorningAtMidnight = thisMorningAtMidnight else { return nil }
		return calendar.dateByAddingUnit(.Day, value: 1, toDate: thisMorningAtMidnight, options: [])
	}
}