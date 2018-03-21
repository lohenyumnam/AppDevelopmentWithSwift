//
//  PhotoInfoController.swift
//  SpacePhoto
//
//  Created by Lohen Yumnam on 17/03/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import Foundation

struct PhotoInfoController {
    func fetchPhotoInfo(completion: @escaping (PhotoInfo?) -> Void)
    {
        let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
        
        let query: [String: String] = [
            "api_key": "DEMO_KEY",
            ]
        
        let url = baseURL.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            
            guard let data = data else { print("Didn't get the data"); return }
            do {
                let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
                //print(photoInfo)
                completion(photoInfo)
            } catch {
                print(error)
                completion(nil)
            }
            
//            if let data = data,
//                let photoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data) {
//                completion(photoInfo)
//            } else {
//                print("Either no data was returned, or data was not serialized.")
//                completion(nil)
//            }
        }
        task.resume()
    }
}



