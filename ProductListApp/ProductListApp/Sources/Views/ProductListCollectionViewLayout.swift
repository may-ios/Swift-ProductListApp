//
//  ProductListCollectionViewLayout.swift
//  ProductListApp
//
//  Created by kme on 8/16/25.
//

import Foundation
import UIKit

// MARK: - ProductListCollectionViewLayout
/// 상품 리스트의 컬렉션뷰 레이아웃을 관리하는 커스텀 레이아웃
class ProductListCollectionViewLayout: UICollectionViewFlowLayout {
    
    /// 레이아웃 타입 정의 (1/2, 전체 )
    enum LayoutType {
        case half   // 컬렉션뷰 너비의 1/2로 2열 배치
        case full   // 화면 너비 기준

        /// SF Symbol name
        var imageName: String {
            switch self {
            case .half:
                return "square.grid.2x2"
            case .full:
                return "rectangle.grid.1x2"
            }
        }
    }
    
    var layoutType: LayoutType = .half
    private static let defaulBottomHeight: CGFloat = 170.0 // 하단 정보 영역 기본 높이

    // 레이아웃 간격 설정 (읽기 전용으로 오버라이드)
    override var minimumLineSpacing: CGFloat { get { 10 } set { } }
    override var minimumInteritemSpacing: CGFloat { get { 0 } set { } }
    
    // 레이아웃 타입에 따라 sectionInset을 다르게 설정
     override var sectionInset: UIEdgeInsets {
         get {
             switch layoutType {
             case .half:
                 return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1)
             case .full:
                 return UIEdgeInsets.zero
             }
         }
         set { }
     }
    
    /// 컬렉션 뷰의 아이템 크기를 동적으로 계산
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        let itemSize = calculateItemSize(for: collectionView)
        self.itemSize = itemSize
    }
    
    /// 레이아웃 타입에 따라 셀 크기 반환
    private func calculateItemSize(for collectionView: UICollectionView) -> CGSize {
        switch layoutType {
        case .half:
            let width = halfWidth(collectionView)
            let height = width + Self.defaulBottomHeight
            return CGSize(width: ceil(width), height: height)
            
        case .full:
            let width = fullWidth(collectionView)
            let height = width + Self.defaulBottomHeight
            return CGSize(width: ceil(width), height: height)
        }
    }
    
    /// 반폭 레이아웃의 셀 너비 계산
    private func halfWidth(_ collectionView: UICollectionView) -> CGFloat {
        return (collectionView.frame.width / 2) - sectionInset.left - sectionInset.right
    }
    
    /// 전체 너비 레이아웃의 셀 너비 계산
     private func fullWidth(_ collectionView: UICollectionView) -> CGFloat {
         return collectionView.frame.width - sectionInset.left - sectionInset.right
     }
}
