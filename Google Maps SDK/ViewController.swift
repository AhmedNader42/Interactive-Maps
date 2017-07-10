//
//  ViewController.swift
//  Google Maps SDK
//
//  Created by Admin on 7/1/17.
//  Copyright © 2017 ahmednader. All rights reserved.
//

import UIKit
import GoogleMaps


class ViewController: UIViewController,GMSMapViewDelegate {
    
    
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
    var locationManager      = CLLocationManager()
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
       
        let camera = GMSCameraPosition.camera(withLatitude: currentLatitude,longitude: currentLongitude,zoom: 3)
        let mapView = GMSMapView.map(withFrame: .zero,camera: camera)
        mapView.mapType = .normal
        mapView.delegate = self
        self.view = mapView
    }
    
    override func viewDidLoad() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
    }
    
    /*************************************************************
     *                                                           *
     *                        Segue method                       *
     *                                                           *
     *************************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifiers.resultViewController {
            
            let destination = segue.destination as! ResultViewController
            destination.result = self.prediction
            destination.advancedLocation = self.advancedLocation
        }
    }
    
    /*************************************************************
     *                                                           *
     *                        Map Methods                        *
     *                                                           *
     *************************************************************/
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You Tapped at \(coordinate.latitude),\(coordinate.longitude)")
        
        //Clear all the map overlays (markers/overlays).
        mapView.clear()
        
        //Animate and zoom to the tapped postition.
        mapView.animate(toLocation: coordinate)
        mapView.animate(toZoom: 6)
        
        //Create a circle at the tapped postion (Under the marker).
        let circle = GMSCircle(position: coordinate, radius: 20)
        circle.map = mapView
        circle.strokeColor = .green
        circle.strokeWidth = 15
        //Create a marker at the tapped postion
        marker = GMSMarker(position: coordinate)
        marker.appearAnimation = .pop
        marker.icon = GMSMarker.markerImage(with: .green)
        marker.map = mapView
        
        
        //Cancel previous request and start a new one.
        dataTask?.cancel()
        
        
        
        //Reverse Geocode the coordinates to get more detailed information.
        let loc = GMSGeocoder()
        loc.reverseGeocodeCoordinate(coordinate, completionHandler: {
            data,error in
            if error != nil {
                print("ReverseGeoCoderError : \(error)")
            }
            else if data != nil, data?.results()?.count != 0 {
                
                self.advancedLocation = (data?.results())!
                if data?.firstResult()?.country != nil {
                    self.marker.title = (data?.firstResult()?.country)!
                }
                if data?.firstResult()?.locality != nil {
                    self.marker.snippet = data?.firstResult()?.locality
                }
                
            }
        })
        
        //Send a request with the url formatted by the DarkSky model
        let url = darkSky.darkSkyURL(latitude: String(coordinate.latitude), longitude: String(coordinate.longitude))
        let session = URLSession.shared
        dataTask = session.dataTask(with: url){
            
            data,respone,error in
            
            if error != nil {
                print("Error : \(error)")
            }
            else {
                let dataDict = self.darkSky.parseJSON(Data: data!)
                
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



/*************************************************************
 *                                                           *
 *                        LocationManager Delegate           *
 *                                                           *
 *************************************************************/
extension ViewController: CLLocationManagerDelegate{
    //To handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        currentLatitude  = location.coordinate.latitude 
        currentLongitude = location.coordinate.longitude
        locationManager.stopUpdatingLocation()
        
    }
    
    //Handle authorization for location manager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted")
        case .denied:
            print("Location access was denied")
            mapView.isHidden = false
        case .notDetermined:
            print("Location access was not determined")
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            print("Location access is OK")
        }
    }
    
    //Handle location manager errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Erorr: \(error)")
    }
    
    
}










