//
//  DownloadManager.swift
//  deliveries
//
//  Created by KamyFC on 17/09/18.
//  Copyright © 2018 KamyFC. All rights reserved.
//

import UIKit

class DownloadManager {
    
    static let shared = DownloadManager()
    
    //MARK: - Image Downloading
    func retrieveImage(for url: String, completion: @escaping (UIImage?) -> Void) {
        let placeholderImage = UIImage(named: "placeholder")
        guard let requestUrl = URL(string:url) else {
            completion(placeholderImage)
            return
        }
        let request = URLRequest(url:requestUrl)
        
        let sessionInfo = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = sessionInfo.dataTask(with: request) { (data, response, error) in
            
            // The download has finished.
            if let e = error {
                print("Error downloading thumbnail: \(e)")
                //Error getting image - return placeholder
                let thumbnail = UIImage(named: "placeholder")
                completion(thumbnail) 

            } else {
                
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        completion(image)

                    } else {
                        print("Couldn't get image: Image is nil")
                        //Error getting image - return placeholder
                        let thumbnail = UIImage(named: "placeholder")
                        completion(thumbnail)
                    }
                } else {
                    print("Couldn't get response code for some reason")
                    //Error getting image - return placeholder
                    let thumbnail = UIImage(named: "placeholder")
                    completion(thumbnail)
                }
            }
            
        }
        downloadPicTask.resume()
    }
}
