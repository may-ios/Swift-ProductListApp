//
//  Wrapper.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import Foundation

// MARK: - Wrapper
/// 래핑된 객체를 제공하는 프로토콜
public protocol Wrapper {
    associatedtype Wrapped
    var wrapped: Wrapped { get }
}
