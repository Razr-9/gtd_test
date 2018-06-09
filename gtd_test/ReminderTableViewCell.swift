//
//  ReminderTableViewCell.swift
//  gtd_test
//
//  Created by 聂润泽 on 2018/1/12.
//  Copyright © 2018年 Razr. All rights reserved.
//

import UIKit
import EventKit

class ReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var completeButton: UIButton!

    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var dueTime: UILabel!
    @IBOutlet weak var propertyLabel: UILabel!
    
    var reminder: EKReminder!
    var eventStore: EKEventStore!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func completeButton(_ sender: Any) {
        
        if self.reminderLabel.textColor == UIColor.gray {
            self.reminderLabel.textColor = UIColor.black
            completeButton.setTitle("\u{e651}", for: .normal)
            reminder.isCompleted = false
            do{
                try eventStore.save(reminder, commit: true)
            }catch{
                print("error")
            }
        }else{
            completeButton.setTitle("\u{e618}", for: .normal)
            self.reminderLabel.textColor = UIColor.gray
            reminder.isCompleted = true
            do{
                try eventStore.save(reminder, commit: true)
            }catch{
                print("error")
            }
        }
        
    }
}
