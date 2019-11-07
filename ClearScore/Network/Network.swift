//
//  Network.swift
//  ClearScore
//
//  Created by Eric Sans Alvarez on 02/11/2019.
//  Copyright © 2019 Eric Sans Alvarez. All rights reserved.
//

import Foundation

typealias NetworkRequestCompletion = ((Report?, ErrorType?) -> Void)

class Network {
    static let manager = Network()
    
    let baseUrl = "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com"
    
    var request: URLRequest!
    let session = URLSession.shared
    
    func getAccount(completion: @escaping NetworkRequestCompletion) {
        guard let url = URL(string: baseUrl + "/prod/mockcredit/values") else {
            return
        }
        
        // Set-up request
        
        request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                // Back to main thread with network error
                DispatchQueue.main.async { completion(nil, .network) }
                return
            }
            
            if let json = data {
                do {
                    let account = try JSONDecoder().decode(Account.self, from: json)
                    let report = account.creditReportInfo
                    
                    // Back to main thread with our data
                    DispatchQueue.main.async { completion(report, nil) }
                } catch {
                    // Back to main thread with catched parsing error
                    DispatchQueue.main.async { completion(nil, .parsing) }
                }
            } else {
                // Back to main thread with unknown error
                DispatchQueue.main.async { completion(nil, .unknown) }
            }
        }
        task.resume()
    }
    
}
