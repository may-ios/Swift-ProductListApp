//
//  ProductListViewController.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import Foundation
import UIKit

// MARK: - ProductListViewController
/// 상품 리스트를 표시하는 뷰 컨트롤러, 뷰모델을 의존성으로 주입받음
class ProductListViewController: AppDependencyViewController<ProductListViewModel>  {
    
    /// UI 스타일 설정을 위한 구조체 (설정 분리, 문자열 상수 정리)
    private struct UIConfig {
        let error = (
            font: UIFont.AppleSDGothicNeo.bold.font(size: 15),
            text: "상품 목록을 불러오지 못했습니다"
        )
        let logoName = "logo_cj_enm"
    }
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// UI 설정
    private let uiConfig = UIConfig()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 기본 뷰 로드, setupUI,setupLayout,bind 호출 (상위 클래스에서 처리)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 스크롤 시 네비게이션 바 숨김 기능 활성화
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 뷰가 사라질 때 네비게이션 바 표시 복구
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
        
    /// UI 요소 초기 설정 (템플릿 메서드 패턴)
    override func setupUI() {
        errorLabel.text = uiConfig.error.text
        errorLabel.font = uiConfig.error.font
        errorView.isHidden = true
        setupNavigationBar()
        collectionView.register(cell: ProductCell.self, delegate: self, dataSource: self)
    }
    /// 레이아웃 설정 (템플릿 메서드 패턴)
    override func setupLayout() {
        let layout = ProductListCollectionViewLayout()
        layout.layoutType = .half
        collectionView.collectionViewLayout = layout
    }
    
    /// 데이터 바인딩 및 이벤트 연결 (템플릿 메서드 패턴)
    override func bind()  {
        // 초기 데이터 로딩
        Task { await dependency.fetchProducts() }
        
        // 상품 목록 업데이트 시 UI 갱신
        dependency.onProductsUpdated = { [weak self] result in
            switch result {
            case .success:
                self?.errorView.isHidden = true
                self?.collectionView.reloadData()
            case .failure( _):
                self?.errorView.isHidden = false
            }
        }
        
        // 상품 선택 시 상세 화면으로 이동
        dependency.onRouteToDetail = { [weak self] name, url in
            let detailViewController = ProductDetailViewController(dependency: WebViewComponent(url: url, name: name))
            self?.navigationController?.pushViewController(detailViewController, animated: true)
        }
        
        // 레이아웃 타입 변경 시 UI 업데이트
        dependency.onLayoutTypeChanged = { [weak self] layoutType in
            DispatchQueue.main.async {
                self?.updateLayout(for: layoutType)
            }
        }
    }
    
    // MARK: 레이아웃 업데이트
    /// 컬렉션 뷰의 레이아웃 타입 변경 시 애니메이션 적용
    private func updateLayout(for layoutType: ProductListCollectionViewLayout.LayoutType) {

        guard let layout = collectionView.collectionViewLayout as? ProductListCollectionViewLayout else { return }
        
        layout.layoutType = layoutType
        
        UIView.animate(withDuration: 0.3, animations: {
            layout.invalidateLayout()
            self.collectionView.layoutIfNeeded()
        }) { _ in
            let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
            self.collectionView.reloadItems(at: visibleIndexPaths)
        }
        
    }
    
    /// 레이아웃 토글 버튼 액션
    @objc private func toggleLayoutButtonTapped() {
        dependency.toggleLayoutType()
        updateNavigationButton()
    }
    
    /// 로고 버튼 액션 - 맨 위로 스크롤
    @objc private func logoButtonTapped() {
        collectionView.setContentOffset(CGPoint(x: 0, y: -collectionView.safeAreaInsets.top), animated: true)
    }
    
    /// 네비게이션 바 설정
    private func setupNavigationBar() {
        let logoButton = UIButton(type: .custom)
        logoButton.setImage(UIImage(named: uiConfig.logoName), for: .normal)
        logoButton.frame = CGRect(x: 0, y: 0, width: 63, height: 30)
        logoButton.addTarget(self, action: #selector(logoButtonTapped), for: .touchUpInside)

        let customBarButtonItem = UIBarButtonItem(customView: logoButton)
        navigationItem.leftBarButtonItem = customBarButtonItem
        
        let layoutTypeButton = UIBarButtonItem(
            image: UIImage(systemName: dependency.currentLayoutType.imageName),
            style: .plain,
            target: self,
            action: #selector(toggleLayoutButtonTapped)
        )
        navigationItem.rightBarButtonItems = [layoutTypeButton]
    }
    
    /// 네비게이션 버튼 이미지 업데이트
    private func updateNavigationButton() {
        guard let button = navigationItem.rightBarButtonItems?.first else { return }
        
        let imageName = dependency.currentLayoutType.imageName
        button.image = UIImage(systemName: imageName)
        
    }
}

// MARK: - UICollectionView 데이터소스 및 델리게이트
extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dependency.products.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ProductCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        // 셀에 상품 데이터와 뷰모델 전달
        cell.configure(dependency.products[indexPath.item], viewModel: dependency)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 뷰모델에 선택 알림
        dependency.didSelected(at: indexPath.item)
    }
    
}

