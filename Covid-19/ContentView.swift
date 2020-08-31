//
//  ContentView.swift
//  Covid-19
//
//  Created by Erik Westervind on 2020-08-30.
//  Copyright © 2020 Erik Andersson. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries: [Responses] = []
    @State private var filteredCountries: [Responses] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredCountries.indices, id: \.self) { index in
                    HStack {
                        Text("\(index+1)")
                        Text(self.filteredCountries[index].country)
                        //Text("\(self.filteredCountries[index].deaths!.total!)")
                        Text(String(format: "%.2f", self.filteredCountries[index].deaths!.perMil!))
                    }
                }
            }.font(.system(.footnote))
            .onAppear() {
                let countries = Api().getGames { (countries) in
                    self.countries = countries                  
                    
                    for i in 0...countries.count-1 {
                        if ((countries[i].population) != nil) {
                            
                            let newCountry = self.deathPerHundred(country: countries[i])
                            self.filteredCountries.append(newCountry)
                        }
                    }
                    
                    self.filteredCountries.sort {
                        //($0.deaths!.total!) > ($1.deaths!.total!)
                        ($0.deaths!.perMil!) > ($1.deaths!.perMil!)
                    }
                }
                
            }
            .navigationBarTitle("Death per 100.000", displayMode: .inline)
        }
    }
    func deathPerHundred(country: Responses) -> Responses {
        
        //Calculate death per 100.000 and add value to object:
        var country = country
        let population = country.population!
        let totalDeaths = country.deaths?.total
        let deathPerMil:Double = (Double(totalDeaths!) / Double(population)) * 100000
        country.deaths?.perMil = deathPerMil
        return country
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
