//
//  NetworkingManager.swift
//  Currency
//
//  Created by Giorgi on 1/2/21.
//

import Foundation

struct NetworkingManager {
    
    static func getCurrencies(completion: @escaping(Data) -> Void) {
        let url = URL(string: "http://www.nbg.ge/rss.php")!

        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, _, error in

            if let error = error {
                print("DEBUG: \(error.localizedDescription) ")
                return
            }

            guard let data = data else {return}
            completion(data)
        }
        task.resume()
    }
}
