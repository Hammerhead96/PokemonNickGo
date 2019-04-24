//
//  CoreDataHelper.swift
//  PokemonNickGo
//
//  Created by Mac User on 4/23/19.
//  Copyright © 2019 Hammerhead96. All rights reserved.
//
/*
 Icons made by [https://www.flaticon.com/authors/roundicons-freebies] from www.flaticon.com
 E.g.: Icon made by Roundicons Freebies from www.flaticon.com
 
 
 <div>Icons made by <a href="https://www.flaticon.com/authors/roundicons-freebies" title="Roundicons Freebies">Roundicons Freebies</a> from <a href="https://www.flaticon.com/"
 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"
 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
 */
import UIKit
import CoreData

func addAllPokemon() {
    createPokemon(name: "Pikachu", imageName: "pikachu-2")
    createPokemon(name: "Meowth", imageName: "meowth")
    createPokemon(name: "Pidgey", imageName: "pidgey")
    createPokemon(name: "Zubat", imageName: "zubat")
    createPokemon(name: "Snorlax", imageName: "snorlax")
    createPokemon(name: "Psyduck", imageName: "psyduck")
    createPokemon(name: "Mew", imageName: "mew")
    createPokemon(name: "Mankey", imageName: "mankey")
    createPokemon(name: "Bullbasaur", imageName: "bullbasaur")
    createPokemon(name: "Abra", imageName: "abra")
    createPokemon(name: "Charmander", imageName: "charmander")
    createPokemon(name: "Caterpie", imageName: "caterpie")
    
}

func createPokemon(name:String, imageName:String) {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let pokemon = Pokemon(entity: Pokemon.entity(), insertInto: context)
        pokemon.name = name
        pokemon.imageName = imageName
        try? context.save()
    }
}

func getAllPokemon() -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        print("in get all pokemon")
        if let pokeData = try? context.fetch(Pokemon.fetchRequest()) as? [Pokemon] {
            if let pokemons = pokeData {
                if pokemons.count == 0 {
                    addAllPokemon()
                    return getAllPokemon()
                }
                return pokemons
            }
        }
    }
    print("An error getting all Pokemon has occured")
    return []
}

func getCaughtPokemon() -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        fetchRequest.predicate = NSPredicate(format: "caught = %d", true)
        if let pokemons = try? context.fetch(fetchRequest) {
            return pokemons
        }
    }
    print("An error getting caught Pokemon has occured")
    return []
}

func getUnCaughtPokemon() -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        fetchRequest.predicate = NSPredicate(format: "caught = %d", false)
        if let pokemons = try? context.fetch(fetchRequest) {
            return pokemons
        }
    }
    print("An error getting unCaught Pokemon has occured")
    return []
}
