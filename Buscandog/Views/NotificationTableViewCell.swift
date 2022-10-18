//
//  NotificationTableViewCell.swift
//  Buscandog
//
//  Created by Francisco Rocha Juárez on 17/10/22.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        // Configure the view for the selected state
        view1.layer.cornerRadius = view1.frame.size.height / 5
    }
    
}
