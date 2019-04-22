#!/usr/bin/swift

import Foundation

struct Color: Decodable {
    let name: String
    let hex: String
    
    var camelCaseName: String {
        let firstCharacter = name.first!
        let lowercase = String(firstCharacter).lowercased()
        let newString = name.replacingCharacters(in: ...name.startIndex, with: lowercase)
        return newString.replacingOccurrences(of: " ", with: "")
    }
}

struct ColorContent: Codable {
    struct Info: Codable {
        let version: UInt64 = 1
        let author: String = "xcode"
    }
    
    let info: Info
    let colors: [Colors]
    
    var data: Data {
        return (try? JSONEncoder().encode(self)) ?? Data()
    }
    
    init(r: UInt64, g: UInt64, b: UInt64) {
        info = .init()
        colors = [.init(r: r, g: g, b: b)]
    }
    
    struct Colors: Codable {
        struct Color: Codable {
            struct Components: Codable {
                let red: String
                let green: String
                let blue: String
                let alpha: String = "1.000"
                
                init(r: UInt64, g: UInt64, b: UInt64) {
                    red = "\(Float(r) / 255)"
                    green = "\(Float(g) / 255)"
                    blue = "\(Float(b) / 255)"
                }
            }
            
            let colorSpace: String = "srgb"
            let components: Components
            
            init(r: UInt64, g: UInt64, b: UInt64) {
                components = .init(r: r, g: g, b: b)
            }
            
            private enum CodingKeys: String, CodingKey {
                case colorSpace = "color-space"
                case components
            }
        }
        
        let idiom: String = "universal"
        let color: Color
        
        init(r: UInt64, g: UInt64, b: UInt64) {
            color = .init(r: r, g: g, b: b)
        }
    }
}

class ColorGenerator {
    var path: URL {
        return URL(string: "file://" + FileManager.default.currentDirectoryPath)!
    }
    
    func generate() {
        let result = Result { try Data(contentsOf: path.appendingPathComponent("Colors.json")) }
        
        switch result {
        case .success(let data):
            let colors = (try? JSONDecoder().decode([Color].self, from: data)) ?? []
            for color in colors {
                let scanner = Scanner(string: color.hex)
                var value: UInt64 = 0
                scanner.scanHexInt64(&value)
                let red = (value & 0xFF0000) >> 16
                let green = (value & 0xFF00) >> 8
                let blue = value & 0xFF
                let content = ColorContent(r: red, g: green, b: blue)
                print("\(color.camelCaseName)||\(color.hex)")
                
                let contentsPath = path.appendingPathComponent("Colors.xcassets").appendingPathComponent(color.camelCaseName + ".colorset")
                if let string = String.init(data: content.data, encoding: .utf8) {
                    do {
                        try FileManager.default.createDirectory(atPath: contentsPath.path, withIntermediateDirectories: true, attributes: nil)
                        try string.write(toFile: contentsPath.appendingPathComponent("Contents.json").path, atomically: true, encoding: .utf8)
//                        print(contentsPath)
                    } catch {
                        print(error)
                    }
                }
                
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

//can't use the Kraken class until after the declaration
let kraken = ColorGenerator()
kraken.generate()
