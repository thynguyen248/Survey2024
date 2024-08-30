//
//  PagingParameter.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 21/08/2024.
//

import Foundation

struct PagingParameter: Codable {
    var page: Int? = 1
    var pageSize: Int? = 5

    enum CodingKeys: String, CodingKey {
        case page = "page[number]"
        case pageSize = "page[size]"
    }
}
