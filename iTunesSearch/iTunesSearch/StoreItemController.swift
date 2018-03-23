//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by Lohen Yumnam on 23/03/18.
//  Copyright © 2018 Caleb Hicks. All rights reserved.
//

import Foundation

struct StoreItemController {
    func fetchItems(matching query: [String: String], completion: @escaping ([StoreItem]?) -> Void) {
        let baseURL = URL(string: "https://itunes.apple.com/search")!
        
        guard let url = baseURL.withQueries(query) else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            
            if let error = error {
                print(error)
                completion(nil)
            } else {
                guard let data = data else { print("Data is nill"); completion(nil);  return}
                guard let storeItems = try? jsonDecoder.decode(StoreItems.self, from: data) else {print("Fail to decode JSON data"); completion(nil); return}
                completion(storeItems.results)
                
            }
            
        }
        
        task.resume()
    }
}
