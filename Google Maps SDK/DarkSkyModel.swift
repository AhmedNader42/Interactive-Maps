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
    

    func darkSkyURL(latitude lat: String,longitude lon: String) -> URL {
        let urlString = String(format: "https://api.darksky.net/forecast/%@/%@,%@?units=si&lang=%@",key,lat,lon,language)
        let url = URL(string: urlString)
        
        return url!
    }
    
    func parseJSON(Data data:Data)->[String:Any]?{
        do{
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
        } catch let error {
            print("Error : \(error)")
            return nil
        }
    }
    
    func parseData(Data data:[String:Any]) -> String {
        
        let dailyDict = data["daily"] as? [String:Any]
        let prediction = dailyDict?["summary"] as! String
        
        return prediction
    }
}
