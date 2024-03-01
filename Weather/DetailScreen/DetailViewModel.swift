//
//  DetailViewModel.swift
//  Weather
//
//  Created by Алексей Однолько on 20.02.2024.
//

import Foundation
import RxSwift
import RxRelay


final class DetailViewModel {
    
    struct DetailModel {
        var temp: String
        var windKph: String
        var windDegree: String
        var windDir: String
        var precipMm: String
        var humidity: String
        var feelslikeC: String
        var uv: String
        var sunrise: String
        var sunset: String
        var moonrise: String
        var moonset: String
        var precipmoonPhaseMm: String
    }
    
    let forecast = BehaviorRelay<DetailModel?>(value: nil)
    private let networkService = NetworkService.shared
    
    init(city: String) {
        self.loadForecastFor(city: city)
    }
    
    
    private func loadForecastFor(city: String) {
        networkService.fetchWeatherExtendedForecast(city: city) { [weak self] model in
            if let model = model {
                
                self?.forecast.accept(self?.prepareModelForDetailView(model: model))
            }
        }
    }
}

extension DetailViewModel {
    private func prepareModelForDetailView(model: WeatherExtendedModel) -> DetailModel {
        
        if let forecastDay = model.forecast.forecastday.first?.astro {
            
            return DetailModel(
                temp: "Temperature:  \(model.current.temp_c) C",
                windKph: "Wind: \(model.current.wind_kph) Kph",
                windDegree: "Wind Degree: \(model.current.wind_degree)",
                windDir: "Wind Direction: \(model.current.wind_dir)",
                precipMm: "Precip: \(model.current.wind_kph) mm",
                humidity: "Humidity: \(model.current.humidity)",
                feelslikeC: "Feels Like: \(model.current.feelslike_c) C",
                uv: "UV: \(model.current.uv)",
                sunrise: "Sunrise: \(forecastDay.sunrise)",
                sunset: "Sunset: \(forecastDay.sunset)",
                moonrise: "Moonrise: \(forecastDay.moonrise)",
                moonset: "Moonset: \(forecastDay.moonset)",
                precipmoonPhaseMm: "Moon Phase: \(forecastDay.moon_phase)")
            
        } else {
            return DetailModel(
                temp: "Temperature:  \(model.current.temp_c) C",
                windKph: "Wind: \(model.current.wind_kph) Kph",
                windDegree: "Wind Degree: \(model.current.wind_degree)",
                windDir: "Wind Direction: \(model.current.wind_dir)",
                precipMm: "Precip: \(model.current.wind_kph) mm",
                humidity: "Humidity: \(model.current.humidity)",
                feelslikeC: "Feels Like: \(model.current.feelslike_c) C",
                uv: "UV: \(model.current.uv)",
                sunrise: "Sunrise: N/A",
                sunset: "Sunset: N/A",
                moonrise: "Moonrise: N/A",
                moonset: "Moonset: N/A",
                precipmoonPhaseMm: "N/A")
        }
    }
}
