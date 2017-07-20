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
            darkSky.language = "ar"
        case 2 :
            darkSky.language = "es"
        case 3:
            darkSky.language = "fr"
        default:
            darkSky.language = "en"
        }
    }
    
    @IBAction func unitSegmentedControl (_ sender: UISegmentedControl) {
        // Set the unit of measure according to the selected segment.
        switch unitSegmentedControl.selectedSegmentIndex {
        case 1:
            darkSky.unit = "us"
        default:
            darkSky.unit = "si"
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
    
    //Networking related
    var dataTask             : URLSessionDataTask?
    let darkSky              = DarkSkyModel()
    var prediction           = ""
    
    
    
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
            
            // Give the result to the resultviewController
            destination.result = self.prediction
            // Give the advanced details to the resulViewController.
            destination.advancedLocation = self.advancedLocation
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
extension ViewController: GMSMapViewDelegate{
    
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
        
        
        // Cancel previous request if it is still running and start a new one.
        dataTask?.cancel()
        
        
        
        //Reverse Geocode the coordinates to get more detailed information(Country,locality,...)
        let loc = GMSGeocoder()
        loc.reverseGeocodeCoordinate(coordinate, completionHandler: {
            data,error in
            
            if error != nil {
                print("ReverseGeoCoderError : \(error)")
            }
            else if data != nil, data?.results()?.count != 0 {
                // Fill the advanced location information from the result of reverseGeoCoding the coordinates.
                self.advancedLocation = (data?.results())!
                
                // Make sure the country is known.
                if data?.firstResult()?.country != nil {
                    // Set the title of the marker to the country.
                    self.marker.title = (data?.firstResult()?.country)!
                }
                // Make sure the locality is known
                if data?.firstResult()?.locality != nil {
                    // Set the snippet(Subtitle) of the marker to the locality.
                    self.marker.snippet = data?.firstResult()?.locality
                }
                
            }
        })
        
        // Get a valid DarkSky URL from the darkSky model with the tapped coordinates.
        let url = darkSky.darkSkyURL(latitude: String(coordinate.latitude), longitude: String(coordinate.longitude))
        let session = URLSession.shared
        dataTask = session.dataTask(with: url){
            
            data,respone,error in
            
            if error != nil {
                // Show internet connection error.
                self.showError(Title: "Network error", Message: "Check you internet connection")
            }
            else {
                // Parse the JSON data from the request to a dictionary using the darkSky model.
                let dataDict = self.darkSky.parseJSON(Data: data!)
                
                // Parse the data dictionary to get the prediction.
                self.prediction =  self.darkSky.parseData(Data: dataDict!)
                
                
                //Go to the ResultViewController
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: identifiers.resultViewController, sender: nil)
                }
                
            }
        }
        dataTask?.resume()
    }

}










