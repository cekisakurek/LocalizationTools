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
    
        let contents = try String(contentsOfFile: inputFile)
        let lines = contents.split(whereSeparator: \.isNewline)
        var keyValues = [KeyValue]()
        for (index, line) in lines.enumerated() {
            let components = line.split(separator: "=")
            guard components.count == 2 else {
                throw NSError(domain: "SortLocalization", code: -10, userInfo: [NSLocalizedDescriptionKey: "\(inputFile) Invalid line at  \(index): \(line)"])
            }
            let keyValue = KeyValue(key: String(components[0]), value: String(components[1]))
            guard keyValue.isValid() else {
                throw NSError(domain: "SortLocalization", code: -10, userInfo: [NSLocalizedDescriptionKey: "\(inputFile) line \(index): \(line) is not valid!"])
            }
            keyValues.append(keyValue)
        }
        
        guard keyValues.isUnique else {
            throw NSError(domain: "SortLocalization", code: -10, userInfo: [NSLocalizedDescriptionKey: "File \(inputFile)) has duplicate keys!"])
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
    
    func isValid() -> Bool {
     
        // Check rules here
        // 1. Rule: Line should end with ;
        let correctEnding = value.last == ";"
        
        // 2. Rule: There should be only two or zero quotation marks
        // Too strict. We need to consider escaped quotation marks
//        let quotationRule1 = (key.count(of: "\"") == 2 || key.count(of: "\"") == 0)
//        let quotationRule2 = (key.count(of: "\'") == 2 || key.count(of: "\'") == 0)
        // 3. Quotation marks should match
        // check the first and the last element of the keys and values
        let quotationRule3 = key.trimmingCharacters(in: .whitespacesAndNewlines).first == key.trimmingCharacters(in: .whitespacesAndNewlines).last
        let quotationRule4 = value.trimmingCharacters(in: .whitespacesAndNewlines).first! == value[value.index(value.startIndex, offsetBy: value.count - 2)]
        
        return correctEnding && quotationRule3 && quotationRule4
    }
}
