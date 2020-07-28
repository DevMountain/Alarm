//
//  AlarmController.swift
//  Alarm
//
//  Created by Marcus Armstrong on 7/28/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import Foundation

class AlarmController {
    
    static let sharedInstance = AlarmController()
    
    var alarms: [Alarm] = []
    
    var mockAlarms: [Alarm] {
        return [
            Alarm(name: "Good Morning", fireDate: Date(), enabled: true),
            Alarm(name: "Clock In!", fireDate: Date(), enabled: true),
            Alarm(name: "Lunch", fireDate: Date(), enabled: false),
            Alarm(name: "Clock Out!", fireDate: Date(), enabled: true),
            Alarm(name: "Dinner", fireDate: Date(), enabled: false),
            Alarm(name: "Bed Time", fireDate: Date(), enabled: true)
        ]
    }
    
    init() {
        self.alarms = mockAlarms
    }
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) -> Alarm {
        let newAlarm = Alarm(name: name, fireDate: fireDate, enabled: enabled)
        alarms.append(newAlarm)
        return newAlarm
    }
    
    func updateAlarm(alarm: Alarm, name: String, fireDate: Date, enabled: Bool) {
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.enabled = enabled
    }
    
    func delete(alarm: Alarm) {
        guard let index = alarms.firstIndex(of: alarm) else { return }
        alarms.remove(at: index)
    }
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled.toggle()
    }
}
