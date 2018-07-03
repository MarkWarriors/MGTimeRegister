//
//  ProjectTableViewCell.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    
    public static let identifier = "ProjectTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func setModel(_ project: Project){
        nameLbl.text = project.name
        hoursLbl.text = "\(project.totalHoursCount())"
    }
    
}
