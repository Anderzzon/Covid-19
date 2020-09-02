//
//  ContentView.swift
//  Covid-19
//
//  Created by Erik Westervind on 2020-08-30.
//  Copyright © 2020 Erik Andersson. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    //@State private var countries: [Responses] = []
    //@State private var filteredCountries: [Responses] = []
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        NavigationView {
            List {
                ForEach(userData.filteredCountries.indices, id: \.self) { country in
                    HStack {
                        HStack {
                            Text("\(country + 1)")
                                .fontWeight(self.setHomeCountry(index: country, isHeadline: false))
                                .background(Circle()
                                    .strokeBorder(Color.red, lineWidth: 1)
                                    .background(Circle().foregroundColor(Color.red).opacity(self.getOpacity(index: country)))
                                    .frame(width: 30, height: 30))
                                .foregroundColor(self.setTextColor(index: country))
                        }.frame(width: 30)
                        HStack {
                            Text(self.userData.filteredCountries[country].country)
                                .fontWeight(self.setHomeCountry(index: country, isHeadline: true))
                        }
                        .frame(width: 150, alignment: .leading)
                        .padding(.leading)
                        Text(String(format: "%.2f", self.userData.filteredCountries[country].deaths!.perMil!) + " deaths / 100k").fontWeight(self.setHomeCountry(index: country, isHeadline: false))
                        //Text(country.country)
                    }
                }
            }.font(.system(.footnote))
                .onAppear() {
                    print("ContentView appeared!")
                    self.loadData()
                    
                    
            }
            .onDisappear() {
                print("ContentView disappeared!")
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _
                in
                print("Content is shown")
                self.loadData()
                
            }
            .navigationBarTitle("Covid-19 death per 100.000", displayMode: .inline)
            
        }
    }
    
    func loadData() {
        let countries = Api().getGames { (countries) in
            self.userData.countries = countries
            self.userData.filteredCountries.removeAll()
            
            for i in 0...countries.count-1 {
                if ((countries[i].population) != nil) {
                    
                    let newCountry = self.deathPerHundred(country: countries[i])
                    self.userData.filteredCountries.append(newCountry)
                }
            }
            
            self.userData.filteredCountries.sort {
                //($0.deaths!.total!) > ($1.deaths!.total!)
                ($0.deaths!.perMil!) > ($1.deaths!.perMil!)
            }
        }
    }
    
    func deathPerHundred(country: Responses) -> Responses {
        //Calculate death per 100.000 and add value to object:
        var country = country
        let population = country.population!
        let totalDeaths = country.deaths?.total
        let deathPerMil:Double = (Double(totalDeaths!) / Double(population)) * 100000
        country.deaths?.perMil = deathPerMil
        //print("Deaths per 100k in \(country.country): \(country.deaths!.perMil)")
        return country
    }
    
    func getOpacity(index: Int) -> Double {
        let listLength = userData.filteredCountries.count
        var opacity:Double = Double(index+1)/Double(listLength)
        //print("Index = \(index)")
        //print("List Length = \(listLength)")
        //print("Opacity = \(opacity)")
        opacity = 1-opacity
        
        return opacity
    }
    
    func setTextColor(index: Int) -> Color {
        if index < 130 {
            return Color.init(.white)
        }
        return Color.init(.red)
    }
    
    func setHomeCountry(index: Int, isHeadline: Bool) -> Font.Weight? {
        let locale = Locale.current
        
        guard let country = locale.localizedString(forRegionCode: locale.regionCode ?? "") else {
            return .medium
        }
        //print("\(country)")
        
        if userData.filteredCountries[index].country == country {
            return .black
        } else if isHeadline == true {
            return .medium
        }
        return .none
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
