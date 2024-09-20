//
//  Vetnformation+CoreDataProperties.swift
//  DogGO
//
//  Created by Nick Ryan on 8/28/24.
//
//

import Foundation
import CoreData


extension VetInformationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VetInformationEntity> {
        return NSFetchRequest<VetInformationEntity>(entityName: "VetnformationEntity")
    }

    @NSManaged public var vetID: UUID?
    @NSManaged public var vetFirstName: String?
    @NSManaged public var vetLastName: String?
    @NSManaged public var vetAddress1: String?
    @NSManaged public var vetAddress2: String?
    @NSManaged public var vetCity: String?
    @NSManaged public var vetState: String?
    @NSManaged public var vetZip: String?
    @NSManaged public var vetPhoneNumber: String?

}

extension VetInformationEntity : Identifiable {

}
