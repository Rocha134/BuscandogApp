//
//  Constants.swift
//  Buscandog
//
//  Created by Francisco Rocha Juárez on 13/10/22.
//

struct K {
    static let appName = "Buscandog 🐶"
    static let cellIdentifier = "PostCell"
    static let cellNibName = "PostTableViewCell"
    static let registerSegue = "RegisterToHome"
    static let loginSegue = "LoginToHome"
    
    struct FStore {
        static let collectionName = "dogs"
        static let placeField = "place"
        static let dateField = "date"
        static let sexField = "sex"
        static let breedField = "breed"
        static let weightField = "weight"
        static let heightField = "height"
        static let colorField = "color"
        static let descriptionField = "description"
        static let postMakerField = "postMaker"
    }
}
