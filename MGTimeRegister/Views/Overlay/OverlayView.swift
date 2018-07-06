//
//  OverlayView.swift
//  UrmetSecure
//
//  Created by Marco Guerrieri on 20/02/18.
//  Copyright © 2018 Urmet. All rights reserved.
//

import UIKit

public class OverlayView : UIView {
    
    var completion : (()->())?
    var callback : ((_ confirmed: Bool)->())?
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    internal func makeViewAppear(viewController: UIViewController){
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            DispatchQueue.main.async {
                self.layoutSubviews()
                self.alpha = 0
                self.frame = viewController.view.bounds
                viewController.view.addSubview(self)
                UIView.animate(withDuration: 0.25, animations: {
                    self.alpha = 1
                }) { (completed) in
                    if self.completion != nil {
                        self.completion!()
                    }
                }
            }
        }
    }
    
    internal func makeViewDisappear(){
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.25, animations: {
                    self.alpha = 0
                }) { (completed) in
                    self.removeFromSuperview()
                }
            }
        }
    }
}
