//
//  HomeViewController.swift
//  Buscandog
//
//  Created by Francisco Rocha Juárez on 13/10/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
    var dogSelected: Int?
    var filterSelected = 0
    
    let db = Firestore.firestore()
    
    var dogsFound : [DogFound] = []
    var dogsLost : [DogLost] = []
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.register(UINib.init(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        let dogAntiErrorFound = DogFound(sex: "Macho", breed: "Raza", weight: "Peso", height: "Altura", color: "Color", description: "Descripcion", image: UIImage(named: "logoWhite")!, latitude: 1.0, longitude: 1.0, date: 0.0, uniqueIdentifier: "Salu2", dogPostMaker: "ElCreador")
        
        let dogAntiErrorLost = DogLost(name: "Antierror", sex: "Macho", breed: "Raza", weight: "Peso", height: "Altura", color: "Color", description: "Descripcion", url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ", image: UIImage(named: "logoWhite")!, latitude: 1.0, longitude: 1.0, date: 0.0, uniqueIdentifier: "Salu2", dogPostMaker: "ElCreador")
        
        dogsFound.append(dogAntiErrorFound)
        dogsLost.append(dogAntiErrorLost)
        
        if dogsFound.count > 0  && dogsLost.count > 0{
            loadPosts(filterSelected: filterSelected)
        }
        
    }
    
    
    
    @IBAction func changeFilterAction(_ sender: UISegmentedControl) {
        filterSelected = filterSegmentedControl.selectedSegmentIndex
        loadPosts(filterSelected: filterSelected)
    }
    
    
    
    //CARGAR LA INFORMACIÓN DE LA BASE DE DATOS
    func loadPosts(filterSelected : Int){
        
        var colection = K.FStore.collectionFoundName
        
        if filterSelected == 1{
            colection = K.FStore.collectionLostName
        }
        
        dogsFound = []
        dogsLost = []
        
        db.collection(colection).order(by: K.FStore.dateField, descending: true)
            .addSnapshotListener/*getDocument*/{ (querySnapshot, error) in
                
                self.dogsFound = []
                self.dogsLost = []
                
                if let e = error{
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else{
                    if let snapshotDocuments = querySnapshot?.documents{
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            //let dogImage = procesarUrlAImagen(link: (data[K.FStore.urlField] as? String))
                            if let dogSex = data[K.FStore.sexField] as? String,
                               let dogBreed = data[K.FStore.breedField] as? String,
                               let dogWeight = data[K.FStore.weightField] as? String,
                               let dogHeight = data[K.FStore.heightField] as? String,
                               let dogColor = data[K.FStore.colorField] as? String,
                               let dogImage = data[K.FStore.urlField] as? String,
                               let dogLatitude = data[K.FStore.latitudeField] as? Double,
                               let dogLongitude = data[K.FStore.longitudeField] as? Double,
                               let dogDate = data[K.FStore.dateField] as? Double,
                               let dogDescription = data[K.FStore.descriptionField] as? String,
                               let dogPostMaker = data[K.FStore.postMakerField] as? String {
                                let dogUniqueIdentifier = dogPostMaker + String(dogDate)
                                if filterSelected == 1 {
                                    if let dogName = data[K.FStore.dogNameField] as? String,
                                       let dogURL = data[K.FStore.urlField] as? String{
                                            let newDog = DogLost(name: dogName, sex: dogSex, breed: dogBreed, weight: dogWeight, height: dogHeight, color: dogColor, description: dogDescription, url: dogURL, image: procesarUrlAImagen(link: dogImage), latitude: dogLatitude, longitude: dogLongitude, date: dogDate, uniqueIdentifier: dogUniqueIdentifier, dogPostMaker: dogPostMaker)
                                        self.dogsLost.append(newDog)
                                    }
                                } else{
                                    let newDog = DogFound(sex: dogSex, breed: dogBreed, weight: dogWeight, height: dogHeight, color: dogColor, description: dogDescription, image: procesarUrlAImagen(link: dogImage), latitude: dogLatitude, longitude: dogLongitude, date: dogDate, uniqueIdentifier: dogUniqueIdentifier, dogPostMaker: dogPostMaker)
                                    self.dogsFound.append(newDog)
                                }
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    //let indexPath = IndexPath(row: self.dogs.count-1, section: 0)
                                    //self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                }
                            }
                        }
                    }
                }
            }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            self.defaults.set(false, forKey: "KeepSignIn")
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.postDetailSegue{
            if let nextViewController = segue.destination as? DetailsViewController{
                if filterSelected == 0 {
                    nextViewController.longitude = dogsFound[dogSelected!].longitude
                    nextViewController.latitude = dogsFound[dogSelected!].latitude
                }else{
                    nextViewController.longitude = dogsLost[dogSelected!].longitude
                    nextViewController.latitude = dogsLost[dogSelected!].latitude
                }
            }
            
            /*@IBOutlet weak var map: MKMapView!
            @IBOutlet weak var image: UIImageView!
            @IBOutlet weak var sexLabel: UILabel!
            @IBOutlet weak var breedLabel: UILabel!
            @IBOutlet weak var weightLabel: UILabel!
            @IBOutlet weak var heightLabel: UILabel!
            @IBOutlet weak var colorLabel: UILabel!*/
            
            
        }
    }
    
}

func procesarUrlAImagen(link : String) -> UIImage {
    if link == ""{
        return UIImage(named: "logoWhite")!
    }
    let ImageUrl:URL = URL(string: link)!
    let imageData = try? Data(contentsOf: ImageUrl)
    return UIImage(data: imageData!)!
}

extension HomeViewController : UITableViewDataSource{
    // Return the number of rows for the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Count the items of the array
        if filterSelected == 0{
            return dogsFound.count
        }else{
            return dogsLost.count
        }
    }
    
    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! PostTableViewCell
        
        if filterSelected == 0{
            let dog = dogsFound[indexPath.row]
            
            // Configure the cell’s contents.
            cell.nameLabel.text = "Raza: \(dog.breed)"
            cell.aboutNameLabel.text = "About this dog"
            cell.weightLabel.text = dog.weight
            cell.heightLabel.text = dog.height
            cell.colorLabel.text = dog.color
            cell.descriptionLabel.text = dog.description
            cell.imagePost.image = dog.image
        }else{
            let dog = dogsLost[indexPath.row]
            
            // Configure the cell’s contents.
            cell.nameLabel.text = "\(dog.name)-\(dog.breed)"
            cell.aboutNameLabel.text = "About \(dog.name)"
            cell.weightLabel.text = dog.weight
            cell.heightLabel.text = dog.height
            cell.colorLabel.text = dog.color
            cell.descriptionLabel.text = dog.description
            cell.imagePost.image = dog.image
        }
        
        return cell
    }
    
}

extension HomeViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        dogSelected = indexPath.row
        performSegue(withIdentifier: K.postDetailSegue, sender: self)
    }
}
