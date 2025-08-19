//
//  Bundle+Extension.swift
//  ProductListApp
//
//  Created by kme on 8/15/25.
//

import Foundation

// MARK: - Bundle 확장
extension Bundle {
    
    // 지정된 리소스 이름의 JSON 파일에서 데이터를 로드
    class func dataFromJson(for resource: String?) -> Data? {
        guard let url = main.url(forResource: resource, withExtension: "json") else { return nil }
        return try? Data(contentsOf: url)
    }
}
