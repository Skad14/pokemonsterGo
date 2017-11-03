//
//  ViewController.swift
//  PokemonsterGo
//
//  Created by Rafael on 10/30/17.
//  Copyright © 2017 Rafael. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    var gerenciadorLocalizacao = CLLocationManager()
    var contador = 0
    var coreDataPokemonster: CoreDataPokemonster!
    var pokemonsters: [Pokemonster] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapa.delegate = self
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
        //Recuperar
        self.coreDataPokemonster = CoreDataPokemonster()
        self.pokemonsters = self.coreDataPokemonster.recuperarPokemonster()
        
        //Exibir
        Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { (timer) in
            if let coordenadas = self.gerenciadorLocalizacao.location?.coordinate {
                
                let totalPokemonsters = UInt32(self.pokemonsters.count)
                let indicePokemonsters = arc4random_uniform(totalPokemonsters)
                
                let pokemonster = self.pokemonsters[Int(indicePokemonsters)]
                
                let anotacao = PokemonsterAnotacao(coordenadas: coordenadas, pokemonster: pokemonster)
                
                let latAleatoria = (Double(arc4random_uniform(400)) - 200 ) / 100000.0
                let longAleatoria = (Double(arc4random_uniform(400)) - 200 ) / 100000.0
                
                anotacao.coordinate.latitude += latAleatoria
                anotacao.coordinate.longitude += longAleatoria
            
                self.mapa.addAnnotation(anotacao)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            anotacaoView.image = #imageLiteral(resourceName: "player")
        }else {
            
            let pokemonster = (annotation as! PokemonsterAnotacao).pokemonster
            anotacaoView.image = UIImage(named: pokemonster.nomeImagem!)
        }
        
        var frame = anotacaoView.frame
        frame.size.height = 40
        frame.size.width = 40
        
        anotacaoView.frame = frame
        
        return anotacaoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let anotacao = view.annotation
        let pokemonster = (view.annotation as! PokemonsterAnotacao).pokemonster
        
        mapView.deselectAnnotation(anotacao, animated: true)
        
        if anotacao is MKUserLocation {
         return
        }
        
        if let cordenadasAnotacao = anotacao?.coordinate {
            
            let regiao = MKCoordinateRegionMakeWithDistance(cordenadasAnotacao, 200, 200)
            mapa.setRegion(regiao, animated: true)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coordenadasUsr = self.gerenciadorLocalizacao.location?.coordinate {
                
                if MKMapRectContainsPoint(self.mapa.visibleMapRect, MKMapPointForCoordinate(coordenadasUsr)) {
                    self.coreDataPokemonster.salvarPokemonster(pokemon: pokemonster)
                    self.mapa.removeAnnotation(anotacao!)
                    let alertController = UIAlertController(title: "Parabéns!",
                                                            message: "Você capturou o pokemonster: \(pokemonster.nome!)",
                                                            preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(ok)
                    
                    self.present(alertController, animated: true, completion: nil)
                }else {
                    
                    let alertController = UIAlertController(title: "Você está longe!",
                                                            message: "Você precisa estar mais perto para capturar o \(pokemonster.nome!)",
                        preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(ok)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if contador < 3 {
            
            self.centralizar()
            contador += 1
        }else {
            
            gerenciadorLocalizacao.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse && status != .notDetermined {
            
            let alertController = UIAlertController(title: "Permissão de Localização", message: "Para que você possa caçar pokemonsters, o jogo necessita de sua localização.", preferredStyle: .alert)
            
            let acaoConfiguracoes = UIAlertAction(title: "Abrir Configurações", style: .default, handler: { (alertaConfiguracoes) in
                if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(configuracoes as URL)
                }
            })
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertController.addAction(acaoConfiguracoes)
            alertController.addAction(acaoCancelar)
            
            present(alertController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centralizar() {
        if let coordenadas = gerenciadorLocalizacao.location?.coordinate {
            
            let regiao = MKCoordinateRegionMakeWithDistance(coordenadas, 200, 200)
            mapa.setRegion(regiao, animated: true)
        }
    }
    
    @IBAction func bussola(_ sender: Any) {
        
        self.centralizar()
    }
    
    @IBAction func pokedex(_ sender: Any) {
        
    }
}
