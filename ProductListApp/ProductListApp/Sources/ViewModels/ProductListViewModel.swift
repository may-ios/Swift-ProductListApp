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
