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
    
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var mapView         :GMSMapView!
    var zoomLevel       : Float = 15.0
    
    
    let darkSky = DarkSkyModel()
    var prediction:String = ""
    var advancedDetails : [String:Any] = [:]
    
    
    
    struct identifiers {
        static let resultViewController = "ToResultViewController"
    }
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 1.285,longitude: 103.848,zoom: 3)
        let mapView = GMSMapView.map(withFrame: .zero,camera: camera)
        mapView.mapType = .normal
//        let myLocation = mapView.myLocation
//        print("MyLocation \(myLocation?.coordinate.latitude),\(myLocation?.coordinate.longitude)")
        
        mapView.delegate = self
        self.view = mapView
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifiers.resultViewController {
            
            let destination = segue.destination as! ResultViewController
                destination.result = self.prediction
                destination.resultAdvancedDetails = advancedDetails
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You Tapped at \(coordinate.latitude),\(coordinate.longitude)")
        
        darkSky.language = "en"
        
        
        let url = darkSky.darkSkyURL(latitude: String(coordinate.latitude), longitude: String(coordinate.longitude))
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url){
            
            data,respone,error in
            
            if error != nil {
                print("Error : \(error)")
            }
            else {
                let dataDict = self.darkSky.parseJSON(Data: data!)
                let dailyDict = dataDict?["daily"] as? [String:Any]
                
                
                
                    self.prediction = dailyDict?["summary"] as! String
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: identifiers.resultViewController, sender: nil)
                }
                
                
            }
        }
        dataTask.resume()
        

        
        let loc = GMSGeocoder()
        loc.reverseGeocodeCoordinate(coordinate, completionHandler: {
            data,error in
            
            if data?.results() != nil{
                for i in (data?.results())! {
                    if i.country != nil{
                        self.advancedDetails["Country"] = i.country
                        break
                    }
                    else {
                        self.advancedDetails["Country"] = "Not Found"
                    }
                }
                for i in (data?.results())! {
                    if i.locality != nil{
                        self.advancedDetails["Locality"] = i.locality
                        break
                    }
                    else {
                        self.advancedDetails["Locality"] = "Not Found"
                    }
                }
                
                for i in (data?.results())! {
                    if i.subLocality != nil{
                        self.advancedDetails["SubLocality"] = i.subLocality
                        break
                    }
                    else {
                        self.advancedDetails["SubLocality"] = "Not Found"
                    }
                }
                for i in (data?.results())! {
                    if i.thoroughfare != nil{
                        self.advancedDetails["ThoroughFare"] = i.thoroughfare
                        break
                    }
                    else {
                        self.advancedDetails["ThoroughFare"] = "Not Found"
                    }
                }
                self.advancedDetails["Latitude"] = coordinate.latitude
                self.advancedDetails["Longitude"] = coordinate.longitude
                
                for i in (data?.results())! {
                    if i.postalCode != nil{
                        self.advancedDetails["PostalCode"] = i.postalCode
                        break
                    }
                    else {
                        self.advancedDetails["PostalCode"] = "Not Found"
                    }
                }
                for i in (data?.results())! {
                    if i.lines != nil{
                        self.advancedDetails["Lines"] = i.lines?.startIndex
                        break
                    }
                    else {
                        self.advancedDetails["Lines"] = "Not Found"
                    }
                }
                for i in (data?.results())! {
                    if i.administrativeArea != nil{
                        self.advancedDetails["AdministrativeArea"] = i.administrativeArea
                        break
                    }
                    else {
                        self.advancedDetails["AdministrativeArea"] = "Not Found"
                    }
                }
            }

            
        })
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        locationManager = CLLocationManager()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
//        locationManager.delegate = self
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController: CLLocationManagerDelegate{
    //To handle incoming location events.
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location: CLLocation = locations.last!
//        print("Location: \(location)")
//        
//        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,longitude: location.coordinate.longitude, zoom: zoomLevel)
//        
//        
//        if mapView.isHidden {
//            mapView.isHidden = false
//            mapView.camera = camera
//        } else {
//            mapView.animate(to: camera)
//        }
//        
//    }
    
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










