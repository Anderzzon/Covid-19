//
//  DetailView.swift
//  Covid-19
//
//  Created by Erik Westervind on 2020-09-02.
//  Copyright © 2020 Erik Andersson. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    @EnvironmentObject private var userData: UserData
    
    let countryID: Int
    
    var body: some View {
        
        VStack {
            VStack(alignment: .leading) {
                
                //Cases
                Text("Cases")
                    .padding(.leading)
                    .padding(.top)
                    .font(.largeTitle)
                HStack {
                        VStack(alignment: .leading) {
                            Text("Total confirmed")
                                .font(.headline)
                                .padding(.bottom)
                            if self.userData.filteredCountries[countryID].cases?.total != nil {
                                Text("\(self.userData.filteredCountries[countryID].cases!.total!) cases")
                            } else {
                                Text("0")
                            }
                        }.frame(width: 150, alignment: .leading)
                    
                        VStack(alignment: .leading) {
                            Text("New")
                                .font(.headline)
                                .padding(.bottom)
                            if self.userData.filteredCountries[countryID].cases?.new != nil {
                                Text(self.userData.filteredCountries[countryID].cases!.new!)
                            } else {
                                Text("0")
                            }
                        }.frame(width: 90, alignment: .leading)
                    
                        VStack(alignment: .leading) {
                            Text("Critical")
                                .font(.headline)
                                .padding(.bottom)
                            if self.userData.filteredCountries[countryID].cases?.critical != nil {
                                Text("\(self.userData.filteredCountries[countryID].cases!.critical!) cases")
                            } else {
                                Text("0")
                            }
                        }
                    Spacer()
                }
                .padding()
                
                //Test
                Text("Tests")
                    .padding(.leading)
                    .padding(.top)
                    .font(.largeTitle)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Total tests")
                            .font(.headline)
                            .padding(.bottom)
                        if self.userData.filteredCountries[countryID].tests?.total != nil {
                            Text("\(self.userData.filteredCountries[countryID].tests!.total!) tests")
                        } else {
                            Text("0")
                        }
                    }.frame(width: 150, alignment: .leading)
                    
                    VStack(alignment: .leading) {
                        Text("Per 100k")
                            .font(.headline)
                            .padding(.bottom)
                        if self.userData.filteredCountries[countryID].tests?.perMil != nil {
                            Text(String(format: "%.2f",self.userData.filteredCountries[countryID].tests!.perMil!) + " tests")
                        } else {
                            Text("0")
                        }
                    }
                    Spacer()
                }
                .padding()
                
                //Deaths
                Text("Deaths")
                    .padding(.leading)
                    .padding(.top)
                    .font(.largeTitle)
                HStack {
                        VStack(alignment: .leading) {
                            Text("Total confirmed")
                                .font(.headline)
                                .padding(.bottom)
                            if self.userData.filteredCountries[countryID].deaths?.total != nil {
                                Text("\(self.userData.filteredCountries[countryID].deaths!.total!) cases")
                            } else {
                                Text("0")
                            }
                        }.frame(width: 150, alignment: .leading)
                    
                        VStack(alignment: .leading) {
                            Text("New")
                                .font(.headline)
                                .padding(.bottom)
                            if self.userData.filteredCountries[countryID].deaths?.new != nil {
                                Text(self.userData.filteredCountries[countryID].deaths!.new!)
                            } else {
                                Text("0")
                            }
                        }.frame(width: 90, alignment: .leading)
                    
                        VStack(alignment: .leading) {
                            Text("Per 100k")
                                .font(.headline)
                                .padding(.bottom)
                            if self.userData.filteredCountries[countryID].deaths?.perMil != nil {
                                Text(String(format: "%.2f",self.userData.filteredCountries[countryID].deaths!.perMil!) + " deaths")
                            } else {
                                Text("0")
                            }
                        }
                    Spacer()
                }
                .padding()
                Spacer()
            }
            VStack {
                Text("Updated")
                Text(formatDate(date: self.userData.filteredCountries[countryID].time!))
            }
            Spacer()
            .navigationBarHidden(true)
            .navigationBarHidden(false)
                .navigationBarTitle("\(self.userData.filteredCountries[countryID].country)")
                .navigationBarItems(trailing: VStack(alignment: .leading) {
                    Text("Continent: \(self.userData.filteredCountries[countryID].continent!)")
                    Text("Population: \(self.userData.filteredCountries[countryID].population!)" )
                })
        }
    }
}

func formatDate(date: String) -> String {
    let apiFormatter = DateFormatter()
    apiFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    if let date = apiFormatter.date(from: date) {
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return displayFormatter.string(from: date)
    }
    
    return "-"
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        //let userData = UserData()
        
        DetailView(countryID: 9)
        //        DetailView(country: .init(continent: nil, country: "Sweden", population: 10110062, cases: Cases(new: nil, active: 0, critical: 14, recovered: nil, total: 84532), deaths: Deaths(new: "+5", total: 5820, perMil: 57.15), tests: Tests(total: 1094856), day: "2020-09-02", time: "2020-09-02T14:30:07+00:00"))
    }
}
