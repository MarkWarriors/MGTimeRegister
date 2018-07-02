//
//  MGTBaseViewModel.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation


public class MGTBaseViewModel : NSObject {
    
    internal var requiredTextFields : [MGTextField] = []
    
    internal func initRequiredTextFields(textFields : [MGTextField]) {
        self.requiredTextFields = textFields
    }
    
    internal func checkRequiredTextFields() -> Bool {
        var allValid = true
        for tf in self.requiredTextFields {
            if tf.text == nil || tf.text == ""{
                tf.contentError()
                allValid = false
                continue
            }
            
            if tf.keyboardType == .emailAddress {
                if !Utils.isValidEmail(testStr: tf.text!){
                    tf.contentError()
                    allValid = false
                    continue
                }
            }
            
            tf.contentValid()
        }
        return allValid
    }
    
}