//
//  CoreDataPokemonster.swift
//  PokemonsterGo
//
//  Created by Rafael on 10/30/17.
//  Copyright © 2017 Rafael. All rights reserved.
//

import UIKit
import CoreData

class CoreDataPokemonster {
    
    func getContext() -> NSManagedObjectContext{
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        return context!
    }
    
    func recuperarPokemonsterCapturados(capturado: Bool) -> [Pokemonster] {
        
        let context = self.getContext()
        
        let requisicao = Pokemonster.fetchRequest() as NSFetchRequest<Pokemonster>
        requisicao.predicate = NSPredicate(format: "capturado = %@", capturado as CVarArg)
        
        do {
            
            let pokemonster = try context.fetch(requisicao) as [Pokemonster]
            return pokemonster
            
        }catch {}
        
        return []
    }
    
    func recuperarPokemonster() -> [Pokemonster]{
        
        let context = self.getContext()
        
        do {
            let pokemonster = try context.fetch(Pokemonster.fetchRequest()) as! [Pokemonster]
            
            if pokemonster.count == 0 {
                self.adicionarPokemonster()
                return self.recuperarPokemonster()
            }
            
            return pokemonster
        }catch {}
        
        return []
    }
    
    func salvarPokemonster(pokemon: Pokemonster) {
        
        let context = self.getContext()
        pokemon.capturado = true
        
        do{
            try context.save()
        }catch {
            
        }
    }
    
    func adicionarPokemonster() {
        
        let context = self.getContext()
        
        self.criarPokemonster(nome: "Abra", nomeImagem: "abra", capturado: false)
        self.criarPokemonster(nome: "Bellsprout", nomeImagem: "bellsprout", capturado: false)
        self.criarPokemonster(nome: "Bullbasaur", nomeImagem: "bullbasaur", capturado: false)
        self.criarPokemonster(nome: "Caterpie", nomeImagem: "caterpie", capturado: false)
        self.criarPokemonster(nome: "Charmander", nomeImagem: "charmander", capturado: false)
        self.criarPokemonster(nome: "Dratini", nomeImagem: "dratini", capturado: false)
        self.criarPokemonster(nome: "Eevee", nomeImagem: "eevee", capturado: false)
        self.criarPokemonster(nome: "Jigglypuff", nomeImagem: "jigglypuff", capturado: false)
        self.criarPokemonster(nome: "Mankey", nomeImagem: "mankey", capturado: false)
        self.criarPokemonster(nome: "Meowth", nomeImagem: "meowth", capturado: false)
        self.criarPokemonster(nome: "Pidgey", nomeImagem: "pidgey", capturado: false)
        self.criarPokemonster(nome: "Pikachu", nomeImagem: "pikachu-2", capturado: true)
        self.criarPokemonster(nome: "Psyduck", nomeImagem: "psyduck", capturado: false)
        self.criarPokemonster(nome: "Rattata", nomeImagem: "Rattata", capturado: false)
        self.criarPokemonster(nome: "Snorlax", nomeImagem: "snorlax", capturado: false)
        self.criarPokemonster(nome: "Squirtle", nomeImagem: "squirtle", capturado: false)
        self.criarPokemonster(nome: "Venonat", nomeImagem: "venonat", capturado: false)
        self.criarPokemonster(nome: "Weedle", nomeImagem: "weedle", capturado: false)
        self.criarPokemonster(nome: "Zubat", nomeImagem: "zubat", capturado: false)
        
        do {
            try context.save()
        }catch {}
    }
    
    func criarPokemonster(nome: String, nomeImagem: String, capturado: Bool) {
        
        let context = self.getContext()
        let pokemonster = Pokemonster(context: context)
        pokemonster.nome = nome
        pokemonster.nomeImagem = nomeImagem
        pokemonster.capturado = capturado
    }
}
