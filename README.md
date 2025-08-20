# ProductListApp

## 개요

상품 리스트와 상세 화면을 표시하는 iOS 애플리케이션입니다.
**UIKit + MVVM** 구조로 구성되며, 상품 리스트는 JSON 파일에서 데이터를 로드하고 상세 화면은 `WKWebView`를 통해 상품 URL을 로드합니다. 

클린 아키텍처와 의존성 주입을 통해 유지보수성과 테스트 가능성을 높였습니다. 
실제 서비스에 적용된다는 생각을 가지고 범용성과 확장성을 위해, 프로토콜과 공용 클래스 기초 작업을 탄탄히 구조 설계하여 작업하였습니다.

---

## 핵심 기능

### 필수 구현사항
- **상품 리스트 화면**
  - UICollectionView로 구현된 상품 목록 
  - 상품명, 가격, 썸네일 이미지 표시
- **상품 상세 화면**
  - 셀 탭 시 WKWebView로 상품 고유 URL을 로드하여 상품 상세 정보 표시
- **UI/UX 완성도**
  - SF Symbol 활용
  - 시스템, 브랜딩 색상 사용
  - User Interface Style(라이트,다크 모드 지원)등 HIG 준수

### 추가 구현사항
- **공통 클래스**
  - **`BaseNavigationController`**: 네비게이션 바의 색상, 버튼 스타일 등을 표준화하여 일관된 내비게이션 경험 제공
  - **`BaseViewController`**: 뷰 컨트롤러의 공통 설정(배경색, 기본 탬플릿 메서드 등)을 중앙화하여 코드 중복 감소
  - **`AppDependencyViewController`**: 뷰컨트롤러의 의존성 주입을 표준화하여 테스트 가능성과 유지보수성 향상
  - **`BaseWebViewController`**: `WKWebView`의 설정, 로딩 등을 중앙화하여 웹뷰 기반 화면의 재사용성 향상
  - **`Cellable`**: `UICollectionViewCell`의 등록과 재사용을 간소화하는 프로토콜로, 타입 안전한 셀 관리
- **레이아웃 전환**
  - `UICollectionView` 기반 2가지 레이아웃(2열 Half / 1열 Full) 토글
- **이미지 캐싱**
  - ImageManager를 통한 이미지 로딩/캐싱 매니저
- **의존성 주입** 
  - `ProductServiceProtocol`,`ViewControllerInstantiable` 등 프로토콜 기반의 결합 구조를 느슨하게 관리
- **상품 정보 표시**
  - 브랜드, 평점, 리뷰 수 등 상품의 추가 정보를 적절히 표시
  - `HorizontalTextBoxView`: 재사용성이 좋은 커스텀뷰로 태그/혜택을 가로 text box 형태로 표현
- **테스트**
  - 유닛 테스트: 모델, 서비스(JSON 로딩), 뷰모델(레이아웃 토글), 싱글톤, 숫자 포맷팅
  - UI 테스트: 앱 런치, 메인 화면 요소, 셀 탭 상세 이동, 레이아웃 토글, 스크롤, 런치 퍼포먼스
  

---

## 빌드 및 실행 방법

1. **요구사항**:

   - Xcode 15 이상
   - iOS 16.0 이상 
   - Swift 5.0 이상

2. **설치 및 실행**:

   ```bash
   # 1. 리포지토리 클론
   git clone https://github.com/may-ios/Swift-ProductListApp.git
   
   # 2. 프로젝트 디렉토리로 이동
   cd ProductListApp
   
   # 3. Xcode에서 프로젝트 열기
   open ProductListApp.xcodeproj
   ```

   - Xcode에서 `ProductListApp` 타겟을 선택하고, iOS 시뮬레이터 또는 디바이스를 선택하여 빌드 및 실행합니다.
   - 최대한 프로젝트에 외부 라이브러리 의존성이 없게 만들었으므로 추가 설치가 필요 없습니다.
   
---

## 앱 동작 방법

1. Xcode에서 프로젝트를 열고 빌드합니다.
2. 상품 리스트 화면:
   - 상품을 탭하여 상세 페이지로 이동합니다.
   - 우측 상단 버튼으로 레이아웃 전환합니다.
   - 로고 버튼으로 리스트 상단 스크롤합니다.
3. 상세 화면에서 웹뷰 로딩 상태를 프로그레스 바로 확인합니다.

---

## 사용된 기술 및 라이브러리

### 언어 및 아키텍처
- **Swift 5**
- **아키텍처**: MVVM, 클린 아키텍처, 의존성 최소화/역할 단일화

### 프레임워크
- **UIKit**: 메인 UI 구현
- **WebKit**: WKWebView를 통한 웹 콘텐츠 표시
- **XCTest**: 유닛 테스트 및 UI 테스트

