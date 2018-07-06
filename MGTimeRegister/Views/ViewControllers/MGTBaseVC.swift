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
    
    var alertView : AlertView = (Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)![0] as? AlertView)!
    var waitView : WaitView = (Bundle.main.loadNibNamed("WaitView", owner: self, options: nil)![0] as? WaitView)!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(title: String, message: String){
        alertView.showAlert(onViewController: self, title: title, text: message, buttonText: Strings.Commons.ok)
    }
    
    func showConfirm(title: String, message: String, onChoice callback: ((_ confirmed: Bool)->())?) {
        alertView.showAlert(onViewController: self,
                            title: title,
                            text: message,
                            buttonOkText: Strings.Commons.ok,
                            buttonCancelText: Strings.Commons.cancel,
                            callback: callback,
                            onShowCompleted: nil)
    }
    
    func showWaitView(){
        waitView.showWait(onViewController: self)
    }
    
    func dismissWaitView(){
        waitView.dismissWait()
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
