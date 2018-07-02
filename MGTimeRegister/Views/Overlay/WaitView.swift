//
//  WaitView.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//  

import UIKit

public class WaitView : OverlayView {
    
    func showWait(onShowCompleted: (()->())? = nil){
        self.completion = onShowCompleted
        self.makeViewAppear()
    }
    
    func dismissWait(onDismissCompleted: (()->())? = nil){
        self.makeViewDisappear()
        onDismissCompleted?()
    }
}
