//
//  WebViewController.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import UIKit
import WebKit

// MARK: - WebViewComponent
/// 웹뷰에 필요한 URL과 이름 정보를 담는 의존성 주입용 컴포넌트
class WebViewComponent: BaseWebViewComponent {

    /// WebView 컴포넌트 초기화
    init(url: URL?, name: String?) {
        super.init()
        self.url = url     // 로드할 웹 페이지 URL
        self.name = name   // 화면에 표시할 이름
    }
}

// MARK: - ProductDetailViewController
/// 상품 상세 정보를 WKWebView로 표시하는 뷰 컨트롤러
final class ProductDetailViewController: BaseWebViewController<WebViewComponent> {
    
    /// 프로그레스바 관련 상수 정의
    private enum ProgressBarConstants {
        static let height: CGFloat = 2.0 // 프로그레스바의 높이 값
    }
    
    /// 웹뷰와 프로그레스바를 담을 컨테이너 뷰
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 웹뷰 로드 시작
        loadWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 색상 설정
        navigationController?.navigationBar.tintColor = .black
    }
    
    // WKScriptMessageHandler - 자바스크립트 메시지 처리
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    }
    
    /// 기본 UI 스타일 설정
    /// url 웹페이지 내부 스타일에 맞게 흰색으로 커스텀
    override func setupUI() {
        view.backgroundColor = .white    // 배경색을 흰색으로 설정
        webView.backgroundColor = .white // 웹뷰 배경색도 흰색으로 설정
        title = dependency.name          // 네비게이션 타이틀을 상품명으로 설정
    }
    
    /// 웹뷰와 프로그레스바 레이아웃 설정
    override func setupLayout() {
        // 프로그레스바 스타일 설정
        progressBar.tintColor = UIColor.accent // Asset으로 추가한 브랜드(AccentColor) 컬러로 프로그레스바 색상 설정
        progressBar.backgroundColor = .gray.withAlphaComponent(0.3)
        progressBar.alpha = 0 // 초기에는 투명하게 설정
        progressBar.autoresizingMask = .flexibleWidth // 너비 자동 조정
        progressBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: ProgressBarConstants.height)
        
        // 컨테이너 뷰에 서브뷰 추가
        containerView.addSubview(progressBar)
        containerView.addSubview(webView)
        containerView.bringSubviewToFront(progressBar)
        
        // 웹뷰 오토레이아웃 제약조건 설정
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: containerView.topAnchor),
            webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}
