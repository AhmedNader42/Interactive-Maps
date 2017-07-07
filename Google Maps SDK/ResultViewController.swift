//
//  ResultViewController.swift
//  Google Maps SDK
//
//  Created by Admin on 7/4/17.
//  Copyright © 2017 ahmednader. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var popUpView  : UIView!
    
    var result:String = "sds"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    func close(){
        dismiss(animated: true, completion: nil)
    }
    
   
    override func viewDidLoad() {
        popUpView.layer.cornerRadius = 20
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        
        print("result: \(result)")
        resultLabel.textColor = .black
        resultLabel.text = result
        
        
    }
   

}


extension ResultViewController: UIViewControllerTransitioningDelegate{
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }
}



extension ResultViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        return (touch.view === self.view)
    }
}




