//
//  DogData.swift
//  DogApp
//
//  Created by spark-04 on 2024/06/10.
//

import Foundation

class DogData {
    
    static func fetchDogBreeds(completion: @escaping (Result<DogBreedsResponse, Error>) -> Void) {
        let url = URL(string: "https://dog.ceo/api/breeds/list/all")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil))) // データが存在しない場合はエラーを返す
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dogBreedsResponse = try decoder.decode(DogBreedsResponse.self, from: data)
                completion(.success(dogBreedsResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}


