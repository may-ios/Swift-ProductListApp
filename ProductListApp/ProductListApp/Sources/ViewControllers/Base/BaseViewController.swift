//
//  BaseViewController.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import Foundation
import UIKit


// MARK: - 뷰컨트롤러의 의존성 주입을 위한 프로토콜
/// ViewController가 의존하는 데이터를 제공하는 인터페이스 정의
protocol ViewControllerDependency {
    func provideData() -> String
}

// MARK: - BaseNavigationController
// UINavigationController를 커스텀하여 기본 설정과 공통 기능을 제공하는 베이스 클래스
open class BaseNavigationController: UINavigationController {
    
    // 커스텀 초기화 - 루트 뷰컨트롤러와 프레젠테이션 스타일을 설정
    public required init(root: UIViewController, presentationStyle: UIModalPresentationStyle = .fullScreen) {
        super.init(rootViewController: root)
        modalPresentationStyle = presentationStyle
    }

    // 스토리보드 또는 XIB에서 초기화할 경우
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // 네비게이션 스택의 루트 뷰 컨트롤러를 제네릭 타입으로 반환
    open func rootViewController<T: BaseViewController>() -> T? {
        viewControllers.first as? T
    }
    
    // 상태바 스타일을 현재 표시된 뷰 컨트롤러에 위임
    open override var childForStatusBarStyle: UIViewController? { visibleViewController }

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // 스와이프 백 제스처 활성화
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        interactivePopGestureRecognizer?.delegate = nil
        
        // 네비게이션 바 기본 설정
        navigationBar.prefersLargeTitles = false
        navigationBar.tintColor = .label

        // 네비게이션 바 외형 커스터마이징 (iOS 13+)
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
        ]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.configureWithTransparentBackground()
        appearance.shadowImage = nil
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        
        // 뒤로가기 버튼을 minimal 스타일로 설정
        topViewController?.navigationItem.backButtonDisplayMode = .minimal
    }
    
    // MARK: 메모리 관리
    deinit {
#if DEBUG
        print("[deinit]:", String(describing: Self.self)) // 디버그용 메모리 해제 로그
#endif
    }
}

// MARK: - BaseViewController
/// 모든 뷰컨트롤러의 공통 기능을 제공하는 베이스 클래스
open class BaseViewController: UIViewController {

    // 서브클래스에서 상태바 스타일을 오버라이드할 수 있도록 제공
    open var statusBarStyle: UIStatusBarStyle { .default }
    open override var preferredStatusBarStyle: UIStatusBarStyle { statusBarStyle }
    
    // 템플릿 메서드 패턴 - 서브클래스에서 필요에 따라 UI 구성, 레이아웃, 데이터 바인딩을 각각 처리
    open func setupUI() {}
    open func setupLayout() {}
    open func bind() {}
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // 템플릿 메서드 패턴으로 초기화 순서 보장
        setupUI()
        setupLayout()
        bind()
        
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 색상 일관성 유지
        navigationController?.navigationBar.tintColor = .label
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
         super.traitCollectionDidChange(previousTraitCollection)
     }
    
    deinit {
#if DEBUG
        print("[deinit]:", String(describing: Self.self))
#endif
    }
}

// MARK: - AppViewController
/// 의존성 주입 없는 일반 앱 뷰컨트롤러, 추가 초기화 옵션 제공
open class AppViewController: BaseViewController, ViewControllerInstantiable {
    
    /// 커스텀 초기화 - 모달 스타일 설정 포함
    public required init(nibName nibNameOrNil: String? = nil,
                         bundle nibBundleOrNil: Bundle? = nil,
                         presentationStyle: UIModalPresentationStyle = .fullScreen,
                         hidesBottomBarWhenPushed: Bool = true) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = presentationStyle
        self.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
    }
    
    /// 기본 init 사용 비활성화 - 일관된 초기화 패턴 강제
    @available(*, unavailable)
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - AppDependencyViewController
/// 의존성 주입을 지원하는 앱 뷰컨트롤러 (제네릭 사용)
open class AppDependencyViewController<DependencyType>: BaseViewController, DependencyViewControllerInstantiable {
    public let dependency: DependencyType

    /// 의존성을 필수로 받는 초기화 메서드
    public required init(dependency: DependencyType,
                         nibName nibNameOrNil: String? = nil,
                         bundle nibBundleOrNil: Bundle? = nil,
                         presentationStyle: UIModalPresentationStyle = .fullScreen,
                         hidesBottomBarWhenPushed: Bool = true) {
        
        self.dependency = dependency
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = presentationStyle
        self.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
    }
    
    /// Storyboard 초기화 비활성화 - 의존성 주입 강제
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Use init(dependency:) instead")
    }
    
    /// Storyboard에서 의존성과 함께 초기화하는 대안 메서드
    public init?(coder: NSCoder, dependency: DependencyType) {
        self.dependency = dependency
        super.init(coder: coder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        if let dependency = dependency as? ViewControllerDependency {
            print("Dependency data: \(dependency.provideData())")
        }
    }
    
}

// MARK: - AppViewController 확장
extension AppViewController {
    
    /// 네비게이션 컨트롤러 생성 (기본)
    public static  func navigation(presentationStyle: UIModalPresentationStyle = .fullScreen) -> BaseNavigationController {
        return BaseNavigationController(root: Self(), presentationStyle: presentationStyle)
    }
    
    /// 네비게이션 컨트롤러 생성 (커스텀 설정 가능)
    public static  func navigation(presentationStyle: UIModalPresentationStyle = .fullScreen, with: (Self) -> Void) -> BaseNavigationController {
        let vc = Self()
        with(vc)
        return BaseNavigationController(root: vc, presentationStyle: presentationStyle)
    }
}

// MARK: - AppDependencyViewController 확장
extension AppDependencyViewController {
    
    /// 의존성과 함께 네비게이션 컨트롤러 생성
    public static  func navigation(dependency: DependencyType, presentationStyle: UIModalPresentationStyle = .fullScreen) -> BaseNavigationController {
        return BaseNavigationController(root: Self(dependency: dependency), presentationStyle: presentationStyle)
    }
    
    /// 의존성과 커스텀 설정으로 네비게이션 컨트롤러 생성
    public static  func navigation(dependency: DependencyType, presentationStyle: UIModalPresentationStyle = .fullScreen, with: (Self) -> Void) -> BaseNavigationController {
        let vc = Self.init(dependency: dependency)
        with(vc)
        return BaseNavigationController(root: vc, presentationStyle: presentationStyle)
    }
}
