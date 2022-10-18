//
//  LostDogViewController.swift
//  Buscandog
//
//  Created by Francisco Rocha Juárez on 16/10/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import CoreLocation

class LostDogViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var longitudeGlobal = 0.0
    var latitudeGlobal = 0.0
    
    private var locationManager: CLLocationManager?
    private var userLocation: CLLocation?
    
    var dogSelected : Int = 0
    
    let db = Firestore.firestore()
    
    //Tenemos que llenar el arreglo de los perros del usuario
    
    var dogs : [DogLost] = []
    //var pickerData : [DogLost] = []
    
    @IBOutlet weak var myDogsPickerView: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dogs.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return(dogs[row].name)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dogSelected = row
    }
    
    //Después de que aparece
    override func viewDidAppear(_ animated: Bool) {
        myDogsPickerView.dataSource = self
        myDogsPickerView.delegate = self
        print(dogs.count)
        dogSelected = 0
    }
    
    //En cuanto aparece
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPosts()
        requestLocation()
    }
    
    private func requestLocation(){
        //Validamos GPS ACTIVO
        guard CLLocationManager.locationServicesEnabled() else {
            print("location service is not enabled")
            return
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        
    }
    
    
    //En esta parte obtenemos la información de la base de datos y llenamos el arreglo nombrado pickerData con Dogs
    func loadPosts(){
        
        if let currentUser = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionNameUsers).document(currentUser as String).collection(K.FStore.myDogSubcollection).order(by: K.FStore.dateField, descending: true)
                .getDocuments{ [self] (querySnapshot, error) in
                    
                    if let e = error{
                        print("There was an issue retrieving data from Firestore. \(e)")
                    } else{
                        if let snapshotDocuments = querySnapshot?.documents{
                            for doc in snapshotDocuments{
                                let data = doc.data()
                                //let dogImage = procesarUrlAImagen(link: (data[K.FStore.urlField] as? String))
                                if let dogSex = data[K.FStore.sexField] as? String,
                                   let dogName = data[K.FStore.dogNameField] as? String,
                                   let dogBreed = data[K.FStore.breedField] as? String,
                                   let dogWeight = data[K.FStore.weightField] as? String,
                                   let dogHeight = data[K.FStore.heightField] as? String,
                                   let dogColor = data[K.FStore.colorField] as? String,
                                   let dogImage = data[K.FStore.urlField] as? String,
                                   let dogPostMaker = data[K.FStore.postMakerField] as? String,
                                   let dogDate = data[K.FStore.dateField] as? Double,
                                   let dogURL = data[K.FStore.urlField] as? String,
                                   //let dogLatitude = data[K.FStore.latitudeField] as? Double,
                                   //let dogLongitude = data[K.FStore.longitudeField] as? Double,
                                   let dogDescription = data[K.FStore.descriptionField] as? String {
                                    let dogUniqueIdentifier = dogName + dogPostMaker + String(dogDate)
                                    let newDog = DogLost(name: dogName, sex: dogSex, breed: dogBreed, weight: dogWeight, height: dogHeight, color: dogColor, description: dogDescription, url: dogURL, image: procesarUrlAImagen(link: dogImage), latitude: 1.1, longitude: 1.1, date: dogDate, uniqueIdentifier: dogUniqueIdentifier, dogPostMaker: dogPostMaker)
                                    //Ya tenemos el arreglo con los perros
                                    dogs.append(newDog)
                                    //print(self.dogs[self.dogs.count-1].name)
                                    //DispatchQueue.main.async {
                                        //self.tableView.reloadData()
                                        //let indexPath = IndexPath(row: self.dogs.count-1, section: 0)
                                        //self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                    //}
                                }
                            }
                            //print(dogs.count)
                        }
                    }
                }
        }
    }
    
    
    
    @IBAction func reportAction(_ sender: UIButton) {
        let dogName = dogs[dogSelected].name
           let dogBreed = dogs[dogSelected].breed
           let dogWeight = dogs[dogSelected].weight
           let dogHeight = dogs[dogSelected].height
           let dogColor = dogs[dogSelected].color
           let dogDescription = dogs[dogSelected].description
           let dogSex = dogs[dogSelected].sex
        let dogURL = dogs[dogSelected].url
        let dogPostMaker = dogs[dogSelected].dogPostMaker
        let dogDate = dogs[dogSelected].date
        let dogUniqueIdentifier = dogName + dogPostMaker + String(dogDate)
            db.collection(K.FStore.collectionLostName).document(dogUniqueIdentifier).setData(
                [K.FStore.dogNameField: dogName,
                 K.FStore.breedField: dogBreed,
                 K.FStore.weightField: dogWeight,
                 K.FStore.heightField: dogHeight,
                 K.FStore.colorField: dogColor,
                 K.FStore.sexField: dogSex,
                 K.FStore.latitudeField: latitudeGlobal,
                 K.FStore.longitudeField: longitudeGlobal,
                 K.FStore.descriptionField: dogDescription,
                 K.FStore.postMakerField: dogPostMaker,
                 K.FStore.dateField: Date().timeIntervalSince1970,
                 K.FStore.urlField: dogURL
                ])
            //Accedemos al usuario para añadir el identifier a los perros que encontró
            db.collection(K.FStore.collectionNameUsers).document(dogPostMaker).collection(K.FStore.myLostSubcollection).document(dogUniqueIdentifier).setData([K.FStore.uniqueDogIdentifierField:dogUniqueIdentifier])
            { (error) in
                if let e = error {
                    print("There was an issue saving data to Firestore, \(e)")
                } else{
                    print("Succesfully saved data")
                    DispatchQueue.main.async {
                        //Te manda a la principal cuando todo se guarda bien
                        self.performSegue(withIdentifier: K.reportLostHomeSegue, sender: self)
                    }
                }
            }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension LostDogViewController: CLLocationManagerDelegate{
    //Obtenemos resultados de la geolocalización
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let bestLocation = locations.last else {
            return
        }
        //Ya tenemos la ubicación del usuario! 🐶
        userLocation = bestLocation
        print(userLocation?.coordinate.latitude ?? 0.0)
        print(userLocation?.coordinate.longitude ?? 0.0)
        
        //Guardar longitud y latitud en la base de datos (Primero en variables globales)
        if let longitudeInFunction = userLocation?.coordinate.longitude, let latitudeInFunction = userLocation?.coordinate.latitude{
            longitudeGlobal = longitudeInFunction
            latitudeGlobal = latitudeInFunction
        }
    }
}
