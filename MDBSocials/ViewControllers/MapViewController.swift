//
//  MapViewController.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 3/3/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var map: MKMapView!
    var toLocation: MKMapItem?
    var queryString: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        map = MKMapView(frame: view.frame)
        
        let request = MKLocalSearchRequest()
        
        request.naturalLanguageQuery = queryString!
        
        request.region = map.region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("There was an error searching for: \(request.naturalLanguageQuery) error: \(error)")
                return
            }
            let first = response.mapItems[0]
            self.toLocation = first
            let location = first.placemark.coordinate
            let viewRegion = MKCoordinateRegionMakeWithDistance(location, 200, 200)
            self.map.setRegion(viewRegion, animated: true)
        }
        
        
        view.addSubview(map)
        setUpAppleMaps()
        
        
        
    }
    
    func setUpAppleMaps() {
        let directions = UIBarButtonItem(title: "Directions", style: .plain, target: self, action: #selector(getDirections))
        self.navigationItem.rightBarButtonItem = directions
    }
    
    @objc func getDirections() {
        toLocation!.openInMaps(launchOptions: [:])
    }


}
