//
//  PokemonsterAnotacao.swift
//  PokemonsterGo
//
//  Created by Rafael on 10/30/17.
//  Copyright © 2017 Rafael. All rights reserved.
//

import UIKit
import MapKit

class PokemonsterAnotacao: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var pokemonster: Pokemonster
    
    init(coordenadas: CLLocationCoordinate2D, pokemonster: Pokemonster) {
        self.coordinate = coordenadas
        self.pokemonster = pokemonster
    }
}
