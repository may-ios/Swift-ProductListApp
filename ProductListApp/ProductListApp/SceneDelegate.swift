//
//  SceneDelegate.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // UIWindowScene으로 타입캐스팅 안전성 체크
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        // 상품 리스트를 네비게이션 컨트롤러와 함께 rootViewController로 설정
        let navigation = ProductListViewController.navigation(dependency: ProductListViewModel())
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        
        // 클래스 프로퍼티에 윈도우 저장
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }

}

