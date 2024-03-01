//
//  Extension+String.swift
//  Weather
//
//  Created by Алексей Однолько on 21.02.2024.
//

import Foundation

extension String {
    func spacesInQuery() -> String {
        guard let encodedText = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Invalid input encoded text")
            return ""
        }
        return encodedText
    }
    
    func reciveLastComponent() -> String {
        if let url = URL(string: self) {
            let fileName = url.lastPathComponent
            return fileName
        }
        return ""
    }
}
