//
//  CoreDataHelper.swift
//  PokemonNickGo
//
//  Created by Mac User on 4/23/19.
//  Copyright © 2019 Hammerhead96. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon() {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let pikachu = Pokemon(entity: Pokemon.entity(), insertInto: context)
        pikachu.name = "Pikachu"
        pikachu.imageName = "pikachu-2"
        try? context.save()
    }
}
