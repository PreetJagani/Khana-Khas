//
//  NetworkManager.swift
//  Khana Khas
//
//  Created by Preet Jagani on 31/08/23.
//

import UIKit

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    private override init() {
        
    }
    
    func post(url: String, post: [String: Any], completion: @escaping ([String: Any], Error?) -> Void) {
        if let url = URL(string: url) {
            let session = URLSession.shared
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: post, options: [])
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("Error creating JSON data: \(error)")
                completion([:], error)
                return
            }
            
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    completion([:], error)
                    return
                }
                
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Response: \(jsonString)")
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data) as? Dictionary<String, Any> {
                                completion(json, nil)
                            } else {
                                completion([:], error)
                            }
                        } catch let error {
                            completion([:], error)
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        } else {
            completion([:], nil)
        }
    }
    
    func getImage(url: String, completion: @escaping (UIImage?)-> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = URL(string: url) else {
                completion(nil)
                return
            }
            URLSession.shared.dataTask(with: url) { data, res, error in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                completion(UIImage(data: data))
            }.resume()
        }
    }
}
