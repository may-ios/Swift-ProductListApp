//
//  WebDependency.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import Foundation
import WebKit

// MARK: - WebDependency 프로토콜
/// WKWebView의 URL과 설정을 제공하는 의존성 프로토콜. URL, 설정, 요청 생성 등을 추상화
public protocol WebDependency: AnyObject {
    var url: URL? { get set }                   // 로딩할 웹페이지 URL
    var name: String? { get set }               // 웹페이지 디스플레이 이름
    var configuration: WebConfiguration { get } // 웹뷰 설정 객체
    func urlRequest() -> URLRequest?            // URL 요청 생성
}

// MARK: - WebDependency 확장
extension WebDependency {
    
    /// 문자열 URL을 안전하게 인코딩하여 url에 set
    func setURL(string: String) {
        let urlEncodedString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        self.url = URL(string: urlEncodedString ?? string)
    }
}

// MARK: - BaseWebViewComponent
/// WebDependency 프로토콜을 구현한 기본 웹뷰 컴포넌트
public class BaseWebViewComponent: WebDependency {
    public var url: URL?                            // 로딩할 웹페이지 URL
    public var name: String?                        // 웹페이지 디스플레이 이름
    public let configuration = WebConfiguration()   // 웹뷰 설정 객체
        
    /// URL을 기반으로 URLRequest 생성
    public func urlRequest() -> URLRequest? {
        guard let url = url else { return nil }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20.0) // 20초 타임아웃
        return request
    }
    
}
