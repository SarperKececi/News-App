//
//  APIService.swift
//  NewsApi
//
//  Created by Sarper Kececi on 27.01.2024.
//

import Foundation
final class APIService {
    
    static let shared = APIService()
    
    struct Constants {
        static let headLinesUrl = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=76a66e744eea4054afb2226d43f3ec06")
    }
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.headLinesUrl else {
            completion(.failure(NSError(domain: "APIServiceError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "APIServiceError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                
                let result = try JSONDecoder().decode(APIResponse.self, from: data)
                print("Articles : \(result.articles.count)")
                completion(.success(result.articles))
                
            
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

