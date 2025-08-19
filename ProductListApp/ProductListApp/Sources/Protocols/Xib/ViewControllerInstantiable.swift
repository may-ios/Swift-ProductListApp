//
//  ViewContollerInstantiable.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import Foundation
import UIKit

// MARK: - ViewControllerInstantiable
// 기본 초기화를 표준화하는 뷰 컨트롤러 프로토콜
public protocol ViewControllerInstantiable: UIViewController {
    init(nibName: String?,
         bundle: Bundle?,
         presentationStyle: UIModalPresentationStyle,
         hidesBottomBarWhenPushed: Bool)
}
