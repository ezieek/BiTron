//
//  Networking.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class Networking {
    
    private init() {}
    static let shared = NetworkingService()
    
    func request(_ urlPath: String, completion: @escaping (Result<Data, NSError>) -> Void) {
        
        guard let url = URL(string: urlPath) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, _, error) in
            
            if let unwrappedError = error {
                completion(.failure(unwrappedError as NSError))
            } else if let unwrappedData = data {
                completion(.success(unwrappedData))
            }
        }
        task.resume()
    }
}
