//
//  Data.swift
//  Covid-19
//
//  Created by Erik Westervind on 2020-09-10.
//  Copyright © 2020 Erik Andersson. All rights reserved.
//

import Foundation
import SwiftUI
var countryData: () = Data().load { (countries) in countries}
class Data {



func load(completion: @escaping ([Responses]) -> Void) {
    let headers = [
        "x-rapidapi-host": "covid-193.p.rapidapi.com",
        "x-rapidapi-key": "YOUR API"
    ]
    let request = NSMutableURLRequest(url: NSURL(string:  "https://covid-193.p.rapidapi.com/statistics")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error)
        } else {
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse)
            let decoder = JSONDecoder()
            let responses = try! decoder.decode(JSONData.self, from: data!)
            
            DispatchQueue.main .async {
                //countryData.append(contentsOf: responses.response!)
                //return responses.response!
                completion(responses.response!)
            }
            
        }
    })
    
    dataTask.resume()
}
}
