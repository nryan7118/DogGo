//
//  Dog+CoreDataProperties.swift
//  DogGO
//
//  Created by Nick Ryan on 8/28/24.
//
//

import Foundation
import CoreData

extension DogEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DogEntity> {
        return NSFetchRequest<DogEntity>(entityName: "DogEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var dob: Date?
    @NSManaged public var breed: String?
    @NSManaged public var allergies: NSObject?
    @NSManaged public var likes: NSObject?
    @NSManaged public var dislikes: NSObject?
    @NSManaged public var ownerName: NSObject?
    @NSManaged public var ownerPhone: NSObject?
    @NSManaged public var emergencyContacts: String?
    @NSManaged public var emergencyContactPhone: String?
    @NSManaged public var specialInstructions: String?
    @NSManaged public var vetID: String?

}

extension DogEntity: Identifiable {
}
