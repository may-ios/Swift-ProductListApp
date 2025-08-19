//
//  Fontable.swift
//  ProductListApp
//
//  Created by kme on 8/15/25.
//

import Foundation
import UIKit

// MARK: - Fontable
/// 폰트 이름과 사이즈를 통해 UIFont 인스턴스를 생성하는 프로토콜
protocol Fontable {
    var name: String { get }            // 폰트 이름
    func font(size: CGFloat) -> UIFont // 지정된 크기의 폰트 인스턴스 생성
}

// MARK: - Fontable 기본 구현
/// 폰트명과 크기로 UIFont 인스턴스 생성
/// 없다면 시스템 폰트로 반환
extension Fontable {
    func font(size: CGFloat) -> UIFont {
        UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
