//
//  MenuController.swift
//  Restaurant
//
//  Created by Lohen Yumnam on 26/03/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import Foundation

class MenuController {
    // This will let us share the instance of MenuController instead of creating for each VC which will readuce the no. of object used in the app
    static let shared = MenuController()
    
    let baseURL = URL(string: "http://localhost:8090")!
    
    /// **fetchCategories** it will fetch the JSON data for Categories
    func fetchCategories(completion: @escaping ([String]?) -> Void){
        let categoryURL = baseURL.appendingPathComponent("categories")
        let task = URLSession.shared.dataTask(with: categoryURL) { (data, response, error) in
            if let data = data,
                let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let categories = jsonDictionary?["categories"] as? [String]{
                completion(categories)
            } else {
                completion(nil)
            }
            
        }
        task.resume()
    }
    
    /// **fetchMenuItems** it will fetch the JSON data for menu list base on category
    func fetchMenuItems(categoryName: String, completion: @escaping([MenuItem]?) -> Void){
        let initailMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: initailMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components.url!
        
        let task = URLSession.shared.dataTask(with: menuURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data){
                completion(menuItems.items)
            } else{
                completion(nil)
            }
        }
        task.resume()
    }
    
    func submitOrder(menuIds: [Int], completion: @escaping(Int?) -> Void){
        let orderURL = baseURL.appendingPathComponent("order")
        
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data: [String: Any] = ["menuIds": menuIds]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        
        request.httpBody = jsonData // storing JSON data in httpBody
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let preparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data){
                completion(preparationTime.prepTime)
            } else{
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    
}
