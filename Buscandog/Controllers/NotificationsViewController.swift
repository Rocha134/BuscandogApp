//
//  NotificationsViewController.swift
//  Buscandog
//
//  Created by Francisco Rocha Juárez on 17/10/22.
//

import UIKit

class NotificationsViewController: UIViewController{
    
    let notifications : [Notifications] = []
    
    @IBOutlet weak var notificationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        title = "Mis notificaciones 💬"
        notificationsTableView.register(UINib.init(nibName: K.cellNotificationNibName, bundle: nil), forCellReuseIdentifier: K.cellNotificationsIdentifier)
    }
    
    
}

extension NotificationsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return notifications.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Fetch a cell of the appropriate type.
        let cell = notificationsTableView.dequeueReusableCell(withIdentifier: K.cellNotificationsIdentifier, for: indexPath) as! NotificationTableViewCell
        
        //let notification = notifications[indexPath.row]
        
        //Configure the cell´s contents.
        //cell.titleLabel.text = notification.title
        
        return cell
    }
    
    
}

extension NotificationsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Este código se ejecuta una vez que se selecciona una celda
        print("\(indexPath.row)")
    }
    
}
