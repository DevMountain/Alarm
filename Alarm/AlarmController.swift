//
//  AlarmController.swift
//  Alarm
//
//  Created by Josh & Erica on 2/6/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import Foundation

class AlarmController {
    
    var alarmArray: [Alarm] = []
    
    static let shared = AlarmController()
    
    
    func addAlarm(fireTimeFromMidnight: TimeInterval, name: String) {
        let alarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarmArray.append(alarm)
    }
    
    func delete(alarm: Alarm) {
        if let index = alarmArray.index(of: alarm) {
            alarmArray.remove(at: index)
        }
    }
    
    
    
}
