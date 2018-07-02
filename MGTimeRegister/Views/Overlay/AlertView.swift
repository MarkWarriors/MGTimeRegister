//
//  AlertView.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//  

import UIKit

public class AlertView : OverlayView {
    
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertText: UILabel!
    @IBOutlet weak var alertBtnOk: MGButton!
    @IBOutlet weak var alertBtnCancel: MGButton!

    
    private func createAlert(title: String, text:String, buttonOkText: String?, buttonCancelText: String?, callback: ((_ confirmed: Bool?)->())? = nil, onShowCompleted: (()->())? = nil){
        alertTitle?.text = title.uppercased()
        alertText?.text = text
        alertBtnOk?.setTitle(buttonOkText?.uppercased(), for: UIControlState.normal)

        alertBtnCancel?.isHidden = (buttonCancelText == nil)
        
        if buttonCancelText != nil && buttonCancelText != "" {
            alertBtnCancel.setTitle(buttonCancelText?.uppercased(), for: UIControlState.normal)
        }
        self.callback = callback
        self.completion = onShowCompleted
        
        makeViewAppear()
    }
    
    func showAlert(title: String, text:String, buttonOkText: String, buttonCancelText: String, callback: ((_ confirmed: Bool?)->())? = nil, onShowCompleted: (()->())? = nil){
        createAlert(title: title, text: text, buttonOkText: buttonOkText, buttonCancelText: buttonCancelText, callback: callback, onShowCompleted: onShowCompleted)
    }
    
    func showAlert(title: String, text:String, buttonText: String, callback: ((_ confirmed: Bool?)->())? = nil, onShowCompleted: (()->())? = nil){
        createAlert(title: title, text: text, buttonOkText: buttonText, buttonCancelText: nil, callback: callback, onShowCompleted: onShowCompleted)
    }
    
    
    @IBAction func buttonOkPressed(_ sender: Any) {
        self.callback?(true)
        makeViewDisappear()
    }
    
    @IBAction func buttonCancelPressed(_ sender: Any) {
        self.callback?(false)
        makeViewDisappear()
    }
    
}

