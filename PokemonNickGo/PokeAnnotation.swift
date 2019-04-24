//
//  PokeAnnotation.swift
//  PokemonNickGo
//
//  Created by Mac User on 4/23/19.
//  Copyright © 2019 Hammerhead96. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation {
    var coordinate : CLLocationCoordinate2D
    var pokemon : Pokemon
    init(coord: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
