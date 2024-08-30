//
//  Survey.swift
//  Survey2024
//
//  Created by Nguyen Ngoc Mai Thy on 21/08/2024.
//

import Foundation

struct SurveyList {
    let surveys: [Survey]?
    let pagingInfo: PagingInfo?

    var hasMoreData: Bool {
        (pagingInfo?.currentPage ?? 0) < (pagingInfo?.totalPages ?? 0)
    }
}

struct Survey {
    let id: String
    let title: String?
    let description: String?
    let coverImageUrlString: String?

    var coverImageUrl: URL? {
        guard let coverImageUrlString = coverImageUrlString else {
            return nil
        }
        return URL(string: coverImageUrlString)
    }
}
