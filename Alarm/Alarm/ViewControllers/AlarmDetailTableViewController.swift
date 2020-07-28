//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Marcus Armstrong on 7/28/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var enableButton: UIButton!
    
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    var alarmIsOn: Bool = true

    @IBAction func enableButtonTapped(_ sender: UIButton) {
        alarmIsOn.toggle()
        enableButton.setTitle(alarmIsOn ? "On" : "Off" , for: .normal)
        enableButton.backgroundColor = alarmIsOn ? .green : .red
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text else { return }
        let fireDate = alarmDatePicker.date
        if let alarm = alarm {
            AlarmController.sharedInstance.updateAlarm(alarm: alarm, name: name, fireDate: fireDate, enabled: alarmIsOn)
        } else {
            AlarmController.sharedInstance.addAlarm(fireDate: fireDate, name: name, enabled: alarmIsOn)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func updateViews() {
        if let alarm = alarm {
            alarmDatePicker.date = alarm.fireDate
            nameTextField.text = alarm.name
            alarmIsOn = alarm.enabled
        }
        enableButton.setTitle(alarmIsOn ? "On" : "Off" , for: .normal)
        enableButton.backgroundColor = alarmIsOn ? .green : .red
        enableButton.layer.cornerRadius = enableButton.frame.height/2
    }
    
}
