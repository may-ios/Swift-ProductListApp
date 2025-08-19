//
//  WebProcessPool.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import Foundation
import WebKit

// MARK: - WebProcessPool
/// WKWebView의 프로세스 풀을 래핑하여 싱글톤으로 제공
/// 여러 웹뷰가 같은 프로세스 풀을 공유하여 메모리 사용량 최적화
public struct WebProcessPool: Wrapper {
    
    // private init으로 외부 인스턴스 생성 방지
    private init() {
        _processPool = WKProcessPool()
    }
    
    public static let shared = WebProcessPool()             // 싱글톤 인스턴스 - 모든 WKWebView가 공유할 프로세스 풀
    private let _processPool: WKProcessPool                 // 실제 WKProcessPool 객체를 private으로 보호
    public var wrapped: WKProcessPool { _processPool }      // 래핑된 객체에 대한 읽기 전용 접근 제공
}
