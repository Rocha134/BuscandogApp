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
    @IBOutlet weak var messageTextfield: UITextField!
    
    var dogSelected: Int?
    
    let db = Firestore.firestore()
    
    var dogs : [Dog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.register(UINib.init(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadPosts()
        
    }
    
    func loadPosts(){
        dogs = []
        
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField, descending: true)
            .addSnapshotListener/*getDocument*/{ (querySnapshot, error) in
                
                self.dogs = []
                
                if let e = error{
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else{
                    if let snapshotDocuments = querySnapshot?.documents{
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            let dogImage = procesarUrlAImagen(link: (data[K.FStore.urlField] as? String)!)
                            if let dogPlace = data[K.FStore.placeField] as? String,
                               let dogSex = data[K.FStore.sexField] as? String,
                               let dogBreed = data[K.FStore.breedField] as? String,
                               let dogWeight = data[K.FStore.weightField] as? String,
                               let dogHeight = data[K.FStore.heightField] as? String,
                               let dogColor = data[K.FStore.colorField] as? String,
                               let dogDescription = data[K.FStore.descriptionField] as? String {
                                let newDog = Dog(place: dogPlace, sex: dogSex, breed: dogBreed, weight: dogWeight, height: dogHeight, color: dogColor, description: dogDescription, image: dogImage)
                                self.dogs.append(newDog)
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
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.postDetailSegue{
            if let nextViewController = segue.destination as? DetailsViewController{
                print(dogs[dogSelected!].sex)
                print(dogs[dogSelected!].sex)
                print(dogs[dogSelected!].breed)
                print(dogs[dogSelected!].weight)
                print(dogs[dogSelected!].height)
                print(dogs[dogSelected!].color)
                print(dogs[dogSelected!].place)
                
                nextViewController.image = dogs[dogSelected!].image
                nextViewController.sex = dogs[dogSelected!].sex
                nextViewController.breed = dogs[dogSelected!].breed
                nextViewController.weight = dogs[dogSelected!].weight
                nextViewController.height = dogs[dogSelected!].height
                nextViewController.color = dogs[dogSelected!].color
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
    let ImageUrl:URL = URL(string: link)!
    let imageData = try? Data(contentsOf: ImageUrl)
    return UIImage(data: imageData!)!
}

extension HomeViewController : UITableViewDataSource{
    // Return the number of rows for the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count //Count the items of the array
    }
    
    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dog = dogs[indexPath.row]
        
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! PostTableViewCell
        
        // Configure the cell’s contents.
        //cell.aboutNameLabel = dog.name
        //cell.ageLabel = dog.age
        cell.breedLabel.text = dog.breed
        cell.colorLabel.text = dog.color
        cell.descriptionLabel.text = dog.description
        cell.heightLabel.text = dog.height
        cell.imagePost.image = dog.image
        //cell.nameLabel.text = dog.name
        cell.placeLabel.text = dog.place
        //cell.postDateLabel.text = dog.date
        cell.weightLabel.text = dog.weight
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
