//
//  DarkSkyAPIHelper.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 3/3/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftyJSON

class DarkSkyAPIHelper {
    
    static let requestURL = "https://api.darksky.net/forecast/4c848cb3b78ca57411554fbe43840959"

    static func findForecast(lat: CLLocationDegrees, lon: CLLocationDegrees, time: Double, withBlock : @escaping (String) -> ()) {
        let latString = "\(lat)"
        let lonString = "\(lon)"
        let timeString = "\(Int(time))"
        var resultString: String?
        let url = requestURL + "/" + latString + "," + lonString + "," + timeString
        Alamofire.request(url).responseData { (response) in
            if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                
                let json = try? JSON(data: response.data!)
                let icon = json!["currently"]["icon"]
                resultString = icon.description
                withBlock(resultString!)
                
            }
        }
    }
    
   
}
