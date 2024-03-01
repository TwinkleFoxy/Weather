//
//  BaseViewController.swift
//  Weather
//
//  Created by Алексей Однолько on 01.03.2024.
//

import UIKit

class BaseViewController: UIViewController {
    
    func setupTheme() {
        let isNightMode = Calendar.current.isNightTime()
        if isNightMode {
            setupDarkTheme()
        } else {
            setupLightTheme()
        }
    }
    
    // Светлая тема
    func setupLightTheme() {
        view.backgroundColor = .white
        
    }

    // Темная тема
    func setupDarkTheme() {
        view.backgroundColor = .black
    }
}
