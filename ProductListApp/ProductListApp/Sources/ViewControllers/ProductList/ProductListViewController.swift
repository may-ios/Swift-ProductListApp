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
 
    override func setupUI() {}

    override func setupLayout() {}
    
    override func bind() {}
    
}
