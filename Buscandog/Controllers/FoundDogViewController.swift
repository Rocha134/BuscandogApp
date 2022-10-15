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

class FoundDogViewController: UIViewController{
    
    let db = Firestore.firestore()
    @IBOutlet weak var placeTextField: UITextField!
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
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let dogPlace = placeTextField.text,
           placeTextField.text != "",
           let dogBreed = breedTextField.text,
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
           let dogPostMaker = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data:
                [K.FStore.placeField: dogPlace,
                 K.FStore.breedField: dogBreed,
                 K.FStore.weightField: dogWeight,
                 K.FStore.heightField: dogHeight,
                 K.FStore.colorField: dogColor,
                 K.FStore.sexField: dogSex,
                 K.FStore.descriptionField: dogDescription,
                 K.FStore.postMakerField: dogPostMaker,
                 K.FStore.dateField: Date().timeIntervalSince1970
                ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to Firestore, \(e)")
                } else{
                    print("Succesfully saved data")
                    DispatchQueue.main.async {
                        self.placeTextField.text = ""
                        self.breedTextField.text = ""
                        self.weightTextField.text = ""
                        self.heightTextField.text = ""
                        self.colorTextField.text = ""
                        self.sexTextField.text = ""
                        self.descriptionTextField.text = ""
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
        
        /*if info.keys.contains(.originalImage){
            //previewImageView.isHidden = false
         //obtenemos la imagen tomada
            //previewImageView.image = info[.originalImage] as? UIImage
        }*/
    }
}
