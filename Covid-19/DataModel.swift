//
//  DataModel.swift
//  Covid-19
//
//  Created by Erik Westervind on 2020-08-30.
//  Copyright © 2020 Erik Andersson. All rights reserved.
//

import SwiftUI



struct JSONData: Hashable, Codable {
    var get: String?
    var parameters: [Parameters]?
    var response: [Responses]?
    var errors: [Errors]?
    var results: Int?
}

struct Parameters: Hashable, Codable {
    var country: String?
}

struct Errors: Hashable, Codable {
    var error: String?
}

struct Responses: Hashable, Codable {
    var continent: String?
    var country: String
    var population: Int?
    var cases: Cases?
    var deaths: Deaths?
    var tests: Tests?
    var day: String?
    var time: String?
}

struct Cases: Hashable, Codable {
    var new: String?
    var active: Int?
    var critical: Int?
    var recovered: Int?
    //var 1M_pop: String?
    var total: Int?
}

struct Deaths: Hashable, Codable {
    var new: String?
    var total: Int?
    var perMil: Double? //Custom
}

struct Tests: Hashable, Codable {
    var total: Int?
    var perMil: Double?
}

//Make the variable country to confirm to Identifible for the List View:
extension Responses: Identifiable {
    var id: String? { return country }
}

class Api {
    
    func getGames(completion: @escaping ([Responses]) -> ()) {
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
                    completion(responses.response!)
                    
                }
                
            }
        })
        
        dataTask.resume()
    }
}
