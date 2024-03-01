//
//  NetworkService.swift
//  Weather
//
//  Created by Алексей Однолько on 21.02.2024.
//

import Foundation

final class NetworkService {
    
    private init() { }
    
    static let shared = NetworkService()
    private let apiKey = "f81d788239ef4c4fb6b85324242002"
    private let dataQueue = DispatchQueue(label: "com.weather.app.dataQueue", attributes: .concurrent)
    
    enum TypeNetworkRequest {
        case current
        case forecast
    }
    
    private func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let emptyDataError = NSError(domain: "com.weather.app", code: 100, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(emptyDataError))
                return
            }
            
            do {
                let decodedData = try self.decodeData(data, ofType: T.self)
                completion(.success(decodedData))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }
        task.resume()
    }
    
    private func decodeData<T: Decodable>(_ data: Data, ofType type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
}

extension NetworkService {
    
    func fetchWeatherExtendedForecast(city: String, days: Int = 5, hour: Int = 12, completion: @escaping (WeatherExtendedModel?) -> Void) {
        let urlString = "https://api.weatherapi.com/v1/forecast.json?q=\(city.spacesInQuery())&days=\(days)&hour=\(hour)&key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        dataQueue.async { [weak self] in
            guard let self = self else { completion(nil); return }
            self.fetchData(from: url) { (result: Result<WeatherExtendedModel, Error>) in
                switch result {
                case .success(let weatherData):
                    completion(weatherData)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
    }
    
    
    func fetchWeatherCurrentForecast(city: String, days: Int = 5, hour: Int = 12, completion: @escaping (WeatherCurrentModel?) -> Void) {
        let urlString = "https://api.weatherapi.com/v1/current.json?q=\(city.spacesInQuery())&key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        dataQueue.async { [weak self] in
            guard let self = self else { completion(nil); return }
            self.fetchData(from: url) { (result: Result<WeatherCurrentModel, Error>) in
                switch result {
                case .success(let weatherData):
                    completion(weatherData)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
    }
    
    
    func fetchCity(city: String, days: Int = 5, hour: Int = 12, completion: @escaping ([LocationModel]) -> Void) {
        let urlString = "https://api.weatherapi.com/v1/search.json?q=\(city.spacesInQuery())&key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion([])
            return
        }
        
        dataQueue.async { [weak self] in
            guard let self = self else { completion([]); return }
            self.fetchData(from: url) { (result: Result<[LocationModel], Error>) in
                switch result {
                case .success(let weatherData):
                    completion(weatherData)
                case .failure(let error):
                    print("Error: \(error)")
                    completion([])
                }
            }
        }
    }
}
