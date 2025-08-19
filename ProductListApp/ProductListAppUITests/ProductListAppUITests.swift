//
//  ProductListAppUITests.swift
//  ProductListAppUITests
//
//  Created by kme on 8/19/25.
//

import XCTest

// MARK: - UI Tests
final class ProductListAppUITests: XCTestCase {

    var app: XCUIApplication!

    // MARK: 테스트 설정
    override func setUpWithError() throws {
        continueAfterFailure = false  // 테스트 실패 시 다음 테스트 중단하지 않음
        app = XCUIApplication()
        app.launch()
    }

    // MARK: 앱 실행 테스트
    // 앱이 정상적으로 실행되는지 확인
    func testAppLaunch() throws {
        // Then - 앱이 존재하고 실행되었는지 검증
        XCTAssertTrue(app.exists)
    }
    
    // MARK: 메인 화면 요소 테스트
    // 메인 화면의 필수 UI 요소들이 올바르게 표시되는지 확인
    func testMainScreen() throws {
        // When, Then - 컬렉션뷰가 존재하고 표시되는지 확인
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 3))
        
        let navigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(navigationBar.exists)
    }
    
    // MARK: 상품 선택 테스트
    // 상품 셀을 탭하여 상세 화면으로 이동하는지 확인
    func testProductTap() throws {
        // Given - 컬렉션뷰가 로드될 때까지 대기
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 3))
        
        // When - 첫 번째 셀 탭
        let firstCell = collectionView.cells.firstMatch
        if firstCell.waitForExistence(timeout: 2) {
            firstCell.tap()
            
            // Then - 뒤로가기 버튼이 생기면 화면 전환된 것
            let backButton = app.navigationBars.buttons.element(boundBy: 0)
            XCTAssertTrue(backButton.waitForExistence(timeout: 3))
        } else {
            XCTFail("테스트할 셀이 존재하지 않음")
        }
    }
    
    // MARK: 레이아웃 토글 버튼 테스트
    // 네비게이션 바의 레이아웃 전환 버튼 동작 확인
    func testLayoutToggle() throws {
        // Given - 토글 버튼이 존재하는지 확인
        let toggleButton = app.navigationBars.buttons.firstMatch
        XCTAssertTrue(toggleButton.exists)
        
        // When - 토글 버튼 탭
        toggleButton.tap()
        
        // Then -  버튼이 정상적으로 동작했는지 확인, 레이아웃 변경은 시각적이므로 크래시 없는 지로 확인
        XCTAssertTrue(toggleButton.exists)
    }
    
    // MARK: 스크롤 동작 테스트
    // 컬렉션뷰 스크롤 테스트
    func testScrolling() throws {
        // Given - 컬렉션뷰가 로드될 때까지 대기
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 3))

        // When - 스크롤 동작 수행
        collectionView.swipeUp()
        
        // Then - 스크롤이 정상적으로 동작했는지 확인 ,크래시 없이 완료되는지 확인
        XCTAssertTrue(collectionView.exists)
    }
    
    // MARK: 앱 실행 성능 테스트
    // 앱 실행 시간 측정
    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
