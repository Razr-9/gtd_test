//
//  CalendarTableViewCell.swift
//  gtd_test
//
//  Created by 聂润泽 on 2018/1/12.
//  Copyright © 2018年 Razr. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var connection: UILabel!
    @IBOutlet weak var calendarIdentifier: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var eventStartTime: UILabel!
    @IBOutlet weak var eventEndTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView?.backgroundColor = UIColor.init(patternImage: UIImage())
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
