//
//  CloudKitAPIManager.swift
//  DogGO
//
//  Created by Nick Ryan on 8/28/24.
//

import Foundation
import CloudKit

class CloudKitAPIManager {

    static let shared = CloudKitAPIManager()
    private let baseURL = "https://api.apple-cloudkit.com"
    private let containerID = "iCloud.dog"
    private let environment = "development"
    private let apiToken = "d15e7f3cf27d81aec2e5b4ee5219cc0d3a969c6f4e1a6c7fd77e368cc1f82a66"

    private init() {}

    func fetchRecords(limit: Int = 10) async throws -> [CustomCKRecord] {
        let urlString = "\(baseURL)/database/1/\(containerID)/\(environment)/public/records/query?ckAPIToken=\(apiToken)"

        guard let url = URL(string: urlString) else {
            throw CloudKitAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "Post"

        let requestBody: [String: Any] = [
            "query": [
                "recordType": "Dog"
            ],
            "resultsLimit": limit
        ]

        let requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        request.httpBody = requestData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw CloudKitAPIError.serverError(code: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedResponse = try decoder.decode(CKQueryResponse.self, from: data)

        return decodedResponse.records
    }
}

enum CloudKitAPIError: Error {
    case invalidURL
    case noData
    case serverError(code: Int)
}

struct CKQueryResponse: Codable {
    let records: [CustomCKRecord]
}

struct CustomCKRecord: Codable {
    let recordName: String
    let fields: [String: CKRecordField]
}

struct CKRecordField: Codable {
    let value: CKRecordFieldValue
}

enum CKRecordFieldValue: Codable {
    case string(String)
    case int(Int)
    case double(Double)
    case date(Date)
    case data(Data)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else if let dateValue = try? container.decode(Date.self) {
            self = .date(dateValue)
        } else if let dataValue = try? container.decode(Data.self) {
            self = .data(dataValue)
        } else {
            throw DecodingError.typeMismatch(
                CKRecordFieldValue.self, DecodingError.Context(
                    codingPath: decoder.codingPath, debugDescription: "Unsupported CKRecordFieldValue type"))
        }
    }
}
