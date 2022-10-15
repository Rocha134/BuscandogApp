//
//  DetailsViewController.swift
//  Buscandog
//
//  Created by Francisco Rocha Juárez on 15/10/22.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController{
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var imageImageView: UIImageView!
    
    var image: UIImage?
    var sex: String = ""
    var breed: String = ""
    var weight: String = ""
    var height: String = ""
    var color: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageImageView.image = image
        sexLabel.text = sex
        breedLabel.text = breed
        weightLabel.text = weight
        heightLabel.text = height
        colorLabel.text = color
    }
    
    
    @IBAction func sendNumber(_ sender: UIButton) {
    }
    
}
