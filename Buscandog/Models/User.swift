//
//  User.swift
//  Buscandog
//
//  Created by Francisco Rocha Juárez on 16/10/22.
//

import Foundation

struct User {
    let name: String
    let lastname: String
    let cellphoneNumber: String
    let email: String
    let accountCreatedDate : Double
    let myDogs : [DogFound]
    let myLostDogs : [String]
    let myFoundDogs : [String]
}
