//
//  Models.swift
//  Weather
//
//  Created by Алексей Однолько on 21.02.2024.
//

import Foundation
import UIKit

// MARK: - WeatherModel

struct WeatherExtendedModel: Decodable {
    let location: LocationModel
    let current: Current
    let forecast: Forecast
}

struct WeatherCurrentModel: Decodable {
    let location: LocationModel
    let current: Current
}

struct LocationModel: Decodable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String?
    let localtime_epoch: Int?
    let localtime: String?
}

extension LocationModel {
    var id: Double {
        lat * lon
    }
}

struct Current: Decodable {
    let last_updated_epoch: Int
    let last_updated: String
    let temp_c: Double
    let is_day: Int
    let condition: Condition
    let wind_mph: Double
    let wind_kph: Double
    let wind_degree: Double
    let wind_dir: String
    let pressure_mb: Double
    let precip_mm: Double
    let humidity: Double
    let cloud: Double
    let feelslike_c: Double
    let vis_km: Double
    let uv: Int
    let gust_mph: Double
}

struct ForecastDay: Decodable {
    let date: String
    let date_epoch: Int
    let day: Day
    let astro: Astro
    let hour: [Hour]
}

struct Condition: Decodable {
    let text: String
    let icon: String
    let code: Int
}

struct Day: Decodable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let avgtemp_c: Double
    let maxwind_mph: Double
    let totalprecip_mm: Double
    let avgvis_km: Double
    let avghumidity: Double
    let daily_will_it_rain: Int
    let daily_chance_of_rain: Double
    let daily_will_it_snow: Int
    let daily_chance_of_snow: Double
    let condition: Condition
    let uv: Int
}

struct Astro: Decodable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moon_phase: String
    let moon_illumination: Int
    let is_moon_up: Int
    let is_sun_up: Int
}

struct Hour: Decodable {
    let time_epoch: Int
    let time: String
    let temp_c: Double
    let is_day: Int
    let condition: Condition
    let wind_mph: Double
    let wind_degree: Double
    let wind_dir: String
    let pressure_mb: Double
    let precip_mm: Double
    let humidity: Double
    let cloud: Double
    let feelslike_c: Double
    let windchill_c: Double
    let heatindex_c: Double
    let dewpoint_c: Double
    let will_it_rain: Int
    let chance_of_rain: Double
    let will_it_snow: Int
    let chance_of_snow: Double
    let vis_km: Double
    let gust_mph: Double
    let uv: Int
    let short_rad: Double
    let diff_rad: Double
}

struct Forecast: Decodable {
    let forecastday: [ForecastDay]
}

// MARK: - CityStorageModel

struct CityStorageModel {
    var cityName: String
    var lat: Double
    var lon: Double
    var id: Double {
        self.lat*self.lon
    }
}
