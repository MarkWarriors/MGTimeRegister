//
//  CompanyTableViewCell.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var projectLbl: UILabel!
    
    public static let identifier = "CompanyTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setModel(_ company: Company){
        nameLbl.text = company.name
        projectLbl.text = "\(company.projects?.count ?? 0)"
    }
    
}
