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

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var manager = CLLocationManager()
    var updateCount = 0
    @IBOutlet weak var mapView: MKMapView!
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemons = getAllPokemon()
        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setUp()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    } // end of viewDidLoad()
    
    func random() -> Double {
        return (Double(arc4random_uniform(200)) - 100.0) / 50000.0
    }
    func poke() -> Pokemon {
        let randomIndex = Int(arc4random_uniform(UInt32(self.pokemons.count)))
        let randomPokemon = self.pokemons[randomIndex]
        return randomPokemon
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setUp()
        }
    }
    func setUp() {
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        mapView.delegate = self
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            if let center = self.manager.location?.coordinate {
                var annoCoord = center
                annoCoord.latitude += self.random()
                annoCoord.longitude += self.random()
                let anno = PokeAnnotation(coord: annoCoord, pokemon: self.poke())
                self.mapView.addAnnotation(anno)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        if view.annotation is MKUserLocation {
            // It's the trainer, ignore
        } else {
            if let center = manager.location?.coordinate {
                if let pokemonCenter = view.annotation?.coordinate {
                    let region = MKCoordinateRegion(center: pokemonCenter, latitudinalMeters: 200, longitudinalMeters: 200)
                    mapView.setRegion(region, animated: false)
                    if mapView.visibleMapRect.contains(MKMapPoint(center)) {
                        print("You can catch!")
                        if let pokeAnnotation = view.annotation as? PokeAnnotation {
                            pokeAnnotation.pokemon.caught = true
                            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                                try? context.save()
                                if let name = pokeAnnotation.pokemon.name {
                                    let alertVC = UIAlertController(title: "Success!", message: "You have caught a \(name)", preferredStyle: .alert)
                                    let pokedexAction = UIAlertAction(title: "PokeDex", style: .default, handler: { (action) in
                                        self.performSegue(withIdentifier: "toPokedex", sender: nil)
                                    })
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                                        alertVC.dismiss(animated: true, completion: nil)
                                    })
                                    alertVC.addAction(pokedexAction)
                                    alertVC.addAction(okAction)
                                    present(alertVC, animated: true, completion: nil)
                                }}}} else {
                        print("Tapped, but can't catch!")
                        if let pokeAnnotation = view.annotation as? PokeAnnotation {
                            if let name = pokeAnnotation.pokemon.name {
                                let alertVC = UIAlertController(title: "Failure!", message: "The \(name) was too far away to catch!", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                                    alertVC.dismiss(animated: true, completion: nil)
                                })
                                alertVC.addAction(okAction)
                                present(alertVC, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    static func createLocalUrl(forImageNamed name: String) -> URL? {
        
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(name).png")
        let path = url.path
        
        guard fileManager.fileExists(atPath: path) else {
            guard
                let image = UIImage(named: name),
                let data = image.pngData() //let data = UIImagePNGRepresentation(image), XCode gave me the fix for this instantly when I clicked the eror then it said what changed and I clicked, "Fix", unsure what happened with your version of XCode earlier.
                else { return nil }
            
            fileManager.createFile(atPath: path, contents: data, attributes: nil)
            return url
        }
        
        return url
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if annotation is MKUserLocation {
            // NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:@"myurl"]];
            // productImage.image = [NSImage imageWithData:imageData]; Reference lines I used from Objective C.
            //            annoView.image = UIImage(named: "player") Your old line, should probably delete this along with above lines
            let imgData = try! Data(contentsOf: MapVC.createLocalUrl(forImageNamed: "player")!); //grab out of the image bundle (which apparently is just a cache file underneath-the-hood. A cache file is really just a collection (dictionary, array, set, or something) that stays in memory.
            //https://stackoverflow.com/questions/21769092/can-i-get-a-nsurl-from-an-xcassets-bundle
            //https://stackoverflow.com/questions/316236/difference-between-uiimage-imagenamed-and-uiimage-imagewithdata Random things to know about image loading and cache.. read all of the answers, esp the older ones that mention iOS caches and eventually crashes from not releasing. Writing your own image cache is very wise for grpahics-intensive applications.
            let playerImage = UIImage(data: imgData);
            annoView.image = playerImage;
            
            var frame = annoView.frame
            frame.size.height = 30
            frame.size.width = 30
            annoView.frame = frame
        } else {
            if let pokeAnnotation = annotation as? PokeAnnotation {
                if let imageName = pokeAnnotation.pokemon.imageName {
                    annoView.image = UIImage(named: imageName)
                    var frame = annoView.frame
                    frame.size.height = 30
                    frame.size.width = 30
                    annoView.frame = frame } } }
        return annoView
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

