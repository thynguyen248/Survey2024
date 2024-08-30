//
//  SurveyDTO.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 21/08/2024.
//

import Foundation

struct SurveyResponseDTO: Decodable {
    let data: [SurveyAttributesDTO]?
    let meta: MetaDTO?
}

struct SurveyAttributesDTO: Decodable {
    let id: String
    let attributes: SurveyDTO?
}

struct SurveyDTO: Decodable {
    let title: String?
    let description: String?
    let coverImageUrl: String?
}

struct MetaDTO: Decodable {
    let page: Int?
    let pages: Int?
}

extension SurveyResponseDTO {
    func mapToDomain() -> SurveyList {
        let surveys = data?.compactMap { Survey(id: $0.id, title: $0.attributes?.title, description: $0.attributes?.description, coverImageUrlString: $0.attributes?.coverImageUrl) }
        let pagingInfo: PagingInfo = PagingInfo(currentPage: meta?.page, totalPages: meta?.pages)
        let list: SurveyList = .init(surveys: surveys, pagingInfo: pagingInfo)
        return list
    }
}
