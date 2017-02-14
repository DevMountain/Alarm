//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by James Pacheco on 5/10/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
	func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
	
    // MARK: Actions
    
	@IBAction func switchValueChanged(_ sender: Any) {
		delegate?.switchCellSwitchValueChanged(cell: self)
	}
	
    
    func updateViews() {
        guard let alarm = alarm else { return }
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.isOn = alarm.enabled
    }
    
	// MARK: Properties
	
	weak var delegate: SwitchTableViewCellDelegate?
	
	var alarm: Alarm? {
		didSet {
            updateViews()
        }
	}
	
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var alarmSwitch: UISwitch!
}
