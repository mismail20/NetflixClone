//
//  Movie.swift
//  Netflix
//
//  Created by Mohamed Ismail on 02/09/2023.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let original_name: String?
    let original_title: String?
    let overview: String?
    let poster_path: String?
}
