//
//  FavouriteViewModel.swift
//  Weather
//
//  Created by Алексей Однолько on 20.02.2024.
//

import Foundation
import RxSwift
import RxRelay


final class FavouriteViewModel {
    
    enum ActionType {
        case pullToRefresh
        case loadMore
    }
    
    let uplateData = PublishRelay<ActionType>()
    let searchQuery = BehaviorRelay<String>(value: "")
    let weatherDataForPrisent = BehaviorRelay<[WeatherCurrentModel]>(value: [])
    private let favouriteCitiesList = BehaviorRelay<[CityStorageModel]>(value: [])
    private let weatherData = BehaviorRelay<[WeatherCurrentModel]>(value: [])
    private let networkService = NetworkService.shared
    private let storageService = StorageService.shared
    private let bag = DisposeBag()
    
    private var page: Int = 0
    private var pageSize: Int = 10
    
    init() {
        setup()
        loadData()
    }
    
    private func loadData() {
        loadForecastWithPaginationFor(cities: favouriteCitiesList.value)
    }
    
    func setup() {
        
        Observable.combineLatest(searchQuery, weatherData, favouriteCitiesList)
            .map { [weak self] in
                var filteredData: [WeatherCurrentModel] = []
                filteredData = self?.filteredWeatherData(searchQuery: $0.0, weatherData: $0.1) ?? []
                filteredData = self?.favouriteCitiesFor(weatherData: filteredData.isEmpty ? $0.1 : filteredData, favouriteList: $0.2) ?? []
                return filteredData
            }
            .bind(to: weatherDataForPrisent)
            .disposed(by: bag)
        
        Observable.combineLatest(searchQuery, weatherData)
            .filter { $0.0.isEmpty }
            .map { $1 }
            .bind(to: weatherDataForPrisent)
            .disposed(by: bag)
        
        weatherData
            .bind(to: weatherDataForPrisent)
            .disposed(by: bag)
        
        uplateData
            .bind { [weak self] action in
                switch action {
                case .pullToRefresh:
                    self?.updateWeatheForecast()
                case .loadMore:
                    self?.loadForecastWithPaginationFor(cities: self?.favouriteCitiesList.value ?? [])
                    
                }
            }
            .disposed(by: bag)
        
        StorageService.shared.cityStorageModel
            .bind { [weak self] in
                self?.favouriteCitiesList.accept($0)
            }
            .disposed(by: bag)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLikeUpdate(_:)), name: .dataUpdated, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension FavouriteViewModel {
    
    private func loadForecastWithPaginationFor(cities: [CityStorageModel]) {
        
        var value = weatherData.value
        
        // Рассчитываем offset на основе номера страницы и размера страницы
        let offset = page * pageSize
        
        guard offset < cities.count else {
            // Устраняет ошибку, если offset больше, чем общее количество городов
            return
        }
        
        let citiesToLoad = Array(cities[offset..<min(offset + pageSize, cities.count)])
        
        loadForecastFor(toLoad: citiesToLoad) { [weak self] models in
            value.insert(contentsOf: models, at: value.count)
            self?.weatherData.accept(value)
            self?.page += 1
        }
    }
    
    private func loadForecastFor(toLoad: [CityStorageModel], complition: @escaping (_ models: [WeatherCurrentModel]) -> ()) {
        var inWeather: [WeatherCurrentModel] = []
        
        let dispatchGroup = DispatchGroup()
        
        for city in toLoad {
            dispatchGroup.enter()
            networkService.fetchWeatherCurrentForecast(city: city.cityName) { model in
                defer {
                    dispatchGroup.leave()
                }
                if let model = model {
                    inWeather.append(model)
                }
            }
        }

        
        dispatchGroup.notify(queue: .main) { [weak self] in
            // Удаление данных, которых уже нет в списке избранных
            self?.removeAll(cities: toLoad, inCities: &inWeather)
            
            // Обновление данных
            complition(inWeather)
        }
    }
    
    private func updateWeatheForecast() {
        searchQuery.accept("")
        weatherData.accept([])
        page = 0
    }
    
    func filteredWeatherData(searchQuery: String, weatherData: [WeatherCurrentModel]) -> [WeatherCurrentModel] {
        return weatherData.filter { weatherCurrentModel in
            return weatherCurrentModel.location.name.lowercased().contains(searchQuery.lowercased())
        }
    }
    
    func favouriteCitiesFor(weatherData: [WeatherCurrentModel], favouriteList: [CityStorageModel]) -> [WeatherCurrentModel] {
        return weatherData.filter { weatherModel in
            let cityName = weatherModel.location.name.lowercased()
            return favouriteList.contains { storageModel in
                return cityName.contains(storageModel.cityName.lowercased())
            }
        }
    }
    
    private func findAbsenteesAndLoad(city: CityStorageModel) {
        let absentees = self.findAbsentees(newCity: [city] , inCities: self.weatherData.value )
        loadForecastFor(toLoad: absentees ) { models in
            var weatherDataTemp = self.weatherData.value
            weatherDataTemp.insert(contentsOf: models, at: self.weatherData.value.count )
            self.weatherData.accept(weatherDataTemp)
        }
    }

    
    private func findAbsentees(newCity: [CityStorageModel], inCities: [WeatherCurrentModel]) -> [CityStorageModel] {
        return newCity.filter { city in
            !inCities.contains { $0.location.name.lowercased() == city.cityName.lowercased() }
        }
    }
    
    private func removeAll(cities: [CityStorageModel], inCities: inout [WeatherCurrentModel]) {
        let citiesToRemove = inCities.filter { model in
            !cities.contains { $0.cityName.lowercased() == model.location.name.lowercased() }
        }
        
        inCities.removeAll { model in
            citiesToRemove.contains { $0.location.name.lowercased() == model.location.name.lowercased() }
        }
    }
    
    private func convertToCityStorage(_ model: WeatherCurrentModel) -> CityStorageModel{
        return CityStorageModel(cityName: model.location.name,
                                 lat: model.location.lat,
                                 lon: model.location.lon)
    }
    
    @objc private func handleLikeUpdate(_ notification: Notification) {
        if let cityModel = notification.userInfo?["cityModel"] as? CityStorageModel {
            findAbsenteesAndLoad(city: cityModel)
        }
    }
}


