//
//  AlarmTableViewCell.swift
//  myAlarm
//
//  Created by DevMountain on 8/25/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell{
    
    var alarm: Alarm?{
        didSet{
            updateViews()
        }
    }
    
    weak var delegate: AlarmTableViewCellDelegate?


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
    
    func updateViews(){
        guard let alarm = alarm else {return}
        
        nameLabel.text = alarm.name
        timeLabel.text = alarm.fireTimeAsString
        alarmSwitch.isOn = alarm.enabled
    }

    
    @IBAction func alarmSwitched(_ sender: UISwitch) {
        delegate?.alarmWasToggled(sender: self)
    }
    
}
