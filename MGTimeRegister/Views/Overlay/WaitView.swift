//
//  WaitView.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//  

import UIKit

public class WaitView : OverlayView {
    
    func showWait(onShowCompleted: @escaping()->()){
        self.completion = onShowCompleted
        self.makeViewAppear()
    }
    
    func dismissWait(onDismissCompleted: @escaping()->()){
        self.makeViewDisappear()
        onDismissCompleted()
    }
}
