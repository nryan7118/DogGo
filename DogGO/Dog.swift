//
//  Item.swift
//  DogGO
//
//  Created by Nick Ryan on 8/23/24.
//

import Foundation
import SwiftData

@Model
final class Dog {
    var name: String
    var dob: Date
    var breed: String
    var allergies: [String]
    var likes: [String]
    var dislikes: [String]
    var scheduledEvent: [String]
    var scheduledTime: [String]
    var ownerName: [String]
    var ownerPhone: [String]
    var emergencyContact: String
    var emergencyContactPhone: String
    var specialInstructions: String
    var vetInformation: VetInformation
    
    init(name: String, dob: Date, breed: String, allergies: [String], likes: [String], dislikes: [String], scheduledEvent: [String], scheduledTime: [String], ownerName: [String], ownerPhone: [String], emergencyContact: String, emergencyContactPhone: String, specialInstructions: String, vetInformation: VetInformation) {
        self.name = name
        self.dob = dob
        self.breed = breed
        self.allergies = allergies
        self.likes = likes
        self.dislikes = dislikes
        self.scheduledEvent = scheduledEvent
        self.scheduledTime = scheduledTime
        self.ownerName = ownerName
        self.ownerPhone = ownerPhone
        self.emergencyContact = emergencyContact
        self.emergencyContactPhone = emergencyContactPhone
        self.specialInstructions = specialInstructions
        self.vetInformation = vetInformation
    }
    }

@Model
final class VetInformation {
    var vetFirstName: String
    var vetLastName: String
    var vetAddress1: String
    var vetAddress2: String
    var vetCity: String
    var vetState: String
    var vetZip: String
    var vetPhoneNumber: String

    init(vetFirstName: String, vetLastName: String, vetAddress1: String, vetAddress2: String, vetCity: String, vetState: String, vetZip: String, vetPhoneNumber: String) {
        self.vetFirstName = vetFirstName
        self.vetLastName = vetLastName
        self.vetAddress1 = vetAddress1
        self.vetAddress2 = vetAddress2
        self.vetCity = vetCity
        self.vetState = vetState
        self.vetZip = vetZip
        self.vetPhoneNumber = vetPhoneNumber
    }
}

