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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 기본 뷰 로드, setupUI,setupLayout,bind 호출 (상위 클래스에서 처리)
    }
    
    /// UI 요소 초기 설정 (템플릿 메서드 패턴)
    override func setupUI() {
        collectionView.register(cell: ProductCell.self, delegate: self, dataSource: self)
    }
    /// 레이아웃 설정 (템플릿 메서드 패턴)
    override func setupLayout() {
        let layout = ProductListCollectionViewLayout()
        layout.layoutType = .half
        collectionView.collectionViewLayout = layout
    }
    
    /// 데이터 바인딩 및 이벤트 연결 (템플릿 메서드 패턴)
    override func bind() {
        // 초기 데이터 로딩
        dependency.fetchProducts()
        
        // 상품 목록 업데이트 시 UI 갱신
        dependency.onProductsUpdated = { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
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
    }
    
}

