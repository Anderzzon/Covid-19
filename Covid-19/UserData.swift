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
    @Published var countries: [Responses] = []
    @Published var filteredCountries: [Responses] = []
}




