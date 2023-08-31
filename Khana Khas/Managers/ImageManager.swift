//
//  ImageManager.swift
//  Khana Khas
//
//  Created by Preet Jagani on 31/08/23.
//

import UIKit

class ImageManager: NSObject {
    
    private let url = "http://localhost:8000/photo"
    
    static let shared = ImageManager()
    
    private var imageCache: [String: [String: Any]] = [:]
    private var fetchingNames: Set<String> = Set()
    
    private override init() {
        
    }
    
    func getImage(name: String, completion: @escaping ([String: Any]) -> Void) {
        if let image = imageCache[name] {
            completion(image)
            return
        }
        
        if fetchingNames.contains(name) {
            completion([:])
            return
        }
        
        fetchingNames.insert(name)
        NetworkManager.shared.post(url: url, post: ["name": name]) { dict, error in
            self.fetchingNames.remove(name)
            if let image = dict["res"] as? [String: Any] {
                self.imageCache[name] = image
                completion(image)
            } else {
                completion([:])
            }
        }
    }
}
