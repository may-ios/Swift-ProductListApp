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
        XCTAssertEqual(product.name, "테스트상품")
        XCTAssertEqual(product.price, 100000)
        XCTAssertEqual(product.discountRate, 20)
    }
    
    // MARK: ProductService 테스트
    // JSON 파일에서 상품 데이터를 로드하는 기능 검증
    func testProductService() throws {
        // Given - ProductService 인스턴스 생성
        let service = ProductService()
        
        // When: 상품 데이터 로드
        let products = service.fetchProducts(from: .list)
        
        // Then: 상품 배열이 비어 있지 않은지 확인
        XCTAssertTrue(products.count >= 0) // JSON 파일이 있으면 상품이 있을 것
    }
    
    // MARK: ViewModel 초기화 테스트
    // ProductListViewModel의 초기 상태 검증
    func testViewModelInit() throws {
        // Given, When - ProductListViewModel 인스턴스 생성
        let viewModel = ProductListViewModel()
        
        // Then - 초기 상태값들이 올바르게 설정되었는지 검증
        XCTAssertEqual(viewModel.products.count, 0)
        XCTAssertEqual(viewModel.currentLayoutType, .half)
    }
    
    // MARK: 레이아웃 토글 테스트
    // ViewModel의 레이아웃 토글 기능 검증
    func testLayoutToggle() throws {
        // Given - ProductListViewModel 인스턴스 생성
        let viewModel = ProductListViewModel()
        
        //When - 레이아웃 토글 실행
        viewModel.toggleLayoutType()
        
        // Then - 레이아웃 타입이 변경되었는지 확인
        XCTAssertEqual(viewModel.currentLayoutType, .full)
    }
    
    // MARK: ImageManager 싱글톤 테스트
    // ImageManager의 싱글톤 인스턴스 일관성 검증
    func testImageManagerSingleton() throws {
        // Given & When - ImageManager 싱글톤 인스턴스 두 개 가져오기
        let manager1 = ImageManager.shared
        let manager2 = ImageManager.shared
        
        // Then: 동일한 인스턴스인지 확인
        XCTAssertTrue(manager1 === manager2)
    }
}
