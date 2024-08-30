//
//  Encodable+dictionary.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 17/08/2024.
//

import Foundation

extension Encodable {
    func toDictionary(encoder: JSONEncoder) -> [String: Any]? {
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
