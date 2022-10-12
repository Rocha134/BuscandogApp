//
//  inicioViewController.swift
//  Buscandog
//
//  Created by Francisco Rocha Juárez on 12/10/22.
//

import UIKit
import CLTypingLabel

class inicioViewController: UIViewController {
    
    
    @IBOutlet weak var titleScreen: CLTypingLabel!
    
    @IBOutlet weak var title2: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleScreen.text = "Buscandog 🐶"
        title2.text = "by Kairen"
    }


}

