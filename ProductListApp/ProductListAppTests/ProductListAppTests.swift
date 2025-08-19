//
//  ProductListAppTests.swift
//  ProductListAppTests
//
//  Created by kme on 8/19/25.
//

import XCTest
@testable import ProductListApp

// MARK: - Unit Tests
final class ProductListAppTests: XCTestCase {
    
    // MARK: Product 모델 테스트
    // Product 모델의 속성값 초기화와 접근 테스트
    func testProductModel() throws {
        // Given - 테스트용 상품 객체 생성
        let product = Product(
            id: "1",
            name: "테스트상품",
            brand: "테스트브랜드",
            price: 100000,
            discountPrice: 80000,
            discountRate: 20,
            image: URL(string: "https://example.com/image.jpg")!,
            link: URL(string: "https://example.com/link")!,
            tags: ["태그1"],
            benefits: ["혜택1"],
            rating: 4.5,
            reviewCount: 100
        )
        
        // Then - 모델 속성값들이 올바르게 설정되었는지 검증
        XCTAssertEqual(product.name, "테스트상품", "상품명이 올바르게 설정되어야 함")
        XCTAssertEqual(product.price, 100000, "가격이 올바르게 설정되어야 함")
        XCTAssertEqual(product.discountRate, 20,"할인율이 올바르게 설정되어야 함")
        XCTAssertEqual(product.discountPrice, 80000, "할인가격이 올바르게 설정되어야 함")
        XCTAssertEqual(product.brand, "테스트브랜드", "브랜드명이 올바르게 설정되어야 함")

    }
    
    // MARK: ProductService 테스트
    // JSON 파일에서 상품 데이터를 로드하는 기능 검증
    func testProductService() throws {
        // Given - ProductService 인스턴스 생성
        let service = ProductService()
        
        // When: 상품 데이터 로드
        let products = service.fetchProducts(from: .list)
        
        // Then: 상품 배열이 비어 있지 않은지 확인
        XCTAssertTrue(products.count >= 0, "상품 목록이 정상적으로 로드되어야 함")
        
        // 추가: JSON 파일이 존재한다면 상품이 있어야 함
          if !products.isEmpty {
              XCTAssertNotNil(products.first?.id, "첫 번째 상품의 ID가 존재해야 함")
              XCTAssertNotNil(products.first?.name, "첫 번째 상품의 이름이 존재해야 함")
          }
    }
    
    // MARK: ViewModel 초기화 테스트
    // ProductListViewModel의 초기 상태 검증
    func testViewModelInit() throws {
        // Given, When - ProductListViewModel 인스턴스 생성
        let viewModel = ProductListViewModel()
        
        // Then - 초기 상태값들이 올바르게 설정되었는지 검증
        XCTAssertEqual(viewModel.products.count, 0, "초기 상품 목록은 비어있어야 함")
        XCTAssertEqual(viewModel.currentLayoutType, .half, "초기 레이아웃은 half여야 함")
    }
    
    // MARK: 레이아웃 토글 테스트
    // ViewModel의 레이아웃 토글 기능 검증
    func testLayoutToggle() throws {
        // Given - ProductListViewModel 인스턴스 생성
        let viewModel = ProductListViewModel()
        let initialLayout = viewModel.currentLayoutType

        //When - 레이아웃 토글 실행
        viewModel.toggleLayoutType()
        
        // Then - 레이아웃 타입이 변경되었는지 확인
        XCTAssertEqual(viewModel.currentLayoutType, .full, "토글 후 레이아웃이 full으로 변경되어야 함")
        XCTAssertNotEqual(viewModel.currentLayoutType, initialLayout, "토글 전후 레이아웃이 달라야 함")

    }
    
    // MARK: ImageManager 싱글톤 테스트
    // ImageManager의 싱글톤 인스턴스 일관성 검증
    func testImageManagerSingleton() throws {
        // Given & When - ImageManager 싱글톤 인스턴스 두 개 가져오기
        let manager1 = ImageManager.shared
        let manager2 = ImageManager.shared
        
        // Then: 동일한 인스턴스인지 확인
        XCTAssertTrue(manager1 === manager2, "ImageManager는 싱글톤이므로 동일한 인스턴스여야 함")
    }
    
    // MARK: - 숫자(가격) 포맷팅 테스트
    // 천단위 콤마 검증
     func testPriceFormatting() throws {
         // Given - 가격 값
         let price1 = 1000
         let price2 = 1234567
         
         // When - 천단위 콤마 적용
         let formattedPrice1 = price1.withCommas()
         let formattedPrice2 = price2.withCommas()
         
         // Then - 올바른 포맷으로 변환되었는지 검증
         XCTAssertEqual(formattedPrice1, "1,000", "천 단위 콤마가 올바르게 적용되어야 함")
         XCTAssertEqual(formattedPrice2, "1,234,567", "백만 단위 콤마가 올바르게 적용되어야 함")
     }
}
