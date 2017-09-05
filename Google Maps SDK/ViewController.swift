//
//  ViewController.swift
//  Google Maps SDK
//
//  Created by Admin on 7/1/17.
//  Copyright © 2017 ahmednader. All rights reserved.
//

import UIKit
import GoogleMaps


class ViewController: UIViewController {
    
    
    /*************************************************************
     *                                                           *
     *                            Outlets                        *
     *                                                           *
     *************************************************************/
    @IBOutlet weak var languageSegmentedControl : UISegmentedControl!
    @IBOutlet weak var unitSegmentedControl     : UISegmentedControl!
    
    
    /*************************************************************
     *                                                           *
     *                        IBAction methods                   *
     *                                                           *
     *************************************************************/
    @IBAction func languageSegmentedControlButton(_ sender: UISegmentedControl) {
        // Set the language according to the selected segment.
        switch languageSegmentedControl.selectedSegmentIndex {
        case 1:
            language = "ar"
        case 2 :
            language = "es"
        case 3:
            language = "fr"
        default:
            language = "en"
        }
    }
    
    @IBAction func unitSegmentedControl (_ sender: UISegmentedControl) {
        // Set the unit of measure according to the selected segment.
        switch unitSegmentedControl.selectedSegmentIndex {
        case 1:
            unit = "us"
        default:
            unit = "si"
        }
    }
    
    
    /*************************************************************
     *                                                           *
     *                      Variables                            *
     *                                                           *
     *************************************************************/
    //Location/Map related
    var mapView              : GMSMapView!
    var currentLatitude      = CLLocationDegrees(floatLiteral: 30.5)
    var currentLongitude     = CLLocationDegrees(floatLiteral: 31.2)
    var advancedLocation     = [GMSAddress]()
    var marker               = GMSMarker()
    
    var unit     = ""
    var language = "en"
    var tappedCoordinates : CLLocationCoordinate2D?
    
    
    /*************************************************************
     *                                                           *
     *                        Identifiers                        *
     *                                                           *
     *************************************************************/
    struct identifiers {
        static let resultViewController = "ToResultViewController"
    }
    
    
    
    /*************************************************************
     *                                                           *
     *                        Activity Life cycle                *
     *                                                           *
     *************************************************************/
    override func loadView() {
       
        // Setup the camera
        let camera = GMSCameraPosition.camera(withLatitude: currentLatitude,longitude: currentLongitude,zoom: 3)
        let mapView = GMSMapView.map(withFrame: .zero,camera: camera)
        mapView.mapType = .normal
        mapView.delegate = self
        self.view = mapView
    }
    
    
    /*************************************************************
     *                                                           *
     *                        Segue method                       *
     *                                                           *
     *************************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Make sure the segue is going to resultViewController.
        if segue.identifier == identifiers.resultViewController {
            let destination = segue.destination as! ResultViewController
            
            destination.darkSky.unit     = self.unit
            destination.darkSky.language = self.language
            destination.tappedCoordinates = self.tappedCoordinates
            
        }
    }
    
    /*************************************************************
     *                                                           *
     *                           Error                           *
     *                                                           *
     *************************************************************/
    /// Shows a popup Error on screen
    ///
    /// - Parameters:
    ///   - title: Title at the top of the popup
    ///   - message: Message displayed within the body
    func showError(Title title:String, Message message: String ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert,animated: true)
    }

}



/*************************************************************
 *                                                           *
 *                        Map Delegate                       *
 *                                                           *
 *************************************************************/
extension ViewController: GMSMapViewDelegate {
    
    // When the user taps on a place.
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You Tapped at \(coordinate.latitude),\(coordinate.longitude)")
        
        // Clear all the map overlays (markers/overlays).
        mapView.clear()
        
        // Animate and zoom to the tapped postition.
        mapView.animate(toLocation: coordinate)
        mapView.animate(toZoom: 6)
        
        // Create a circle at the tapped postion (Under the marker).
        let circle = GMSCircle(position: coordinate, radius: 20)
        circle.map = mapView
        circle.strokeColor = .green
        circle.strokeWidth = 10
        
        // Create a marker at the tapped postion
        marker = GMSMarker(position: coordinate)
        marker.appearAnimation = .pop
        marker.icon = GMSMarker.markerImage(with: .green)
        marker.map = mapView
        
        self.tappedCoordinates = coordinate
        
        //Go to the ResultViewController
        self.performSegue(withIdentifier: identifiers.resultViewController, sender: nil)
        
    }

}











