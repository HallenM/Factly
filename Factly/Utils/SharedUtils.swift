//
//  SharedUtils.swift
//  Factly
//
//  Created by Moshkina on 13.10.2021.
//  Copyright © 2021 Joey Tawadrous. All rights reserved.
//

import Foundation

class SharedUtils {
    
    // MARK: POST
    /////////////////////////////////////////// */
    class func getFact(_ queryURL: String, callback: @escaping (_ queryURL: String, _ urlContents: String) -> Void) {
        let url = URL(string: queryURL)
        var request = URLRequest(url: url!)
        
        let session = URLSession.shared
        
        request.httpBody = queryURL.data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        let task = session.downloadTask(with: request, completionHandler: {(location, response, error) in
            guard let _:URL = location, let _:URLResponse = response, error == nil else {
                return
            }
            let urlContents: String = try! NSString(contentsOf: location!, encoding: String.Encoding.utf8.rawValue) as String
            guard let _:NSString = urlContents as NSString? else {
                return
            }
            
            callback(queryURL, urlContents)
        })
        
        task.resume()
    }
    
    
}
