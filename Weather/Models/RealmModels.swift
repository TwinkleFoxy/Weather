//
//  RealmModels.swift
//  Weather
//
//  Created by Алексей Однолько on 22.02.2024.
//

import RealmSwift

class RealmCityStorageModel: Object {
    @Persisted var cityName: String = ""
    @Persisted var lat: Double = 0.0
    @Persisted var lon: Double = 0.0
    @Persisted(primaryKey: true) var id: String = ""

    convenience init(cityName: String, lat: Double, lon: Double) {
        self.init()
        self.cityName = cityName
        self.lat = lat
        self.lon = lon
        self.id = "\(lat)\(lon)"
    }
}

