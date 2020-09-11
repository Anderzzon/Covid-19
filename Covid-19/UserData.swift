//
//  UserData.swift
//  Covid-19
//
//  Created by Erik Westervind on 2020-09-01.
//  Copyright © 2020 Erik Andersson. All rights reserved.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var countries = [Responses] ()
    @Published var filteredCountries: [Responses] = []
    //@Published var allCountries: [Responses] = countryData
    
    init() {
                let headers = [
            "x-rapidapi-host": "covid-193.p.rapidapi.com",
            "x-rapidapi-key": "c9589de0a2msh50e44877df895e3p13c6e7jsn36f46b19e364"
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
                    self.countries = responses.response!
                    
                    for i in 0...self.countries.count-1 {
                        if ((self.countries[i].population) != nil) {
                            
                            let newCountry = self.deathPerHundred(country: self.countries[i])
                            let newCountry2 = self.testsPerHundred(country: newCountry)
                            self.filteredCountries.append(newCountry2)
                        }
                    }
                    
                    self.filteredCountries.sort {
                        //($0.deaths!.total!) > ($1.deaths!.total!)
                        ($0.deaths!.perMil!) > ($1.deaths!.perMil!)
                    }
                    
                    print("Hej from UserData")
                    //completion(responses.response!)
                    
                }
                
            }
        })
        
        dataTask.resume()
    }
    
    func deathPerHundred(country: Responses) -> Responses {
        
        //Calculate death per 100.000 and add value to object:
        var country = country
        let population = country.population!
        guard let totalDeaths = country.deaths?.total else {
            country.deaths?.total = 0
            country.deaths?.perMil = 0
            return country
        }
        let deathPerMil:Double = (Double(totalDeaths) / Double(population)) * 100000
        country.deaths?.perMil = deathPerMil
        //print("Deaths per 100k in \(country.country): \(country.deaths!.perMil)")
        return country
    }
    
    func testsPerHundred(country: Responses) -> Responses {
        
        //Calculate tests per 100.000 and add value to object:
        var country = country
        let population = country.population!
        guard let totalTests = country.tests?.total else {
            country.tests?.total = 0
            country.tests?.perMil = 0
            return country
        }
        let testsPerMil:Double = (Double(totalTests) / Double(population)) * 100000
        country.tests?.perMil = testsPerMil
        //print("Deaths per 100k in \(country.country): \(country.deaths!.perMil)")
        return country
    }
    
}


