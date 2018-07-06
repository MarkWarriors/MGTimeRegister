//
//  WaitView.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//  

import UIKit

public class WaitView : OverlayView {
    
    func showWait(onViewController vc: UIViewController, onShowCompleted: (()->())? = nil){
        self.completion = onShowCompleted
        self.makeViewAppear(viewController: vc)
    }
    
    func dismissWait(onDismissCompleted: (()->())? = nil){
        self.makeViewDisappear()
        onDismissCompleted?()
    }
}
