//
//  DogBreedAPIManager.swift
//  DogGO
//
//  Created by Nick Ryan on 8/29/24.
//

import Foundation

class DogBreedAPIManager {
    static let shared = DogBreedAPIManager()
    private let baseURL = "https://dog.ceo/api/breeds/list/all"
    
    private init() {}
    
    func fetchBreeds(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpRespone = response as? HTTPURLResponse, (200...299).contains(httpRespone.statusCode) else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(BreedListResponse.self, from: data)
                let breeds = decodedResponse.message.keys.sorted()
                completion(.success(breeds))
            } catch {
                completion(.failure(APIError.decodingError(error)))
            }
        }
        task.resume()
    }
    
    struct BreedListResponse: Codable {
        let message: [String: [String]]
    }
    
    enum APIError: LocalizedError {
        case invalidURL
        case invalidResponse
        case noData
        case decodingError(Error)
        
        var errorDescription: String? {
            switch self {
                    case .invalidURL:
                        return "The URL provided was invalid."
                    case .invalidResponse:
                        return "The server return an invalid response"
                    case .noData:
                        return "No data was received from the server"
                    case .decodingError(let error):
                        return "Failed to decode the data: \(error.localizedDescription)"

                    }
                }
            }
        }
    
