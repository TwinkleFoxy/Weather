//
//  WeatherTableCellViewModel.swift
//  Weather
//
//  Created by Алексей Однолько on 01.03.2024.
//

import RxRelay
import RxSwift

final class WeatherTableCellViewModel {
    
    let likeStatus = BehaviorRelay<Bool>(value: false)
    let cityStorageModel = PublishRelay<[CityStorageModel]>()
    let weatherCurrentModel = BehaviorRelay<WeatherCurrentModel?>(value: nil)
    
    func likeButtonTapped() {
        if let weatherCurrentModel = weatherCurrentModel.value {
            let cityStorage = CityStorageModel(
                cityName: weatherCurrentModel.location.name,
                lat: weatherCurrentModel.location.lat,
                lon: weatherCurrentModel.location.lon)
            
            StorageService.shared.addToFavoriteOrDelete(cityStorage: cityStorage)
            NotificationCenter.default.post(name: .dataUpdated, object: nil, userInfo: ["cityModel": cityStorage])
        }
    }
}
