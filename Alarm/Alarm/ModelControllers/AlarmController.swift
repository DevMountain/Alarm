//
//  AlarmController.swift
//  Alarm
//
//  Created by Marcus Armstrong on 7/28/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler: class {
    func cancelUserNotifications(for alarm: Alarm)
    func scheduleUserNotifications(for alarm: Alarm)
}

class AlarmController: AlarmScheduler {
    
    static let sharedInstance = AlarmController()
    
    var alarms: [Alarm] = []
    
//    var mockAlarms: [Alarm] {
//        return [
//            Alarm(name: "Good Morning", fireDate: Date(), enabled: true),
//            Alarm(name: "Clock In!", fireDate: Date(), enabled: true),
//            Alarm(name: "Lunch", fireDate: Date(), enabled: false),
//            Alarm(name: "Clock Out!", fireDate: Date(), enabled: true),
//            Alarm(name: "Dinner", fireDate: Date(), enabled: false),
//            Alarm(name: "Bed Time", fireDate: Date(), enabled: true)
//        ]
//    }
    
    init() {
        loadFromPersistentStore()
//        self.alarms = mockAlarms
    }
    
    private static var fileURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "Alarm.json"
        let url = documentDirectory.appendingPathComponent(fileName)
        return url
    }
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) -> Alarm {
        let newAlarm = Alarm(name: name, fireDate: fireDate, enabled: enabled)
        alarms.append(newAlarm)
        if newAlarm.enabled {
            scheduleUserNotifications(for: newAlarm)
        } else {
            cancelUserNotifications(for: newAlarm)
        }
        saveToPersistentStore()
        return newAlarm
    }
    
    func updateAlarm(alarm: Alarm, name: String, fireDate: Date, enabled: Bool) {
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.enabled = enabled
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
        saveToPersistentStore()
    }
    
    func delete(alarm: Alarm) {
        guard let index = alarms.firstIndex(of: alarm) else { return }
        cancelUserNotifications(for: alarm)
        alarms.remove(at: index)
        saveToPersistentStore()
    }
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled.toggle()
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        let jsonEncoder = JSONEncoder()
        
        do {
            let data = try jsonEncoder.encode(AlarmController.sharedInstance.alarms)
            try data.write(to: AlarmController.fileURL)
        } catch let error {
            print("Error saving to persistent store: \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore() {
        let jsonDecoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: AlarmController.fileURL)
            let decodedAlarms = try jsonDecoder.decode([Alarm].self, from: data)
            self.alarms = decodedAlarms
        } catch let error {
            print("Error loading from persistent store: \(error.localizedDescription)")
        }
    }
}

extension AlarmScheduler {
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
    
    func scheduleUserNotifications(for alarm: Alarm) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Alarm"
        notificationContent.body = "Your alarm is ringing"
        
        
        let date = alarm.fireDate
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
}