### 핵심 기술
- **프로토콜 지향 프로그래밍**: Cellable, Fontable, WebDependency 등
- **제네릭**: 타입 안전한 셀 등록/재사용 시스템
- **Extension**: UIFont, String, Int, Bundle 등 편의 기능 확장
- **라이브러리**: 외부 라이브러리 사용 없음 (내장 프레임워크만 사용)
- **기타**: Auto Layout, NSCache, JSONDecoder

### 데이터 처리
- **JSON 파싱**: Foundation의 Codable 활용
- **Bundle 리소스**: 로컬 JSON 파일에서 Mock 데이터 로딩

### MVVM 패턴
- **Model**: Product, ProductService
- **View**: ProductListViewController, ProductDetailViewController
- **ViewModel**: ProductListViewModel

### 의존성 주입
```swift
// 프로토콜 기반 의존성 주입
protocol WebDependency { ... }
class WebViewComponent: BaseWebViewComponent { ... }
class ProductDetailViewController: BaseWebViewController<WebViewComponent>
```

---


## 📁 폴더 구조

```
ProductListApp/
├─ ProductListApp/
│  ├─ Resources/
│  │  └─ products/                # 로컬 JSON(Mock) 데이터
│  └─ Sources/
│     ├─ Cells/
│     │  ├─ ProductCell/          # 상품 셀
│     │  └─ TextBoxCell/          # Tag/Benefit 셀
│     ├─ Extensions/              # Int/String/UIFont 등 확장
│     ├─ Models/                  # Product
│     ├─ Protocols/               # XIB,Cellable, Web Wrapper 등
│     ├─ Services/                # ProductService(JSON 로딩)
│     ├─ Utils/                   # ImageManager.
│     ├─ ViewControllers/
│     │  ├─ Base/                 # BaseViewController, BaseWebViewController
│     │  ├─ ProductDetail/        # 상세 화면(웹)
│     │  └─ ProductList/          # 목록 화면
│     ├─ ViewModels/              # ProductListViewModel
│     ├─ Views/                   # HorizontalTextBoxView, ProductListCollectionViewLayout 등
│     └─ WebComponents/           # WebDependency/WebConfiguration/WebProcessPool
├─ ProductListAppTests/           # Unit Tests
└─ ProductListAppUITests/         # UI Tests
```

> 최초 진입은 `SceneDelegate`에서 `ProductListViewController.navigation(dependency: ProductListViewModel())`를 루트로 구성합니다.


---

## 테스트

- **단위 테스트**:
  - `Product` 모델의 속성 초기화 테스트.
  - `ProductService`의 JSON 데이터 로드 테스트.
  - `ProductListViewModel`의 초기화 및 레이아웃 토글 테스트.
  - `ImageManager`의 싱글톤 인스턴스 테스트.
  - `Int + extension`의 숫자(가격) 포맷팅(`withCommas`) 테스트.

- **UI 테스트**:
  - 앱 실행 테스트.
  - 메인 화면의 컬렉션 뷰와 네비게이션 바 존재 확인.
  - 상품 셀 탭으로 상세 화면 전환 확인.
  - 레이아웃 토글 버튼 동작 확인.
  - 앱 실행 성능 테스트.
  
---

## 과제 요구사항 

| 요구사항 | 구현 내용 |
|---|---|
| **상품 리스트 화면** | 로컬 JSON(Mock) 데이터 3개 이상 로드 → `UICollectionView`로 그리드 표시 |
| **상품 상세 화면** | 셀 선택 시 네비게이션 전환, `WKWebView`로 각 상품 URL 로딩 |
| **UI/UX 완성도** | 네비게이션/레아이웃 토글, 가격/태그/혜택/평점 시각화, 재사용/확장 가능한 컴포넌트 |
| **가산점(예시)** | MVVM, 테스트(Unit/UI), 문서화, 커스텀 레이아웃/컴포넌트 |

---

## 개선 가능 사항

- **접근성**: VoiceOver 및 Dynamic Type 지원 강화.
- **테스트 커버리지**: `PriceData`, `RatingData`, 비동기 이미지 로딩 테스트 추가.
- **에러 처리**: 데이터 로딩, 이미지 로딩, 웹뷰 요청 실패 시 사용자 알림 확장.

---

## 빌드 노트

- 외부 서드파티 의존성 없이 동작합니다.
- 리소스 JSON은 `Resources/products/`에 포함되어 있으며, 서비스에서 로드합니다.
- 앱 라우팅/주입은 SceneDelegate에서 구성합니다.

---

## 과제 소요 시간

- **총 소요 시간**: 약 7시간
  - 기본 구조 및 UI 구현: 5시간
  - 테스트 작성: 1시간
  - 코드 리팩토링 및 문서화: 1시간

---

**개발자**: 강명은

**문의**: akme762@naver.com

**감사합니다.**
