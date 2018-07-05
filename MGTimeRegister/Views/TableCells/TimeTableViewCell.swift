//
//  TimeTableViewCell.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 05/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    
    public static let identifier = "TimeTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setModel(_ time: Time){
        nameLbl.text = (time.date! as Date).toStringDate()
        hoursLbl.text = "\(time.hours)"
    }
    
}
