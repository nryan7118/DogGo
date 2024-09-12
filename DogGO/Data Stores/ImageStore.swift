//
//  ImageStore.swift
//  DogGO
//
//  Created by Nick Ryan on 8/31/24.
//

import Foundation
import CloudKit
import CoreData


struct ImageStore {
    
    func saveImageLocally(imageData: Data, for dog: Dog) -> URL? {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let dogPhotoURL = documentsURL.appendingPathComponent("\(dog.name ?? UUID().uuidString).jpg")
        
        do {
            try imageData.write(to: dogPhotoURL)
            return dogPhotoURL
        } catch {
            print("Failed to save image: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveDogToCloudKit(dog: Dog) {
        let record = CKRecord(recordType: "Dog")

        // Save basic information to the record
                record["name"] = dog.name as CKRecordValue?
                record["dob"] = dog.dob as CKRecordValue?
                record["breed"] = dog.breed as CKRecordValue?
                
        if let photoData = dog.photo, let photoURL = saveImageLocally(imageData: photoData, for: dog) {
                    let asset = CKAsset(fileURL: photoURL)
            record["photo"] = asset
                }
        
        let privateDatabase = CKContainer.default().privateCloudDatabase
        privateDatabase.save(record)  { (saveRecord, error) in
            if let error = error {
                print("Failed to save dog to cloudKit: \(error.localizedDescription)")
            } else {
                print("Successfully saved dog to CloudKit")
            }
        }
    }
    
    func fetchDogFromCloudKit(recordID: CKRecord.ID, viewContext: NSManagedObjectContext) {
        let privateDatabase = CKContainer.default().privateCloudDatabase

        privateDatabase.fetch(withRecordID: recordID) { (record, error) in
            if let record = record {
                let dog = Dog(context: viewContext)
                dog.name = record["name"] as? String
                dog.dob = record["dob"] as? Date
                dog.breed = record["breed"] as? String
                
                if let asset = record["photo"] as? CKAsset, let fileURL = asset.fileURL {
                    
                        dog.photo = try? Data(contentsOf: fileURL)
                   
                }
                do {
                    try viewContext.save()
                    print("Successfully fetched and saved dog from CloudK9it")
                } catch {
                    print("Failed to save context: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("Failed to fetch dog from CLoudKit: \(error.localizedDescription)")
            }
        }
    }
}
