//
//  DependencyViewControllerInstantiable.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import Foundation
import UIKit

// MARK: - DependencyViewControllerInstantiable
// 의존성을 주입받아 초기화하는 뷰 컨트롤러 프로토콜
public protocol DependencyViewControllerInstantiable: UIViewController {
    associatedtype DependencyType
     init(dependency: DependencyType,
          nibName: String?,
          bundle: Bundle?,
          presentationStyle: UIModalPresentationStyle,
          hidesBottomBarWhenPushed: Bool)
}
