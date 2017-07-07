//
//  DimmingPresentationController.swift
//  Google Maps SDK
//
//  Created by Admin on 7/4/17.
//  Copyright © 2017 ahmednader. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {

    
    //To prevent the map from being removed from the background
    override var shouldRemovePresentersView: Bool{
        return false
    }
}
