//
//  MainViewModel.swift
//  Weather
//
//  Created by Алексей Однолько on 20.02.2024.
//

import Foundation
import RxSwift
import RxRelay

final class MainViewModel {
    
    enum ActionType {
        case pullToRefresh
        case loadMore
    }
    
    let searchQuery = BehaviorRelay<String>(value: "Toronto")
    let weatherData = BehaviorRelay<[WeatherCurrentModel]>(value: [])
    let uplateData = PublishRelay<ActionType>()
    private let searchedCity = BehaviorRelay<[LocationModel]>(value: [])
    private let networkService = NetworkService.shared
    private let bag = DisposeBag()
    
    private var page: Int = 0
    private let pageSize: Int = 10
    
    init() {
        loadForecastFor(cities: ["Toronto"])
        setup()
    }
    
    private func setup() {
        searchQuery
            .filter { !$0.isEmpty }
            .bind { [weak self] in self?.searchCity(text: $0) }
            .disposed(by: bag)
        
        searchedCity
            .bind { [weak self] in
                self?.page = 0
                self?.weatherData.accept([])
                self?.loadForecastFor(cities: $0.map{ $0.name })
            }
            .disposed(by: bag)
        
        uplateData
            .bind { [weak self] action in
                switch action {
                case .pullToRefresh:
                    self?.weatherData.accept([])
                    self?.page = 0
                    self?.loadForecastFor(cities: self?.searchedCity.value.map { $0.name } ?? [""])
                case .loadMore:
                    self?.loadForecastFor(cities: self?.searchedCity.value.map { $0.name } ?? [""])
                }
            }
            .disposed(by: bag)
    }
    
    
    private func searchCity(text: String) {
        networkService.fetchCity(city: text) { [weak self] model in
            print(model)
            self?.searchedCity.accept(model)
        }
    }
    
    private func loadForecastFor(cities: [String]) {
        
        let dispatchGroup = DispatchGroup()
        
        // Рассчитываем offset на основе номера страницы и размера страницы
        let offset = page * pageSize
        
        guard offset < cities.count else {
            // Устраняет ошибку, если offset больше, чем общее количество городов
            return
        }
        
        let citiesToLoad = Array(cities[offset..<min(offset + pageSize, cities.count)])
        var value = weatherData.value
        for city in citiesToLoad {
            dispatchGroup.enter()
            networkService.fetchWeatherCurrentForecast(city: city) { model in
                if let model = model {
                    defer { dispatchGroup.leave() }
                    value.append(model)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.weatherData.accept(value)
            self?.page += 1
        }
    }
    
}


