//
//  String.swift
//  MangaUniver
//
//  Created by ayite on 22/08/2021.
//

import Foundation

extension String {
    /**
     * Check if a string contains at least one element
     */
    
    //MARK: - Properties

    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespaces) == String()
    }
    
    var data: Data? {
        guard let url = URL(string: self) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        return data
    }
    
}
