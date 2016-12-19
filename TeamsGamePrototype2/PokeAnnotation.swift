//
//  PokeAnnotation.swift
//  Pokefinder App
//
//  Created by Michael Hsiu on 12/4/16.
//  Copyright © 2016 Michael Hsiu. All rights reserved.
//

import Foundation
import MapKit

let pokemon = ["pikachu", "squirtle", "bulbasaur", "mew", "mewtwo", "zapdos"]

class PokeAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    var pokemonNumber: Int
    var pokemonName: String
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, pokemonNumber: Int) {  // The constructor for a PokeAnnotation
        self.coordinate = coordinate
        self.pokemonNumber = pokemonNumber
        self.pokemonName = pokemon[pokemonNumber - 1].capitalized   // Goes into 'pokemon' array, uses ID to find the right pokemon
        self.title = self.pokemonName
    }
}
