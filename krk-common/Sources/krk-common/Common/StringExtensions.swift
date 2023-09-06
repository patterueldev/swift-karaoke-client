//
//  StringExtensions.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import Foundation

public extension String {
    func asURL() -> URL? {
        URL(string: self)
    }
}
