//
//  StorageService.swift
//  Weather
//
//  Created by Алексей Однолько on 21.02.2024.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa
import RxRelay

class StorageService {
    
    let cityStorageModel = BehaviorRelay<[CityStorageModel]>(value: [])
    private let bag = DisposeBag()
    
    private init() { cityStorageModel.accept(getCitys()) }
    
    private let dispatchGroup = DispatchGroup()
    static let shared = StorageService()
    
    func addToFavoriteOrDelete(cityStorage: CityStorageModel) {
            var citiesModels = cityStorageModel.value
            dispatchGroup.wait()
            dispatchGroup.enter()
            do {
                let realm = try Realm()
    
                if let existingModel = realm.object(ofType: RealmCityStorageModel.self, forPrimaryKey: "\(cityStorage.lat)\(cityStorage.lon)") {
                    try realm.write {
                        realm.delete(existingModel)
                    }
                    citiesModels.removeAll { $0.id == cityStorage.lat*cityStorage.lon }
                    cityStorageModel.accept(citiesModels)
                } else {
                    let newFavouriteCity = RealmCityStorageModel(cityName: cityStorage.cityName,
                                                                 lat: cityStorage.lat,
                                                                 lon: cityStorage.lon)
                    try realm.write {
                        realm.add(newFavouriteCity)
                    }
                    citiesModels.append(CityStorageModel(cityName: cityStorage.cityName,
                                                         lat: cityStorage.lat,
                                                         lon: cityStorage.lon))
                    cityStorageModel.accept(citiesModels)
                }
            } catch let error {
                print("Error accessing Realm in addToFavoriteOrDelete(): \(error)")
            }
            dispatchGroup.leave()
        }
    
    private func getCitys() -> [CityStorageModel] {
        
        do {
            let realm = try Realm()
            let allCityModels = realm.objects(RealmCityStorageModel.self)
            var cityStorageModel: [CityStorageModel] = []
            
            for cityModel in allCityModels {
                cityStorageModel.append(convertToCityStorageModel(realmModel: cityModel))
            }
            
            return cityStorageModel
        } catch let error {
            print("Error accessing Realm in getCitys(): \(error)")
            return []
        }
    }
}

private extension StorageService {
    
    private func convertToCityStorageModel(realmModel: RealmCityStorageModel) -> CityStorageModel {
        return CityStorageModel(cityName: realmModel.cityName, lat: realmModel.lat, lon: realmModel.lon)
    }
}
