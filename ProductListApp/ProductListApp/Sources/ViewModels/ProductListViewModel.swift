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
    private(set) var currentLayoutType: ProductListCollectionViewLayout.LayoutType = .half // 현재 레이아웃 타입

    // 뷰 업데이트를 위한 클로저 기반 바인딩
    var onProductsUpdated: (([Product]) -> Void)?   // 상품 데이터 업데이트 알림
    var onRouteToDetail: ((String, URL) -> Void)?   // 상세 화면 이동 알림
    var onLayoutTypeChanged: ((ProductListCollectionViewLayout.LayoutType) -> Void)? // 레이아웃 변경 알림

    /// 의존성 주입을 통한 서비스 설정
    init(service: ProductServiceProtocol = ProductService()) {
        self.service = service
    }
    
    /// 상품 목록 가져오기
    func fetchProducts() {
        products = service.fetchProducts(from: .list)
        onProductsUpdated?(products)
    }
    
    /// 상품 선택 시 상세 화면으로 이동
    func didSelected(at index: Int) {
        guard products.count > index else { return }
        let product = products[index]
        onRouteToDetail?(product.name, product.link)
    }
    
    /// 반반/전체 레이아웃 간 전환
    func toggleLayoutType() {
        currentLayoutType = currentLayoutType == .half ? .full : .half
        onLayoutTypeChanged?(currentLayoutType)
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
    
    /// 레이아웃 타입별 태그 데이터 반환
    /// - half: 2개 이상의 태그가 있을 때 앞의 2개만
    /// - full: 모든 태그
    func tagsData(for product: Product) -> [String] {
        return currentLayoutType == .half
               ? (product.tags.count <= 2 ? product.tags : Array(product.tags.prefix(2)))
               : product.tags
     }
}
