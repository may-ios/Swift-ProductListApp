//
//  Cellable.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import Foundation
import UIKit


// MARK: - Cellable
/// UICollectionViewCell의 등록과 재사용을 간소화해주는 프로토콜
/// XIB 파일을 사용하는 셀의 타입 등록과 생성을 안전하게 지원
public protocol Cellable {
    static var bundle: Bundle? { get }
    static var forNibNameIdentifier: String { get }
    static var forCellReuseIdentifier: String { get }
}

// MARK: - Cellable 기본 구현
extension Cellable {
    
    /// XIB 파일에서 UINib 인스턴스 생성
    public static func loadXIB() -> UINib { UINib(nibName: forNibNameIdentifier, bundle: bundle) }

    /// XIB 파일이 위치한 번들 (메인 번들 사용)
    public static var bundle: Bundle? { nil }
    
    /// XIB 파일 이름을 클래스 이름으로 자동 설정
    public static var forNibNameIdentifier: String { String(describing: self) }

    /// 재사용 식별자를 클래스 이름으로 자동 설정
    public static var forCellReuseIdentifier: String { String(describing: self) }
}

// MARK: - Cellable for UICollectionViewCell
extension Cellable where Self: UICollectionViewCell {
    
    /// 현재 셀이 속한 컬렉션뷰 참조
    var ownCollectionView: UICollectionView? { superview as? UICollectionView }
    /// 현재 셀의 IndexPath
    var indexPath: IndexPath? { ownCollectionView?.indexPath(for: self) }
}


// MARK: - UICollectionView 확장
extension UICollectionView {

    // MARK: 셀 등록
    /// 제네릭 타입의 셀을 등록하고 델리게이트들을 한번에 설정
    /// - Parameters:
    ///   - cell: 등록할 셀 타입 (Cellable 프로토콜 준수)
    ///   - delegate : 컬렉션뷰 델리게이트 (옵셔널)
    ///   - dataSource : 데이터소스 델리게이트 (옵셔널)
    ///   - prefetchDataSource: 프리페치 델리게이트 (옵셔널)
    ///   - dragDelegate: 드래그 델리게이트 (옵셔널)
    ///   - dropDelegate: 드롭 델리게이트 (옵셔널)
    public func register<CellType: UICollectionViewCell & Cellable>(cell: CellType.Type,
                                                                    delegate: UICollectionViewDelegate? = nil,
                                                                    dataSource: UICollectionViewDataSource? = nil,
                                                                    prefetchDataSource: UICollectionViewDataSourcePrefetching? = nil,
                                                                    dragDelegate: UICollectionViewDragDelegate? = nil,
                                                                    dropDelegate: UICollectionViewDropDelegate? = nil)
    {
        // XIB 기반 셀 등록
        register(cell.loadXIB(), forCellWithReuseIdentifier: cell.forCellReuseIdentifier)
        
        // 모든 델리게이트 설정
        setDelegate(delegate: delegate, dataSource: dataSource, prefetchDataSource: prefetchDataSource)
        self.dragDelegate = dragDelegate
        self.dropDelegate = dropDelegate
    }
    
    // MARK: 헤더/푸터 뷰 등록
    /// 헤더/푸터과 같은 추가적인 뷰를 등록하고 델리게이트들을 함께 설정
    /// - Parameters:
    ///   - cell: 등록할 뷰 타입 (Cellable 프로토콜 준수)
    ///   - forSupplementaryViewOfKind: 뷰 종류 (헤더/푸터)
    ///   - 위와 같은 델리게이트 파라미터들
    public func register<CellType: UICollectionReusableView & Cellable>(cell: CellType.Type,
                                                                        forSupplementaryViewOfKind: String,
                                                                        delegate: UICollectionViewDelegate? = nil,
                                                                        dataSource: UICollectionViewDataSource? = nil,
                                                                        prefetchDataSource: UICollectionViewDataSourcePrefetching? = nil,
                                                                        dragDelegate: UICollectionViewDragDelegate? = nil,
                                                                        dropDelegate: UICollectionViewDropDelegate? = nil)
    {
        register(cell.loadXIB(), forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: cell.forCellReuseIdentifier)
        setDelegate(delegate: delegate, dataSource: dataSource, prefetchDataSource: prefetchDataSource)
        self.dragDelegate = dragDelegate
        self.dropDelegate = dropDelegate
    }
    
    // MARK: 델리게이트 설정
    /// 컬렉션뷰의 다양한 델리게이트들을 한번에 설정하는 private 메서드
    private func setDelegate(delegate: UICollectionViewDelegate? = nil,
                             dataSource: UICollectionViewDataSource? = nil,
                             prefetchDataSource: UICollectionViewDataSourcePrefetching? = nil)
    {
        if let delegate = delegate {
            self.delegate = delegate
        }
        if let dataSource = dataSource {
            self.dataSource = dataSource
        }
        if let prefetchDataSource = prefetchDataSource {
            self.prefetchDataSource = prefetchDataSource
        }
    }
    
    /// 타입 안전한 셀 재사용 메서드
    /// 타입 캐스팅 실패 가능성을 컴파일 타임에 체크
    public func dequeueReusableCell<Element: Cellable>(indexPath: IndexPath) -> Element {
        self.dequeueReusableCell(withReuseIdentifier: Element.forCellReuseIdentifier, for: indexPath) as! Element
    }
    
    /// 헤더/푸터 뷰를 타입 안전하게 재사용하는 메서드
    public func dequeueReusableSupplementaryView<Element: Cellable>(ofKind: String, indexPath: IndexPath) -> Element {
        switch ofKind {
        case UICollectionView.elementKindSectionHeader:
            return dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: Element.forCellReuseIdentifier, for: indexPath) as! Element
        case UICollectionView.elementKindSectionFooter:
            return dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: Element.forCellReuseIdentifier, for: indexPath) as! Element
        default:
            return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Element.forCellReuseIdentifier, for: indexPath) as! Element
        }
    }
    
    /// 특정 위치의 셀을 타입 안전하게 조회
    public func cellForItem<Element: Cellable>(at: IndexPath) -> Element? {
        cellForItem(at: at) as? Element
    }
    
    /// 특정 위치의 헤더/푸터 뷰를 타입 안전하게 조회
    public func supplementaryView<Element: Cellable>(forElementKind: String, at: IndexPath) -> Element? {
        switch forElementKind {
        case UICollectionView.elementKindSectionHeader:
            return supplementaryView(forElementKind: forElementKind, at: at) as? Element
        case UICollectionView.elementKindSectionFooter:
            return supplementaryView(forElementKind: forElementKind, at: at) as? Element
        default:
            return supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: at) as? Element
        }
    }
}
