//
//  Extension+Calendar.swift
//  Weather
//
//  Created by Алексей Однолько on 22.02.2024.
//

import Foundation

extension Calendar {
    func isNightTime() -> Bool {
        let currentDate = Date()

        // Начало и конец ночи в формате часов
        let nightStartHour = 20
        let nightEndHour = 7

        // Текущий час
        let currentHour = component(.hour, from: currentDate)

        // Находится ли текущее время в промежутке между началом и концом ночи
        return currentHour >= nightStartHour || currentHour < nightEndHour
    }
}
