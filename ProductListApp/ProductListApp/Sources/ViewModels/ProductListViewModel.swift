//
//  ProductListViewModel.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import Foundation

// MARK: - ProductListViewModel
/// 상품 목록 화면의 비즈니스 로직을 담당하는 뷰모델 - MVVM 패턴
class ProductListViewModel {
    private let service: ProductServiceProtocol  // 상품 데이터 서비스
    private(set) var products: [Product] = []   // 상품 목록

    // 뷰 업데이트를 위한 클로저 기반 바인딩
    var onProductsUpdated: (([Product]) -> Void)?   // 상품 데이터 업데이트 알림

    /// 의존성 주입을 통한 서비스 설정
    init(service: ProductServiceProtocol = ProductService()) {
        self.service = service
    }
    
    /// 상품 목록 가져오기
    func fetchProducts() {
        products = service.fetchProducts(from: .list)
        onProductsUpdated?(products)
    }
}

// MARK: - 뷰모델 데이터 처리 확장
extension ProductListViewModel {
    
    
    /// 가격 정보 데이터 구조체
    struct PriceData {
        let discountRate: String
        let discountPrice: String
        let originalPrice: String
        let hasDiscount: Bool
        
        init(product: Product) {
            discountRate = product.discountRate.string + "%"
            discountPrice = product.discountPrice.withCommas() + "원"
            originalPrice = product.price.withCommas() + "원"
            hasDiscount = product.discountRate > 0
        }
    }
    
    /// 상품별 가격 데이터 생성
    func priceData(for product: Product) -> PriceData {
        return PriceData(product: product)
    }
    
    /// 평점 정보 데이터 구조체
    struct RatingData {
        let ratingText: String
        
        init(product: Product) {
            guard product.rating > 0 else {
                ratingText = "" // 평점이 없으면 빈 문자열
                return
            }
            
            var text = "★ \(product.rating)" // 평점 표시
            
            if  product.reviewCount > 0 {
                text += " (\(product.reviewCount.withCommas()))" // 리뷰 수 추가, comma 처리
            }
            
            ratingText = text
        }
    }
    
    /// 상품별 평점 데이터 생성
    func ratingData(for product: Product) -> RatingData {
        return RatingData(product: product)
    }
}
