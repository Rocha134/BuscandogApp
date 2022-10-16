//
//  FoundDogViewController.swift
//  Buscandog
//
//  Created by Francisco Rocha Juárez on 13/10/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import CoreLocation

class FoundDogViewController: UIViewController{
    
    var photoTaken: UIImage?
    var urlGlobal : String?
    var longitudeGlobal = 0.0
    var latitudeGlobal = 0.0
    private var locationManager: CLLocationManager?
    private var userLocation: CLLocation?
    
    let db = Firestore.firestore()
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    //MARK: -Properties
    
    private var imagePicker: UIImagePickerController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func uploadPhotoToFirebase(){
        //1. Asegurar que la foto exista
        guard let imageSaved = photoTaken,
              let imageSavedData: Data = imageSaved.jpegData(compressionQuality: 0.1) else{
                  
                  return
              }
        
        //CONFIGURACION PARA GUARDAR LA FOTO EN FIREBASE
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        
        //Crear una referencia al storage de firebase
        let storage = Storage.storage()
        
        
        //Crear nombre de la imagen a subir
        if let usuarioActual = Auth.auth().currentUser?.email{
            let imageName = usuarioActual as String + String(Date().timeIntervalSince1970)
            //Referencia a la carpeta donde se va a guardar la foto
            let folderReference = storage.reference(withPath: "fotosDePerros/\(imageName).jpg")
            //Subir la foto a Firebase
            DispatchQueue.global(qos: .background).async {
                folderReference.putData(imageSavedData, metadata: metaDataConfig) { (metaData: StorageMetadata?, error: Error?) in
                    DispatchQueue.main.async {
                        //Detener la carga
                        if let error = error{
                            print(error.localizedDescription)
                            return
                        }
                        //obtener la URL de descarga
                        folderReference.downloadURL { (url: URL?, error: Error?) in
                            print(url?.absoluteString ?? "")
                            self.urlGlobal = url?.absoluteString
                        }
                    }
                }
            }
        }
        
      
        
        
    }
    
    private func openCamera(){
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .photo
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        
        present(imagePicker, animated: true, completion: nil)

    }
    
    
    @IBAction func photoButton(_ sender: UIButton) {
        openCamera()
    }
    
    //MANDAR INFORMACIÓN DEL PERRO A LA BASE DE DATOS
    @IBAction func sendPressed(_ sender: UIButton) {
        if let dogBreed = breedTextField.text,
           breedTextField.text != "",
           let dogWeight = weightTextField.text,
           weightTextField.text != "",
           let dogHeight = heightTextField.text,
           heightTextField.text != "",
           let dogColor = colorTextField.text,
           colorTextField.text != "",
           let dogSex = sexTextField.text,
           sexTextField.text != "",
           let dogDescription = descriptionTextField.text,
           descriptionTextField.text != "",
           let dogImage = urlGlobal,
           urlGlobal != "",
           longitudeGlobal != 0.0,
           latitudeGlobal != 0.0,
           let dogPostMaker = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data:
                [K.FStore.breedField: dogBreed,
                 K.FStore.weightField: dogWeight,
                 K.FStore.heightField: dogHeight,
                 K.FStore.colorField: dogColor,
                 K.FStore.sexField: dogSex,
                 K.FStore.latitudeField: latitudeGlobal,
                 K.FStore.longitudeField: longitudeGlobal,
                 K.FStore.descriptionField: dogDescription,
                 K.FStore.postMakerField: dogPostMaker,
                 K.FStore.dateField: Date().timeIntervalSince1970,
                 K.FStore.urlField: dogImage
                ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to Firestore, \(e)")
                } else{
                    print("Succesfully saved data")
                    DispatchQueue.main.async {
                        self.breedTextField.text = ""
                        self.weightTextField.text = ""
                        self.heightTextField.text = ""
                        self.colorTextField.text = ""
                        self.sexTextField.text = ""
                        self.descriptionTextField.text = ""
                        self.performSegue(withIdentifier: K.reportHomeSegue, sender: self)
                    }
                }
            }
        }
    }
    
}

//MARK: -UIImagePickerControllerDelegate
extension FoundDogViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //cuando se toma o no se toma la foto
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //cerrar la cámara
        imagePicker?.dismiss(animated: true, completion: nil)
        
        if info.keys.contains(.originalImage){
            //previewImageView.isHidden = false
         //obtenemos la imagen tomada
            photoTaken = info[.originalImage] as? UIImage
            uploadPhotoToFirebase()
        }
    }
}

extension FoundDogViewController: CLLocationManagerDelegate{
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
