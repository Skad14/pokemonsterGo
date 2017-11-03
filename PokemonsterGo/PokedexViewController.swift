//
//  PokedexViewController.swift
//  PokemonsterGo
//
//  Created by Rafael on 10/30/17.
//  Copyright © 2017 Rafael. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pokemonstersCapturados: [Pokemonster] = []
    var pokemonstersNaoCapturados: [Pokemonster] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let coreDataPokemonster = CoreDataPokemonster()
        
        self.pokemonstersCapturados = coreDataPokemonster.recuperarPokemonsterCapturados(capturado: true)
        self.pokemonstersNaoCapturados = coreDataPokemonster.recuperarPokemonsterCapturados(capturado: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Capturados"
        } else {
            return "Não Capturados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.pokemonstersCapturados.count
        }else {
            return self.pokemonstersNaoCapturados.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pokemonster: Pokemonster
        
        if indexPath.section == 0 {
            pokemonster = self.pokemonstersCapturados[indexPath.row]
        } else {
            pokemonster = self.pokemonstersNaoCapturados[indexPath.row]
        }
        
        let celula = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "celula")
        celula.textLabel?.text = pokemonster.nome
        celula.imageView?.image = UIImage(named: pokemonster.nomeImagem!)
        
        return celula
    }
    
    @IBAction func mapa(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
