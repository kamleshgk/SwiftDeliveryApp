//
//  BackEndService.swift
//  deliveries
//
//  Created by KamyFC on 17/09/18.
//  Copyright © 2018 KamyFC. All rights reserved.
//

import UIKit

class BackEndService: NSObject {

    typealias ServiceResult = ([Delivery]?, String) -> ()
    
    
    // 1
    var defaultSession = URLSession(configuration: .default)
    // 2
    var dataTask: URLSessionDataTask?
    var deliveries: [Delivery] = []
    var errorMessage = ""
    
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(7)
        configuration.timeoutIntervalForResource = TimeInterval(7)
        self.defaultSession = URLSession(configuration: configuration)
    }
    
    func getDeliveryResults(offSet: Int, completion: @escaping ServiceResult) {
        // 1
        dataTask?.cancel()
        // 2

        if var urlComponents = URLComponents(string: "https://mock-api-mobile.dev.lalamove.com/deliveries") {
            urlComponents.query = "offset=\(offSet)&limit=20"
            // 3
            guard let url = urlComponents.url else { return }
            // 4
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                //Ensure data dask is set to nil in all failure and success conditions
                defer { self.dataTask = nil }
                // 5
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                    DispatchQueue.main.async {
                        completion(self.deliveries, self.errorMessage)
                    }
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.updateResults(data)
                    // 6
                    DispatchQueue.main.async {
                        completion(self.deliveries, "")
                    }
                }
            }
            // 7
            dataTask?.resume()
        }
    }
    
    fileprivate func updateResults(_ data: Data) {
        var responseArray: [Any]?
        deliveries.removeAll()
        
        do {
            var resultFromServer: Any?
            resultFromServer = try JSONSerialization.jsonObject(with: data, options: [])
            
            if let respArr = resultFromServer as? [Any]{
                //response is array type
                responseArray = respArr
                print("//respone in array format")
            }
            
            //response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        for deliveryDictionary in responseArray as! [Dictionary<String, AnyObject>] {
            let id = deliveryDictionary["id"] as? Int
            let description = deliveryDictionary["description"] as? String
            let imageURL = deliveryDictionary["imageUrl"] as? String
            let location = deliveryDictionary["location"] as? NSDictionary
            let latitude = location!["lat"] as? Double
            let longitude = location!["lng"] as? Double
            let address = location!["address"] as? String
            
            let deliveryItem = Delivery()
            deliveryItem.id = id!
            deliveryItem.description = description!
            deliveryItem.imageURL = imageURL!
            deliveryItem.latitude = latitude!
            deliveryItem.longitude = longitude!
            deliveryItem.address = address!
            deliveries.append(deliveryItem)
        }
    }
    
}
