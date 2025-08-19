//
//  ProductService.swift
//  ProductListApp
//
//  Created by kme on 8/15/25.
//

import Foundation

// MARK: - ProductResource
/// 상품 리소스 타입을 정의하는 열거형 (JSON 파일명과 매핑)
enum ProductResource: String {
    case list = "products"
}

// MARK: - ProductServiceProtoco
/// 상품 서비스 추상화 프로토콜 (DIP 원칙 적용)
protocol ProductServiceProtocol {
    func fetchProducts(from resource: ProductResource) -> [Product]
}

// MARK: - ProductService
/// 상품 데이터를 로컬 JSON에서 가져오는 서비스 구현체
class ProductService: ProductServiceProtocol{
    
    /// 지정된 리소스의 JSON 파일을 디코딩하여 상품 목록 반환
    func fetchProducts(from resource: ProductResource) -> [Product] {
        // Bundle에서 JSON 데이터 로드 (안전한 옵셔널 처리)
        guard let data = Bundle.dataFromJson(for: resource.rawValue) else { return [] }
        
        do {
            // JSON 디코딩을 통한 Product 배열 생성
            return try JSONDecoder().decode([Product].self, from: data)
        }
        catch {
            // 디코딩 실패 시 에러 로그 출력
            print("JSON decode failed: \(error)")
            return []
        }
    }
}
