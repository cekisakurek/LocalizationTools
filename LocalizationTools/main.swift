//
//  main.swift
//  LocalizationTools
//
//  Created by Cihan Kisakurek on 10.05.22.
//

import Foundation
import ArgumentParser

DefaultCommand.main()

struct DefaultCommand: ParsableCommand {
    
    static let configuration = CommandConfiguration(
        abstract: "CLI Tool",
        subcommands: [SortLocalization.self])
    
    init() { }
}
