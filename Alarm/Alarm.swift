//
//  Alarm.swift
//  Alarm
//
//  Created by James Pacheco on 5/6/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class Alarm: NSObject {
    
    init(fireTimeFromMidnight: TimeInterval, name: String, enabled: Bool = true, uuid: String = UUID().uuidString) {
        self.fireTimeFromMidnight = fireTimeFromMidnight
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
    }
    
    // MARK: Properties
    
    var fireTimeFromMidnight: TimeInterval
    var name: String
    var enabled: Bool
    let uuid: String
    
    var fireDate: Date? {
        guard let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else { return nil }
        let fireTimeInMinutes = Int(fireTimeFromMidnight / 60)
        let fireTimeInSeconds = TimeInterval(fireTimeInMinutes * 60)
        let fireDateFromThisMorning = Date(timeInterval: fireTimeInSeconds, since: thisMorningAtMidnight)
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
