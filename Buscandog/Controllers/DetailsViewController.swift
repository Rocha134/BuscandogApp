//
//  DetailsViewController.swift
//  Buscandog
//
//  Created by Francisco Rocha Juárez on 15/10/22.
//

import UIKit
import MapKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class DetailsViewController: UIViewController{
    @IBOutlet weak var view1: UIView!
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var selectedIndex: Int = 0
    var notificationName: String = ""
    var notificationType: String = ""
    var notificationPostMaker: String = ""
    var notificationCellPhoneNumber: String = ""
    var notificationDogDate: Double = 0.0
    
    let db = Firestore.firestore()
    
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
        if let notificationAuth = Auth.auth().currentUser?.email{
            
            //Obtener notificationCellPhoneNumber
            let docRef = db.collection(K.FStore.collectionNameUsers).document(notificationAuth)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data()
                    self.notificationCellPhoneNumber = dataDescription![K.FStore.cellPhoneNumberField] as! String
                } else {
                    print("Document does not exist")
                }
            }
            
            let notificationDate = Date().timeIntervalSince1970
            db.collection(K.FStore.collectionNameUsers).document(notificationPostMaker).collection(K.FStore.myNotificationsSubcollection).document(notificationAuth as String + String(notificationDogDate)).setData(
                [K.FStore.titleField: notificationName,
                 K.FStore.notificationTypeField: notificationType,
                 K.FStore.notificationCellPhoneNumberField: notificationCellPhoneNumber,
                 K.FStore.dateField: notificationDate]) { (error) in
                     if let e = error {
                         print("There was an issue saving data to Firestore, \(e)")
                     } else{
                         print("Succesfully saved data")
                         DispatchQueue.main.async {
                             //Agregar alert "tu numero fue guardado"
                         }
                     }
                 }
        }
    }
}
