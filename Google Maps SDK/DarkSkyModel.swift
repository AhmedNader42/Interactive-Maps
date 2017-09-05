//
//  DarkSkyModel.swift
//  Google Maps SDK
//
//  Created by Admin on 7/3/17.
//  Copyright © 2017 ahmednader. All rights reserved.
//

import Foundation
import GoogleMaps

protocol darkSkyDelegate{
    func weatherResultsReturned(result: String)
    func locationResultsReturned(location:[GMSAddress])
}

extension darkSkyDelegate {
    func weatherResultsReturned(result: String){}
    func locationResultsReturned(location:[GMSAddress]){}
}

class DarkSkyModel {
    
    /*****************************************************
     *                                                   *
     *                      Variables                    *
     *                                                   *
     *****************************************************/
    // You need to put your own key in the constants file.
    private let key = DARK_SKY_KEY
    
    
    var language    = ""
    var unit        = "si"
    
    var delegate : darkSkyDelegate?
    
    /*************************************************************
     *                                                           *
     *                      URL formatting                       *
     *                                                           *
     *************************************************************/
    
    /// Construct a valid darkSky URL from a latitude and longitude.
    ///
    /// - Parameters:
    ///   - lat: Latitude of the desired place.
    ///   - lon: Longitude of the desired place.
    /// - Returns: Valid darkSky URL.
    private func darkSkyURL(latitude lat: String,longitude lon: String) -> URL {
        
        // Construct the string of the url.
        let urlString = String(format: "https://api.darksky.net/forecast/%@/%@,%@?units=%@&lang=%@",key,lat,lon,unit,language)
        // Construct the URL.
        let url = URL(string: urlString)
        
        return url!
    }
    
    
    
    /*************************************************************
     *                                                           *
     *                      Parsing methods                      *
     *                                                           *
     *************************************************************/
    /// Parse the server's JSON response into a dictionary.
    ///
    /// - Parameter data: The JSON data of the request.
    /// - Returns: Dictionary with the data.
    private func parseJSON(Data data:Data)->[String:Any]?{
        do{
            // Try to turn the JSON dta into a dictionary.
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
        } catch let error {
            print("Error : \(error)")
            return nil
        }
    }
    
    /// Parse the dictionary to a prediction string.
    ///
    /// - Parameter data: The dictionary from parsing the JSON
    /// - Returns: Prediction string
    private func parseData(Data data:[String:Any]) -> String {
        // Get the daily data.
        let dailyDict = data["daily"] as? [String:Any]
        // Get the summary from the daily part.
        let prediction = dailyDict?["summary"] as! String
        
        return prediction
    }
    
    func getWeather(coordinates:CLLocationCoordinate2D){
        // Get a valid DarkSky URL from the darkSky model with the tapped coordinates.
        print("Latitude : \(coordinates.latitude)")
        print("Longitude : \(coordinates.longitude)")
        let url = darkSkyURL(latitude: String(describing:coordinates.latitude) ,longitude: String(describing:coordinates.longitude ))
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url){
            
            data,respone,error in
            
            if error != nil {
                // Show internet connection error.
                self.delegate?.weatherResultsReturned(result: "")
            }
            else {
                // Parse the JSON data from the request to a dictionary using the darkSky model.
                let dataDict = self.parseJSON(Data: data!)
                
                
                if self.delegate != nil {
                    // Parse the data dictionary to get the prediction.
                    dump(dataDict)
                    let prediction =  self.parseData(Data: dataDict!)
                    dump(prediction)
                    // Notify the delegate that you got the values and give it to him.
                    DispatchQueue.main.async {
                        self.delegate?.weatherResultsReturned(result: prediction)
                    }
                    
                }
            }
        }
        dataTask.resume()
    }
    
    
    func getLocation(coordinate:CLLocationCoordinate2D){
        //Reverse Geocode the coordinates to get more detailed information(Country,locality,...)
        let loc = GMSGeocoder()
        loc.reverseGeocodeCoordinate(coordinate, completionHandler: {
            data,error in
            
            if error != nil {
                print("ReverseGeoCoderError : \(error)")
            }
            else if data != nil, data?.results()?.count != 0 {
                // Notify the delegate that you got the values and give it to him.
                DispatchQueue.main.async {
                    self.delegate?.locationResultsReturned(location: (data!.results())!)
                }
                
            }
        })
    }
    
}
