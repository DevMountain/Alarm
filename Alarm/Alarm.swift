//
//  Alarm.swift
//  Alarm
//
//  Created by Josh & Erica on 2/6/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import Foundation

class Alarm: Equatable{
    
    private let FireTimeFromMidnightKey = "fireTimeFromMidnight"
    private let Namekey = "name"
    private let EnableKey = "enableKey"
    private let UUIDKey = "UUID"
    
    var fireTimeFromMidnight: TimeInterval
    var name: String
    var enabled: Bool
    let uuid: String
    
    init(fireTimeFromMidnight: TimeInterval, name: String, enabled: Bool = true, uuid: String = UUID().uuidString){
        
        self.fireTimeFromMidnight = fireTimeFromMidnight
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
        
    }
    
    
    
    
    var fireDate: Date? {
        guard let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else {return nil}
        let fireDateFromThisMorning = Date(timeInterval: fireTimeFromMidnight, since: thisMorningAtMidnight as Date)
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

func ==(lhs: Alarm, rhs: Alarm) -> Bool {
    return lhs.uuid == rhs.uuid
}







