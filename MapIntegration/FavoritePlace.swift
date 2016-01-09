//
//  FavoritePlaces.swift
//  MapIntegration
//
//  Created by Karlo Pagtakhan on 01/09/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class FavoritePlace {
    var name:String = ""
    var longtitude: CLLocationDegrees = 0
    var latitude: CLLocationDegrees = 0
    
    init(){
    
    }
    
    init(name:String, latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        self.name = name
        self.longtitude = longitude
        self.latitude = latitude
    }
}
