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
    static let cellNotificationsIdentifier = "NotificationCell"
    static let cellNotificationNibName = "NotificationTableViewCell"
    static let registerSegue = "RegisterToHome"
    static let loginSegue = "LoginToHome"
    static let postDetailSegue = "postDetailSegue"
    static let reportHomeSegue = "reportToHomeSegue"
    static let myDogRegisterToHome = "myDogRegisterToHomeSegue"
    static let keepSignIn = "KeepSignInSegue"
    static let reportLostHomeSegue = "reportLostToHomeSegue"
    
    struct FStore {
        static let collectionFoundName = "dogsFound"
        static let collectionLostName = "dogsLost"
        static let dogNameField = "dogName"
        static let dateField = "date"
        static let sexField = "sex"
        static let breedField = "breed"
        static let weightField = "weight"
        static let heightField = "height"
        static let colorField = "color"
        static let descriptionField = "description"
        static let postMakerField = "postMaker"
        static let urlField = "url"
        static let latitudeField = "latitude"
        static let longitudeField = "longitude"
        static let uniqueDogIdentifierField = "uniqueDogIdentifier"
        
        static let collectionNameUsers = "users"
        static let nameField = "name"
        static let lastNameField = "lastName"
        static let cellPhoneNumberField = "cellPhoneNumber"
        static let emailField = "email"
        static let accountCreatedDateField = "accountCreatedDate"
        static let myDogSubcollection = "myDogs"
        static let myFoundSubcollection = "myFounds"
        static let myLostSubcollection = "myLosts"
        static let myNotificationsSubcollection = "myNotifications"
        
        static let titleField = "title"
        static let notificationCellPhoneNumberField = "cellPhoneNumber"
        static let notificationTypeField = "type"
    }
}
