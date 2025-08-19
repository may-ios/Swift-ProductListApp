//
//  BaseWebViewController.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import UIKit
@preconcurrency import WebKit

// MARK: - ScriptMessageHandler
/// WKUserContentController가 강한참조를 유지하므로 약한참조로 감싸서 해결
fileprivate class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
    
    /// 델리게이트를 약한참조로 유지하여 순환참조 방지
    weak var delegate: WKScriptMessageHandler?
    
    init(delegate: WKScriptMessageHandler?) {
        self.delegate = delegate
        super.init()
    }
    
    /// WKUserContentController로부터 받은 메시지를 델리게이트로 전ekf
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}

// MARK: - BaseWebViewController
/// 웹뷰를 표시하는 기본 뷰 컨트롤러, 의존성 주입과 WKWebView 관리
open class BaseWebViewController<DependencyType: WebDependency>: AppDependencyViewController<DependencyType>, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate {
    
    /// WKWebView 인스턴스, 지연 초기화로 생성하여 메모리 효율성 향상
    public lazy var webView: WKWebView = makeWebView()
    
    /// 웹페이지 로딩 진행률을 표시하는 프로그레스 바
    public let progressBar = UIProgressView(progressViewStyle: .bar)
    
    /// WKWebView를 의존성에서 제공된 설정으로 초기화
    open func makeWebView() -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: dependency.configuration.wrapped)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        return webView
    }
    
    /// 의존성에서 제공된 URL로 웹뷰 로드
    open func loadWebView() {
        guard let request = dependency.urlRequest() else { return }
        DispatchQueue.main.async { [weak self] in
            self?.webView.load(request)
        }
    }
    
    /// URL 객체로 웹뷰 이동
    open func toURL(to url: URL?) {
        dependency.url = url
        loadWebView()
    }
    
    /// URL 문자열로 웹뷰 이동
    open func toURL(string: String?) {
        guard let string = string else { return }
        dependency.setURL(string: string)
        loadWebView()
    }
        
    // MARK: - WKScriptMessageHandler
    /// 웹에서 네이티브로 메시지를 받을 때 호출 (서브클래스에서 오버라이드 가능)
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) { }
        
    // MARK: WKNavigationDelegate
    /// 웹페이지 로딩이 시작될 때 호출 - 진행률 업데이트
    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
    }
    
    /// 웹페이지 로딩 시작 - 프로그레스 바 표시
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
        showProgressBar()
    }
    
    /// 웹페이지 로딩 완료 - 프로그레스 바 숨김
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgressBar()
    }
    
    /// 웹페이지 로딩 실패 - 프로그레스 바 숨김
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressBar()
    }
    
    /// 웹페이지 로딩 초기 단계 실패 - 에러 로깅
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
        
    /// 줌 기능을 위한 뷰 반환 (기본적으로 비활성화)
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {  nil }
    
    // 스크롤 이벤트 처리 (서브클래스에서 필요시 구현)
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {}
    
    /// 줌 시작 시 호출 (서브클래스에서 필요시 구현)
    open func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) { }
    
    /// 프로그레스 바 표시 애니메이션
    private func showProgressBar() {
        progressBar.setProgress(0, animated: false)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.progressBar.alpha = 1
        }
    }
    
    /// 프로그레스 바 숨김 애니메이션
    private func hideProgressBar() {
        progressBar.setProgress(1, animated: true)
        UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseInOut) {
            self.progressBar.alpha = 0
        }
    }
}
