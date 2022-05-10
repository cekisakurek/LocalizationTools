//
//  SortLocalization.swift
//  LocalizationTools
//
//  Created by Cihan Kisakurek on 11.05.22.
//

import Foundation
import ArgumentParser

struct SortLocalization: ParsableCommand {
    
    public static let configuration = CommandConfiguration(abstract: "Sort an iOS localization file ")
    
    static var _commandName = "sort"
    
    @Option(name: .customLong("input"), help: "Input file path")
    private var inputFile: String
    
    func run() throws {
    
        guard let dictionary = NSDictionary(contentsOf: URL(fileURLWithPath: inputFile)) as? [String: String] else {
            throw NSError(domain: "SortLocalization", code: -10, userInfo: [NSLocalizedDescriptionKey: "Cannot parse file at \(inputFile)"])
        }
        
        var keyValues = [KeyValue]()
        for (key, value) in dictionary {
            
            let keyValue = KeyValue(key: key, value: value)
            keyValues.append(keyValue)
        }
        
        let sorted = keyValues.sorted(by: { $0.key < $1.key })
        
        var newContents = ""
        for line in sorted {
            newContents += "\(line.key)=\(line.value)\n"
        }
        try newContents.write(toFile: inputFile, atomically: true, encoding: String.Encoding.utf8)
    }
}


struct KeyValue: Hashable {
    var key: String
    var value: String
}
