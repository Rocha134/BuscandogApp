//
//  DetailsViewController.swift
//  Buscandog
//
//  Created by Francisco Rocha Juárez on 15/10/22.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController{
    @IBOutlet weak var view1: UIView!
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var map: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view1.layer.cornerRadius = view1.frame.size.height / 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setupMap()
    }
    
    func setupMap(){
        map = MKMapView(frame: view1.bounds)
        
        view1.addSubview(map ?? UIView())
        
        setupMarker()
    }
    
    func setupMarker(){
        let marker = MKPointAnnotation()
        marker.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        marker.title = "Perro encontrado"
        marker.subtitle = "Aquí"
        
        map?.addAnnotation(marker)
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        guard let heading = CLLocationDirection(exactly: 12) else {
            return
        }
        
        map?.camera = MKMapCamera(lookingAtCenter: location, fromDistance: 30, pitch: .zero, heading: heading)
    }
    
    @IBAction func sendNumber(_ sender: UIBarButtonItem) {
    }
}
