//
//  NotificationsViewController.swift
//  Buscandog
//
//  Created by Francisco Rocha Juárez on 17/10/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class NotificationsViewController: UIViewController{
    
    var notifications : [Notifications] = []
    let db = Firestore.firestore()
    
    @IBOutlet weak var notificationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        title = "Mis notificaciones 💬"
        notificationsTableView.register(UINib.init(nibName: K.cellNotificationNibName, bundle: nil), forCellReuseIdentifier: K.cellNotificationsIdentifier)
        loadNotifications()
    }
    
    //CARGAR LA INFORMACIÓN DE LA BASE DE DATOS
    func loadNotifications(){
        
        notifications = []
        
        if let user = Auth.auth().currentUser?.email{
            
            db.collection(K.FStore.collectionNameUsers).document(user).collection(K.FStore.myNotificationsSubcollection).order(by: K.FStore.dateField, descending: true)
                .addSnapshotListener/*getDocument*/{ (querySnapshot, error) in
                    
                    self.notifications = []
                    
                    if let e = error{
                        let alertController = UIAlertController(title: "Error", message: "\(e.localizedDescription)", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                        
                        self.present(alertController, animated: true, completion: nil)
                        print("There was an issue retrieving data from Firestore. \(e)")
                    } else{
                        if let snapshotDocuments = querySnapshot?.documents{
                            for doc in snapshotDocuments{
                                let data = doc.data()
                                //let dogImage = procesarUrlAImagen(link: (data[K.FStore.urlField] as? String))
                                if let notificationTitle = data[K.FStore.titleField] as? String,
                                   let notificationCellPhoneNumber = data[K.FStore.notificationCellPhoneNumberField] as? String,
                                   let notificationType = data[K.FStore.notificationTypeField] as? String {
                                    let newNotification = Notifications(type: notificationType, cellphoneNumber: notificationCellPhoneNumber, titulo: notificationTitle)
                                    self.notifications.append(newNotification)
                                    DispatchQueue.main.async {
                                        self.notificationsTableView.reloadData()
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
    
}

extension NotificationsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Fetch a cell of the appropriate type.
        let cell = notificationsTableView.dequeueReusableCell(withIdentifier: K.cellNotificationsIdentifier, for: indexPath) as! NotificationTableViewCell
        
        let notification = notifications[indexPath.row]
        
        //Configure the cell´s contents.
        cell.titleLabel.text = notification.titulo
        cell.typeLabel.text = notification.type
        cell.numberLabel.text = "Número: \(notification.cellphoneNumber)"
        
        
        return cell
    }
    
    
}

extension NotificationsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Este código se ejecuta una vez que se selecciona una celda
        print("\(indexPath.row)")
    }
    
}
