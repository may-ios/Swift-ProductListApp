//
//  WebConfiguration.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import Foundation
import WebKit

// MARK: - WebConfiguration
/// WKWebViewConfiguration을 래핑하는 설정 클래스 (Wrapper 패턴)
public final class WebConfiguration: Wrapper {
    
    public init() {
        _configuration = WKWebViewConfiguration()
        
        // 인라인 미디어 재생 허용 (iOS Safari 동작과 일치)
        _configuration.allowsInlineMediaPlayback = true
        
        // JavaScript로 새 창 열기 허용
        _configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        // 공유 프로세스 풀 사용으로 메모리 효율성 향상
        _configuration.processPool = WebProcessPool.shared.wrapped
    }
    
    /// 실제 WKWebViewConfiguration 객체를 private으로 보호
    private let _configuration: WKWebViewConfiguration
    /// 래핑된 객체에 대한 읽기 전용 접근 제공
    public var wrapped: WKWebViewConfiguration { _configuration }
}
