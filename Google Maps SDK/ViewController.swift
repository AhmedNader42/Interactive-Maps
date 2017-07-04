//
//  ViewController.swift
//  Google Maps SDK
//
//  Created by Admin on 7/1/17.
//  Copyright © 2017 ahmednader. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class ViewController: UIViewController,GMSMapViewDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var mapView         :GMSMapView!
    var placesClient    :GMSPlacesClient!
    var zoomLevel       : Float = 15.0
    //List of likely places
    var likelyPlaces: [GMSPlace] = []
    //The currently selected Place.
    var selectedPlace: GMSPlace?
    
    let darkSky = DarkSkyModel()
    
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 1.285,longitude: 103.848,zoom: 3)
        let mapView = GMSMapView.map(withFrame: .zero,camera: camera)
        mapView.mapType = .normal
        let myLocation = mapView.myLocation
        print("MyLocation \(myLocation?.coordinate.latitude),\(myLocation?.coordinate.longitude)")
        
        mapView.delegate = self
        self.view = mapView
        
        
        
    }
    
    
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You Tapped at \(coordinate.latitude),\(coordinate.longitude)")
        
        darkSky.language = "ar"
        darkSky.getWeather(Latitude: String(coordinate.latitude), Longitude: String(coordinate.longitude))
        
        let loc = GMSGeocoder()
        loc.reverseGeocodeCoordinate(coordinate, completionHandler: {data,error in
            
            
            
//            for i in (data?.results())! {
//                print("Country:  \((i.country))")
//                print("LastLocality : \(i.locality)")
//            }
            
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
//        
//        
//        placesClient = GMSPlacesClient.shared()
        
        let camera = GMSCameraPosition.camera(withLatitude: 1.285,longitude: 1.285, zoom: zoomLevel)
        
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        //Add the map to the view, hide it untile we've got a location update 
        view.addSubview(mapView)
        mapView.isHidden = true
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










