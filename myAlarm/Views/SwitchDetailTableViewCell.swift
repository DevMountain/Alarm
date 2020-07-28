//
//  SwitchDetailTableViewCell.swift
//  myAlarm
//
//  Created by Drew Miller on 7/27/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
    
    func switchCellSwitchValueChanged(cell: SwitchDetailTableViewCell)
}

class SwitchDetailTableViewCell: UITableViewCell {
    
    //Landing Pad
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Action
    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.switchCellSwitchValueChanged(cell: self)
    }

    
   func updateViews() {
    guard let alarm = alarm else { return }
    timeLabel.text = alarm.fireTimeAsString
    nameLabel.text = alarm.name
    alarmSwitch.isOn = alarm.enabled
    }
    
}
