//
//  PostTableViewCell.swift
//  Buscandog
//
//  Created by Francisco Rocha Juárez on 13/10/22.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var view1: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        view1.layer.cornerRadius = view1.frame.size.height / 5
    }
    
}
