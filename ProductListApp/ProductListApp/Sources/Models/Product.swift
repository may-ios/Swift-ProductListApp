//
//  Product.swift
//  ProductListApp
//
//  Created by kme on 8/14/25.
//

import Foundation

// MARK: - Product
// 상품 데이터를 나타내는 구조체 모델
struct Product: Decodable {
    let id: String
    let name: String
    let brand: String
    let price: Int
    let discountPrice: Int
    let discountRate: Int
    let image: URL
    let link: URL
    let tags: [String]
    let benefits: [String]
    let rating: Double
    let reviewCount: Int
}
