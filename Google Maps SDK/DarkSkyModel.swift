//
//  DarkSkyModel.swift
//  Google Maps SDK
//
//  Created by Admin on 7/3/17.
//  Copyright © 2017 ahmednader. All rights reserved.
//

import Foundation


class DarkSkyModel {
    
    private let key = "9289c51e1b169870a747a562feac6693"
    var language:String = ""
    
    
    func getWeather(Latitude lat:String,Longitude lon:String) -> String {
        
        let url = darkSkyURL(latitude: lat, longitude: lon)
        
        let session = URLSession.shared
        print("Inside the model")
        let dataTask = session.dataTask(with: url){
            
            data,respone,error in
            
            if error != nil {
                print("Error : \(error)")
            }
            else {
                let dataDict = self.parseJSON(Data: data!)
                let dailyDict = dataDict?["daily"] as? [String:Any]
        
                
                print("Data: \((dailyDict?["summary"])!)")
                
                
            }
        }
        dataTask.resume()
        
        
        
        return ""
    }
    
    private func darkSkyURL(latitude lat: String,longitude lon: String) -> URL {
        
        
        
        
        let urlString = String(format: "https://api.darksky.net/forecast/%@/%@,%@?units=si&lang=%@",key,lat,lon,language)
        let url = URL(string: urlString)
        
        return url!
    }
    
    private func parseJSON(Data data:Data)->[String:Any]?{
        do{
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
        } catch let error {
            print("Error : \(error)")
            return nil
        }
    }
    
    
}
