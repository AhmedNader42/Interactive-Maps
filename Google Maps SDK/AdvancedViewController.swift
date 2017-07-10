//
//  AdvancedViewController.swift
//  Google Maps SDK
//
//  Created by Admin on 7/8/17.
//  Copyright © 2017 ahmednader. All rights reserved.
//

import UIKit
import GoogleMaps

class AdvancedViewController: UIViewController {
    
    /*************************************************************
     *                                                           *
     *                           Outlets                         *
     *                                                           *
     *************************************************************/
    @IBOutlet weak var tableView: UITableView!
    
    
    /*************************************************************
     *                                                           *
     *                          Variables                        *
     *                                                           *
     *************************************************************/
    var advancedLocation = [GMSAddress]()
    var advancedDetails: [String:String] = [:]
    var keys = ["Country","Locality","SubLocality","ThoroughFare","Longitude","Latitude","PostalCode","Lines","AdministrativeArea"]
    
    
    
    /*************************************************************
     *                                                           *
     *                        Identifieres                       *
     *                                                           *
     *************************************************************/
    struct identefiers {
        static let advancedCell = "AdvancedCell"
    }
    
    
    
    /*************************************************************
     *                                                           *
     *                   Activity life cycle                     *
     *                                                           *
     *************************************************************/
    override func viewDidLoad() {
        tableView.rowHeight = 60
        let cellNib = UINib(nibName: identefiers.advancedCell, bundle: nil)
        
        tableView.register(cellNib, forCellReuseIdentifier: identefiers.advancedCell)
        configureData()
        tableView.reloadData()
    }
    
    
    /*************************************************************
     *                                                           *
     *                        Other methods                      *
     *                                                           *
     *************************************************************/
    //Is used to fill the dictionary with the values to display on screen
    func configureData(){
        
        if advancedLocation.count != 0 {
            for i in advancedLocation {
                if i.country != nil{
                    advancedDetails["Country"] = i.country!
                    print("Country : \(advancedDetails["Country"]!)")
                    break
                }
                else {
                    advancedDetails["Country"] = "Not Found"
                }
            }
            for i in advancedLocation {
                if i.locality != nil{
                    advancedDetails["Locality"] = i.locality!
                    print("Location : \(advancedDetails["Locality"]!)")
                    break
                }
                else {
                    self.advancedDetails["Locality"] = "Not Found"
                }
            }
            
            for i in advancedLocation {
                if i.subLocality != nil{
                    advancedDetails["SubLocality"] = i.subLocality!
                    print("SubLocality : \(advancedDetails["SubLocality"]!)")
                    break
                }
                else {
                    advancedDetails["SubLocality"] = "Not Found"
                }
            }
            for i in advancedLocation {
                if i.thoroughfare != nil{
                    advancedDetails["ThoroughFare"] = i.thoroughfare!
                    print("ThoroughFare : \(advancedDetails["ThoroughFare"]!)")
                    break
                }
                else {
                    advancedDetails["ThoroughFare"] = "Not Found"
                }
            }
            for i in advancedLocation {
                if i.postalCode != nil{
                    advancedDetails["PostalCode"] = i.postalCode!
                    print("PostalCode: \(advancedDetails["PostalCode"]!)")
                    break
                }
                else {
                    advancedDetails["PostalCode"] = "Not Found"
                }
            }
            for i in advancedLocation {
                if i.lines != nil{
                    advancedDetails["Lines"] = String(describing: i.lines!.startIndex)
                    print("Lines : \(advancedDetails["Lines"]!)")
                    break
                }
                else {
                    advancedDetails["Lines"] = "Not Found"
                }
            }
            for i in advancedLocation {
                if i.administrativeArea != nil{
                    advancedDetails["AdministrativeArea"] = i.administrativeArea!
                    print("Administrative Area : \(advancedDetails["AdministrativeArea"]!)")
                    break
                }
                else {
                    advancedDetails["AdministrativeArea"] = "Not Found"
                }
            }
            
            advancedDetails["Latitude"]  = String(describing: advancedLocation.first!.coordinate.latitude)
            advancedDetails["Longitude"] = String(describing: advancedLocation.first!.coordinate.longitude)
        }
    }
    
}



/*************************************************************
 *                                                           *
 *                        Table View methods                 *
 *                                                           *
 *************************************************************/
extension AdvancedViewController: UITableViewDelegate {
}

extension AdvancedViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return advancedDetails.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identefiers.advancedCell, for: indexPath) as! AdvancedCell
        
        
        cell.configure(Key: "   " + keys[indexPath.row] ,Value: advancedDetails[keys[indexPath.row]]!)
        
        //print("Key : \(keys[indexPath.row]) , Value : \(advancedDetails[keys[indexPath.row]]!) ")
        
        
        return cell
    }
}


















