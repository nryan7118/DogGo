//
//  Schedule+CoreDataProperties.swift
//  DogGO
//
//  Created by Nick Ryan on 8/28/24.
//
//

import Foundation
import CoreData


extension ScheduleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleEntity> {
        return NSFetchRequest<ScheduleEntity>(entityName: "ScheduleEntity")
    }

    @NSManaged public var scheduledTime: Date?
    @NSManaged public var scheduledEvent: String?
    @NSManaged public var scheduledCategory: String?

}

extension ScheduleEntity : Identifiable {

}
