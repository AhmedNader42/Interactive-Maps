//
//  AdvancedCell.swift
//  Google Maps SDK
//
//  Created by Admin on 7/8/17.
//  Copyright © 2017 ahmednader. All rights reserved.
//

import UIKit

class AdvancedCell: UITableViewCell {

    
    
    @IBOutlet weak var keyLabel  : UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
   
    
    
    func configure (Key key: String,Value value: Any) {
        print("In config")
        keyLabel.text = key
        valueLabel.text = String(describing: value)
        
    }
    
   
}
