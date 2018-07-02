//
//  AlertView.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//  

import UIKit

public class AlertView : OverlayView {
    
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertText: UILabel!
    @IBOutlet weak var alertBtnOk: UIButton!
    @IBOutlet weak var alertBtnCancel: UIButton!

    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func createAlert(title: String, text:String, buttonOkText: String?, buttonCancelText: String?, image: UIImage?, callback: @escaping(_ confirmed: Bool?)->(), onShowCompleted: @escaping()->()){
        alertTitle?.text = title.uppercased()
        alertText?.text = text
        alertBtnOk?.setTitle(buttonOkText?.uppercased(), for: UIControlState.normal)

        alertBtnCancel?.isHidden = (buttonCancelText == nil)
        
        if buttonCancelText != nil && buttonCancelText != "" {
            alertBtnCancel.setTitle(buttonCancelText?.uppercased(), for: UIControlState.normal)
        }
        self.callback = callback
        self.completion = onShowCompleted

        self.alertImageView.image = image
        
        makeViewAppear()
    }
    
    func showAlert(title: String, text:String, buttonOkText: String, buttonCancelText: String, image: UIImage?, callback: @escaping(_ confirmed: Bool?)->(), onShowCompleted: @escaping()->()){
        createAlert(title: title, text: text, buttonOkText: buttonOkText, buttonCancelText: buttonCancelText, image: image, callback: callback, onShowCompleted: onShowCompleted)
    }
    
    func showAlert(title: String, text:String, buttonText: String, image: UIImage?, callback: @escaping(_ confirmed: Bool?)->(), onShowCompleted: @escaping()->()){
        createAlert(title: title, text: text, buttonOkText: buttonText, buttonCancelText: nil, image: image, callback: callback, onShowCompleted: onShowCompleted)
    }
    
    
    @IBAction func buttonOkPressed(_ sender: Any) {
        self.callback!(true)
        makeViewDisappear()
    }
    
    @IBAction func buttonCancelPressed(_ sender: Any) {
        self.callback!(false)
        makeViewDisappear()
    }
    
}

