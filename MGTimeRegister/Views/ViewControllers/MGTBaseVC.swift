//
//  MGTBaseVC.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MGTBaseVC: UIViewController {
    
    internal let disposeBag = DisposeBag()
    
    func showAlert(title: String, message: String){
        (self.navigationController as! MGTNavigationController).showAlertView(title: title, text: message, buttonText: Strings.Commons.ok)
    }
    
    
    func showWaitView(){
        (self.navigationController as! MGTNavigationController).showWaitView()
    }
    
    func dismissWaitView(){
        (self.navigationController as! MGTNavigationController).dismissWaitView()
    }
    
    /*
    override var shouldAutorotate: Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }
        else {
            return false
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return .allButUpsideDown
        }
        else{
            return UIInterfaceOrientationMask.portrait
        }
    }
    */
}
