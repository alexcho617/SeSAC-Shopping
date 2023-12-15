# SeSAC-Shopping
 ## 과제 내용

Naver Open API를 사용하여 상품을 검색하고 좋아요를 관리하며 WKWebView를 사용한 상세페이지 조회가 가능한 앱

## 실행 환경

- iOS 13.0+
- Portrait Mode
- Dark/Light 모드 지원

## 기술 스택

- UIKit
- SnapKit
- Alamofire
- Kingfisher
- Realm

## 요구사항 및 기능

- [x]  쇼핑 API를 사용한 검색 및 페이지네이션(30개씩, 1000개 제한)
- [x]  좋아요 추가/제거 및 모든 화면 동기화
- [x]  Realm을 통한 좋아요 목록 영구 저장
- [x]  좋아요 목록 실시간 검색
- [x]  Kingfisher를 사용한 View Cell 메모리 사용 개선

## 트러블슈팅

### D**B ↔ UI 일관성**

데이터베이스에서 좋아요를 표시한 상품을 삭제할 때 **런타임 에러**가 발생했습니다. 이유는 삭제하려던 Realm 오브젝트에 의존하고 있던 UI가 있었기 때문입니다. 따라서 데이터베이스에 추가와 삭제를 할 때는 Realm 오브젝트 인스턴스를 별도로 생성하여 UI와 로직의 **의존성을 낮추었고** 데이터베이스와 UI의 **일관성을 유지**시킬 수 있었습니다.

### 이미지 다운샘플링을 통한 메모리 사용량 개선

많은 양의 상품 데이터를 의도적으로 가져와서 앱의 메모리 사용량을 관찰했습니다. Kingfisher 라이브러리를 통해 네트워크 이미지를 로딩한 후 화면에 보이는 이미지 뷰의 크기에 비해 불필요하게 **해상도가 높은** 이미지가 불러와지고 있었습니다.

따라서 Kingfisher 문서를 참고하여 이미지 **다운 샘플링** 코드를 반영하여 앱의 **메모리 사용을 개선**하였고 앱의 **프레임 드롭 현상도 개선**되었습니다.

**Before**
<br>
<img width="664" alt="image" src="https://github.com/alexcho617/SeSAC-Shopping/assets/38528052/60f6cdec-d131-4fba-a8b3-1d2469369eed">
<br>
이미지 다운샘플링 전 메모리 사용량 피크 750~MB

**After**

<img width="664" alt="image" src="https://github.com/alexcho617/SeSAC-Shopping/assets/38528052/897aac71-a1ca-47d0-a3ff-e4a5d04d503c">
<br>
다운샘플링 후 메모리 사용량: 피크 120~MB

## 결과 화면
<img width="664" alt="image" src="https://github.com/alexcho617/SeSAC-Shopping/assets/38528052/2281e6af-1ea2-4450-aafb-ac45777dcf6e">

<img width="664" alt="image" src="https://github.com/alexcho617/SeSAC-Shopping/assets/38528052/2772a6c7-a462-4fcf-8045-4241b70f4faa">

<img width="664" alt="image" src="https://github.com/alexcho617/SeSAC-Shopping/assets/38528052/c9b11af3-9748-4681-aea7-be991e85c9d9">

<img width="664" alt="image" src="https://github.com/alexcho617/SeSAC-Shopping/assets/38528052/6fd5b507-b474-4060-b00f-266266b19065">

## 회고
먼저 View를 로직과 더욱 분리 시킬 수 있을 것 같습니다. 검색 화면의 경우 View 파일을 따로 작성하였지만 뷰와 로직의 경계가 모호한 점이 있어 오히려 간결하게 구현시킬 수 있는 부분들 또한 돌아갔던 것 같습니다. 그에 비해 좋아요 화면은 ViewController 안에 필요한 모든 View들을 담았습니다. 그 이유는 검색 화면에 비해 기능이 간결하였기 때문에 뷰를 따로 만들어야 할 필요성을 느끼지 못하였습니다. 그 결과 개발 시간을 단축할 수 있었지만 추후 뷰가 복잡해진다면 이 또한 뷰 계층을 격리해야 할 여지가 있습니다.

두 번째로는 상태 관리 프레임워크를 사용하여 현재는 각 화면 독립적으로 데이터베이스를 참조하는 것을 한곳으로 모아 UI와 데이터베이스 간의 개별적인 통신 모듈을 고안할 수 있습니다. 그리하여 코드 재사용률을 높이고 추가적으로 화면이 생겨도 scalable 하게 대응할 수 있을 것 같습니다.

기술에 대한 제 의견은 필요성과 사용자의 실질적인 이득이 우선되어야 한다고 생각합니다. 특정 패턴, 특정 프레임 워크를 사용하면 장점이 분명히 있지만 단점 또한 존재하기 때문에 상황에 따라 맞는 도구를 사용하는 것이 좋은 개발자의 자세라고 생각합니다.

긴 글 읽어주셔서 감사합니다.
