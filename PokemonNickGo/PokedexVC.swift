//
//  PokedexVC.swift
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

class PokedexVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var caughtPokemons : [Pokemon] = []
    var uncaughtPokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        uncaughtPokemons = getUnCaughtPokemon()
        caughtPokemons = getCaughtPokemon()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "CAUGHT"
        } else {
            return "UNCAUGHT"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return caughtPokemons.count
        } else {
            return uncaughtPokemons.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var pokemon : Pokemon
        if indexPath.section == 0 {
            pokemon = caughtPokemons[indexPath.row]
        } else {
            pokemon = uncaughtPokemons[indexPath.row]
        }
        if let imageName = pokemon.imageName {
            cell.imageView?.image = UIImage(named: imageName)
        }
        cell.textLabel?.text = pokemon.name
        return cell
    }
    

    @IBAction func returnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
