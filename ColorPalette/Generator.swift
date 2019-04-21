//
//  Generator.swift
//  ColorPalette
//
//  Created by Gagandeep Singh on 21/4/19.
//  Copyright © 2019 Gagandeep Singh. All rights reserved.
//

import Foundation

public class Generator {
    lazy var path = Bundle(identifier: "com.deepgagan.ColorPalette")?.path(forResource: "Colors", ofType: "json")
    
    public init() {
        guard let path = path, let url = URL(string: "file://\(path)") else { print("Invalid path"); return }
        
        let data = try? Data(contentsOf: url)
        let json = Result { try JSONSerialization.jsonObject(with: data!, options: .allowFragments) }
        
        switch json {
        case .success(let colors):
            let col = (try? JSONDecoder().decode([Color].self, from: data!)) ?? []
            for color in col {
                let scanner = Scanner(string: color.hex)
                var value: UInt64 = 0
                scanner.scanHexInt64(&value)
                let red = (value & 0xFF0000) >> 16
                let green = (value & 0xFF00) >> 8
                let blue = value & 0xFF
                print(red, green, blue)
            }
            
        case .failure(let error):
            print(error)
        }
        
    }
}

struct Color: Decodable {
    let name: String
    let hex: String
}
