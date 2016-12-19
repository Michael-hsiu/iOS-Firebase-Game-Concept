//
//  ViewController.swift
//  Pokefinder App
//
//  Created by Michael Hsiu on 12/4/16.
//  Copyright © 2016 Michael Hsiu. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet var mapView: MKMapView!
    var mapHasCenteredOnce = false
    var geoFire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad ran here!")
        
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow    // Map follows user location
        
        geoFireRef = FIRDatabase.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)

        // Begin added code
        //let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        //centerMapOnLocation(location: loc)
        // End added code
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        print("locationAuthStatus() ran here!")
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {    // Only get location when app in use
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true    // If authorized, show user location
        }
        print("locationManager - didChangeAuth ran here!")
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)  // 2000 m, latitude and longitude
        
        mapView.setRegion(coordinateRegion, animated: false)
        print("centerMapOnLocation ran here!")
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let location = userLocation.location {   // Keep map centered on user when there are updates
            if !mapHasCenteredOnce {
                centerMapOnLocation(location: location)
                mapHasCenteredOnce = true   // Only center map once, when screen first loads
            }
        }

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Custom annotation for user
        // CONFIGURATION FOR ALL ANNOTATIONS before displaying on map
        
        let annoIdentifier = "Pokemon"
        var annotationView: MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self) {     // If this is a user location annotation ...
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView?.image = UIImage(named: "MapPointer.png")    // The user-pic annotation
        } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier) {
            annotationView = deqAnno
            annotationView?.annotation = annotation
        } else {    // Called if 'dequeue' fails, need to make a default annotation
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)    // Popup appears with map icon alongside it
            annotationView = av
        }
        
        if let annotationView = annotationView, let anno = annotation as? PokeAnnotation {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "\(anno.pokemonNumber)")
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "MapIcon.png"), for: .normal)    // Pic alongside button text
            annotationView.rightCalloutAccessoryView = btn
        }
        
        return annotationView
    }
    
    func createSighting(forLocation location: CLLocation, withPokemon pokeId: Int) {
        // Store Pokemon by ID
        geoFire.setLocation(location, forKey: "\(pokeId)")  // Sets location in Firebase Database for specific piece of data (MAGIC HAPPENS HERE!!)
    }
    
    func showSightingsOnMap(location: CLLocation) {
        let circleQuery = geoFire!.query(at: location, withRadius: 2.5)     // Radius of 2.5 km
        
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            if let key = key, let location = location {
                let anno = PokeAnnotation(coordinate: location.coordinate, pokemonNumber: Int(key)!)
                self.mapView.addAnnotation(anno)    // Add annotation to the map
                print("ANNOTATION ADDED!!!")
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        // Show things even when player pans, scrolls, swipes
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        showSightingsOnMap(location: loc)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let dungeonVC = UIStoryboard(name: "Dungeons", bundle: nil).instantiateViewController(withIdentifier: "DungeonEntrance") as! DungeonEntranceViewController
        self.present(dungeonVC, animated: true, completion: nil)
        
        
        
        // For Apple Maps integration, accessory button pressed
        
         /* if let anno = view.annotation as? PokeAnnotation {
            let place = MKPlacemark(coordinate: anno.coordinate)
            let destination = MKMapItem(placemark: place)
            
            destination.name = "Pokemon Sighting"
            let regionDistance: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
            
            // Shows driving directions on map
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
            
            MKMapItem.openMaps(with: [destination], launchOptions: options)
        } */
    }
    
    
    
    @IBOutlet var spotRandomDungeonButton: UIButton!
    
    var pressed = false

    @IBAction func spotRandomDungeon(_ sender: Any) {
        if !pressed {
            let image = UIImage(named: "Haha Emoji.png")
            spotRandomDungeonButton.setImage(image, for: .normal)
            pressed = true
        } else {
            let image = UIImage(named: "PolyLogo.png")
            spotRandomDungeonButton.setImage(image, for: .normal)
            pressed = false
        }
        
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        let rand = arc4random_uniform(6) + 1
        createSighting(forLocation: loc, withPokemon: Int(rand))    // Create the sighting
        print("SIGHTING CREATED!")
    }

    
    @IBAction func unwindToMapViewController(segue:UIStoryboardSegue) {
        
        print("I am unwinding!")
    }
    
}

