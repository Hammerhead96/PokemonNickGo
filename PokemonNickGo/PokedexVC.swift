//
//  PokedexVC.swift
//  PokemonNickGo
//
//  Created by Mac User on 4/23/19.
//  Copyright © 2019 Hammerhead96. All rights reserved.
//

import UIKit

class PokedexVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = " this is row \(indexPath.row)"
        return cell
    }
    

    @IBAction func returnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
