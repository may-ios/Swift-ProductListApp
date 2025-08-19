//
//  ImageManager.swift
//  ProductListApp
//
//  Created by kme on 8/15/25.
//

import Foundation
import UIKit

// MARK: - ImageManager
// 이미지를 비동기적으로 로드하고 캐싱하는 싱글톤 클래스
final class ImageManager {
    static let shared = ImageManager()
    
    // 메모리 캐시로 이미지 저장 (NSCache 사용으로 메모리 부담될 시 자동 해제)
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        // 메모리 효율성을 위해 캐시 최대 개수 제한
        cache.countLimit = 100
    }
    
    // URL로 이미지를 비동기 로드
    func load(from url: URL) async -> UIImage? {
        let key = url.absoluteString
        
        // 캐시에 이미지가 있으면 반환
        if let cachedImage = cache.object(forKey: key.nsString){
            return cachedImage
        }
        
        // URL에서 데이터 로드
        guard let (data, _ ) = try? await URLSession.shared.data(from: url),
              let image = UIImage(data: data) else {
            return nil
        }
        
        // 캐시에 이미지 저장
        cache.setObject(image, forKey: key.nsString)
        return image
    }
    
}
