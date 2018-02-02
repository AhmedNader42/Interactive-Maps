//
//  AdvancedCell.swift
//  Google Maps SDK
//
//  Created by Admin on 7/8/17.
//  Copyright © 2017 ahmednader. All rights reserved.
//

import UIKit

class AdvancedCell: UITableViewCell {

    
    // MARK: - Outlets
    @IBOutlet weak var keyLabel  : UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
   
    
    // MARK: - Setup method
    //Configure the cell labels with given data
    func configure (Key key: String,Value value: Any) {
        keyLabel.text = key
        valueLabel.text = String(describing: value)
        
    }
    
   
}
