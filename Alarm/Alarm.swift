//
//  Alarm.swift
//  Alarm
//
//  Created by James Pacheco on 5/6/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class Alarm: NSObject, NSCoding {
    private let FireTimeFromMidnightKey = "fireTimeFromMidnight"
    private let NameKey = "name"
    private let EnabledKey = "enabled"
    private let UUIDKey = "UUID"
	
    init(fireTimeFromMidnight: NSTimeInterval, name: String, enabled: Bool = true, uuid: String = NSUUID().UUIDString) {
        self.fireTimeFromMidnight = fireTimeFromMidnight
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
    }
	
	// MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        guard let fireTimeFromMidnight = aDecoder.decodeObjectForKey(FireTimeFromMidnightKey) as? NSTimeInterval,
            name = aDecoder.decodeObjectForKey(NameKey) as? String,
            enabled = aDecoder.decodeObjectForKey(EnabledKey) as? Bool,
            uuid = aDecoder.decodeObjectForKey(UUIDKey) as? String else {return nil}
		
        self.fireTimeFromMidnight = fireTimeFromMidnight
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(fireTimeFromMidnight, forKey: FireTimeFromMidnightKey)
        aCoder.encodeObject(name, forKey: NameKey)
        aCoder.encodeObject(enabled, forKey: EnabledKey)
        aCoder.encodeObject(uuid, forKey: UUIDKey)
    }
 
	// MARK: Properties
	
	var fireTimeFromMidnight: NSTimeInterval
	var name: String
	var enabled: Bool
	let uuid: String
	
	var fireDate: NSDate? {
		guard let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else {return nil}
		let fireDateFromThisMorning = NSDate(timeInterval: fireTimeFromMidnight, sinceDate: thisMorningAtMidnight)
		return fireDateFromThisMorning
	}
	
	var fireTimeAsString: String {
		let fireTimeFromMidnight = Int(self.fireTimeFromMidnight)
		var hours = fireTimeFromMidnight/60/60
		let minutes = (fireTimeFromMidnight - (hours*60*60))/60
		if hours >= 13 {
			return String(format: "%2d:%02d PM", arguments: [hours - 12, minutes])
		} else if hours >= 12 {
			return String(format: "%2d:%02d PM", arguments: [hours, minutes])
		} else {
			if hours == 0 {
				hours = 12
			}
			return String(format: "%2d:%02d AM", arguments: [hours, minutes])
		}
	}
}

// MARK: - Equatable

func ==(lhs: Alarm, rhs: Alarm) -> Bool {
    return lhs.uuid == rhs.uuid
}