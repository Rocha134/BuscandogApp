//
//  inicioViewController.swift
//  Buscandog
//
//  Created by Francisco Rocha Juárez on 12/10/22.
//

import UIKit

class inicioViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (defaults.bool(forKey: "KeepSignIn") == true){
            performSegue(withIdentifier: K.keepSignIn, sender: self)
        }
        // Do any additional setup after loading the view.
    }


}

