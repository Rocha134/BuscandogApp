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

class LostDogViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    //var dogSelected: Int?
    
    let db = Firestore.firestore()
    
    //Tenemos que llenar el arreglo de los perros del usuario
    
    var dogs : [DogFound] = []
    
    @IBOutlet weak var myDogsPickerView: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dogs.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myDogsPickerView.dataSource = self
        myDogsPickerView.delegate = self
    }
    
    
    //En esta parte obtenemos la información de la base de datos y llenamos el arreglo nombrado pickerData con Dogs
    func loadPosts(){
        
        dogs = []
        if let currentUser = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionNameUsers).document(currentUser as String).collection(K.FStore.collectionName).order(by: K.FStore.dateField, descending: true)
                .addSnapshotListener/*getDocument*/{ (querySnapshot, error) in
                    
                    self.dogs = []
                    
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
                                   let dogLatitude = data[K.FStore.latitudeField] as? Double,
                                   let dogLongitude = data[K.FStore.longitudeField] as? Double,
                                   let dogDescription = data[K.FStore.descriptionField] as? String {
                                    let newDog = DogFound(sex: dogSex, breed: dogBreed, weight: dogWeight, height: dogHeight, color: dogColor, description: dogDescription, image: procesarUrlAImagen(link: dogImage), latitude: dogLatitude, longitude: dogLongitude)
                                    self.dogs.append(newDog)
                                    DispatchQueue.main.async {
                                        //self.tableView.reloadData()
                                        //let indexPath = IndexPath(row: self.dogs.count-1, section: 0)
                                        //self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }
    
    
    
    @IBAction func reportAction(_ sender: Any) {
        
        //pickerData[picker.selectedRow(inComponent: 0)]
        
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
