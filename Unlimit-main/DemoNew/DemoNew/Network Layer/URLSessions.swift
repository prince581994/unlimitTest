//
//  URLSessions.swift
//  DemoNew
//

//

import Foundation

class NetworkManager {
    
    func getRequest(url: String, completion: @escaping (Jokes)-> ()) {
        
        if let url = URL(string: url) {
            
         let task =   URLSession.shared.dataTask(with: url) {data, res, err in
                guard let data = data else {return print("error with data")}
             
                do {
                    let joke = try JSONDecoder().decode(String.self, from: data)
                    completion(Jokes(joke: joke))
                     }
                catch {
                         print("Error decoding response: \(error)")
                     }
                 }
                 
            task.resume()
             }
    }
    
}
