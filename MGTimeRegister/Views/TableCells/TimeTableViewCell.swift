//
//  TimeTableViewCell.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 05/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet weak var notesLbl: UILabel!
    
    public static let identifier = "TimeTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setModel(_ time: Time){
        hoursLbl.text = "\(time.hours)"
        if time.notes!.count > 0 {
            notesLbl.text =  time.notes
            notesLbl.textColor = UIColor.black
        }
        else {
            notesLbl.text =  Strings.Commons.noNotes
            notesLbl.textColor = UIColor.gray
        }
    }
    
}
