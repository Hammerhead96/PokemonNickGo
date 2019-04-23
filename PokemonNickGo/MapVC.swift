//
//  ViewController.swift
//  PokemonNickGo
/*
 Icons made by [https://www.flaticon.com/authors/roundicons-freebies] from www.flaticon.com
 E.g.: Icon made by Roundicons Freebies from www.flaticon.com
 
 
 <div>Icons made by <a href="https://www.flaticon.com/authors/roundicons-freebies" title="Roundicons Freebies">Roundicons Freebies</a> from <a href="https://www.flaticon.com/"
 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"
 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
 */
//  Created by Mac User on 4/23/19.
//  Copyright © 2019 Hammerhead96. All rights reserved.
//
//  *manager*.requestWhenInUseAuthorization()
//  Privacy - Location When In Use Usage Description

import UIKit
import MapKit

class MapVC: UIViewController, CLLocationManagerDelegate {
    var manager = CLLocationManager()
    var updateCount = 0
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
        } else {
            manager.requestWhenInUseAuthorization()
        }
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            if let center = self.manager.location?.coordinate {
                let anno = MKPointAnnotation()
                var annoCoord = center
                annoCoord.latitude += self.random()
                annoCoord.longitude += self.random()
                anno.coordinate = annoCoord
                //anno.coordinate = center
                self.mapView.addAnnotation(anno)
            }
        }
    } // end of viewDidLoad()
    func random() -> Double {
        return (Double(arc4random_uniform(200)) - 100.0) / 50000.0
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            if let center = manager.location?.coordinate {
                let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
            }
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    @IBAction func compassTouched(_ sender: Any) {
        if let center = manager.location?.coordinate {
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 300, longitudinalMeters: 300)
            mapView.setRegion(region, animated: true)
        }
    }
    


}

