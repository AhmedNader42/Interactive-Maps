//
//  AdvancedViewController.swift
//  Google Maps SDK
//
//  Created by Admin on 7/8/17.
//  Copyright © 2017 ahmednader. All rights reserved.
//

import UIKit

class AdvancedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    
    
    
    var advancedDetails: [String:Any] = [:]
    var keys = ["Country","Locality","SubLocality","ThoroughFare","Longitude","Latitude","PostalCode","Lines","AdministrativeArea"]
    
    
    struct identefiers {
        static let advancedCell = "AdvancedCell"
    }
    
    
    
    
    override func viewDidLoad() {
        
        print("In advanced View Controller")
        tableView.rowHeight = 60
        let cellNib = UINib(nibName: identefiers.advancedCell, bundle: nil)
        
        tableView.register(cellNib, forCellReuseIdentifier: identefiers.advancedCell)
        tableView.reloadData()
        
    }

}




extension AdvancedViewController: UITableViewDelegate {
    
    
    
}

extension AdvancedViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identefiers.advancedCell, for: indexPath) as! AdvancedCell
        
        print("InTableView")
        cell.configure(Key: "   " + keys[indexPath.row] ,Value: advancedDetails[keys[indexPath.row]] ?? "Not Found")
        
        print("Key : \(keys[indexPath.row]) , Value : \(advancedDetails[keys[indexPath.row]] ?? "Not Found") ")
        
        
        return cell
    }
}


















