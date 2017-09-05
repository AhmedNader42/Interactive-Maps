//
//  ResultViewController.swift
//  Google Maps SDK
//
//  Created by Admin on 7/4/17.
//  Copyright © 2017 ahmednader. All rights reserved.
//

import UIKit
import GoogleMaps

class ResultViewController: UIViewController {
    
    
    /*************************************************************
     *                                                           *
     *                       Outlets                             *
     *                                                           *
     *************************************************************/
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var upperResultLabel : UILabel!
    @IBOutlet weak var popUpView  : UIView!
    @IBOutlet weak var upperLabelActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lowerLabelActivityIndicator: UIActivityIndicatorView!
    /*************************************************************
     *                                                           *
     *                      IBAction methods                     *
     *                                                           *
     *************************************************************/
    @IBAction func advancedDetailsButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: identefiers.advancedViewController, sender: nil)
    }
    
    /*************************************************************
     *                                                           *
     *                      Variables                            *
     *                                                           *
     *************************************************************/
    var advancedLocation = [GMSAddress]()
    //Networking related
    var dataTask             : URLSessionDataTask?
    var darkSky              = DarkSkyModel()
    var tappedCoordinates    : CLLocationCoordinate2D?
    
    
    /*************************************************************
     *                                                           *
     *                      Identifiers                          *
     *                                                           *
     *************************************************************/
    struct identefiers {
        static let advancedViewController = "ToAdvancedViewController"
    }
    
    
    /*************************************************************
     *                                                           *
     *                      Activity Life cycle                  *
     *                                                           *
     *************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        darkSky.delegate = self
        
        // Check if the tappedCoordinates passed from previous VC exists.
        if tappedCoordinates != nil {
            // Request the weather with the tapped coordinates and use the model to get the results.
            upperLabelActivityIndicator.startAnimating()
            lowerLabelActivityIndicator.startAnimating()
            darkSky.getWeather(coordinates: tappedCoordinates!)
            darkSky.getLocation(coordinate: tappedCoordinates!)
        }
        
        
        
        
        // Make the corners of the popupView rounded.
        popUpView.layer.cornerRadius = 20
        
        // Recognize a tap and if it is outside the popup close it.
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        
        
        
    }
    
    
    
    
    
    
    /*************************************************************
     *                                                           *
     *                      Initializer                          *
     *                                                           *
     *************************************************************/
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    
    
    
    
    /*************************************************************
     *                                                           *
     *                        Segue methods                      *
     *                                                           *
     *************************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Make sure the segue is going to the advancedVC.
        if segue.identifier == identefiers.advancedViewController {
            
            let destination = segue.destination as! AdvancedViewController
            // Give the advancedDetails to the advancedVC.
            destination.advancedLocation = advancedLocation
        }
    }
    
    /*************************************************************
     *                                                           *
     *                        Close method                       *
     *                                                           *
     *************************************************************/
    /// Dismiss the ViewController that was presented modally.
    func close(){
        dismiss(animated: true, completion: nil)
    }
}



extension ResultViewController: darkSkyDelegate {
    
    func weatherResultsReturned(result: String) {
        lowerLabelActivityIndicator.stopAnimating()
        self.resultLabel.text = result
    }
    
    func locationResultsReturned(location: [GMSAddress]) {
        
        upperLabelActivityIndicator.stopAnimating()
        
        // Set the advanced location for the detailed VC.
        advancedLocation = location
        
        
        // Make sure the locations are not empty.
        if location.count == 0 {
            upperResultLabel.text = "Undetermined"
        }
        else {
            // Display country in upper label
            for i in location {
                if i.country != nil {
                    upperResultLabel.text = i.country
                    break
                }
                else{
                    upperResultLabel.text = "Not Found"
                }
            }
        }
    }
}




/*************************************************************
 *                                                           *
 *                        Transition Delegate                *
 *                                                           *
 *************************************************************/
extension ResultViewController: UIViewControllerTransitioningDelegate{
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }
}


/*************************************************************
 *                                                           *
 *                   Gesture Recognizer Delegate             *
 *                                                           *
 *************************************************************/
extension ResultViewController: UIGestureRecognizerDelegate {
    // Recognize if the touch is inside or outside of the popupView.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}





