# 알쓸장터
<img src="https://user-images.githubusercontent.com/103241214/193568205-558c0b45-988d-45b4-bb62-c12c27f78e02.png" height="100">  <img src="https://user-images.githubusercontent.com/103241214/193567596-c014f896-5265-476d-bf0a-6248901d7da9.png" width="600">
+ 사이트의 회원들이 판매하고자 하는 상품을 올리거나 사이트에 올라온 상품을 구입할 수 있도록 돕는 것을 목적으로 했습니다.
+ 당근마켓과 번개장터를 벤치마킹 했습니다.
+ 프로젝트 기간 : 05/13 ~ 06/10
+ 프로젝트 참가 인원 : 5명

## 주요 기능
+ 로그인, 회원가입
+ 판매글 작성 / 검색 / 정렬 / 필터링
+ 개인 정보 관리
+ 채팅


## Stacks
<img src="https://img.shields.io/badge/Java-3776AB?style=flat-square&logo=Java&logoColor=white"/> <img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=flat-square&logo=JavaScript&logoColor=white"/> <img src="https://img.shields.io/badge/CSS-1572B6?style=flat-square&logo=CSS3&logoColor=white"/> <img src="https://img.shields.io/badge/mysql-4479A1?style=flat-square&logo=mysql&logoColor=white"/> <img src="https://img.shields.io/badge/Amazon RDS-527FFF?style=flat-square&logo=Amazon RDS&logoColor=white"/> <img src="https://img.shields.io/badge/Apache Tomcat-F8DC75?style=flat-square&logo=Apache Tomcat&logoColor=white"/> <img src="https://img.shields.io/badge/Amazon EC2-FF9900?style=flat-square&logo=Amazon EC2&logoColor=white"/> 


## 본인이 구현한 기능
#### 로그인, 회원가입
<img src="https://user-images.githubusercontent.com/103241214/202349198-cb85e5fd-a9b3-4d84-b01f-90fc1146d763.png" height="300"> <img src="https://user-images.githubusercontent.com/103241214/202349226-2f185e95-1e7b-4582-a756-0a1132ae39d1.png" height="300">
+ 로그인 되지 않은 상태에서 메인페이지의 알쓸톡 버튼을 누르거나 로그인/회원가입 버튼을 누를 경우 이동가능합니다.
+ 로그인 실패시 login failed 표시가 약 1초간 보였다 페이드아웃 됩니다.

<img src="https://user-images.githubusercontent.com/103241214/202350007-199e5dec-ccb6-4d40-95f2-adad0633dcde.png" height="400"> <img src="https://user-images.githubusercontent.com/103241214/202350196-eb24c411-c7ff-4dec-8f8a-22b088f92374.png" height="400">
+ 로그인 페이지에서 회원가입 버튼을 누를 경우 이동가능합니다.
+ 유효성 검사를 통해 이메일, 패스워드, 전화번호를 체크하고 일치하지 않을 경우 경고 표시를 띄웁니다.
(이메일의 경우 이미 db에 존재할 경우에도 경고 표시를 띄웁니다)
+ 채워지지 않은 칸이 있거나 입력한 값이 형식에 어긋날 경우 하단에 please fill all the required field 표시가 약 1초간 보였다 페이드아웃 됩니다.


#### 메인페이지(인기 매물 리스트)
![alssle_main](https://user-images.githubusercontent.com/103241214/202347407-f2d8e48d-7348-4736-a58a-50b9d50bfad3.png)
+ 검색어 입력후 엔터를 누르거나 돋보기 버튼 클릭시 검색결과 창으로 이동합니다.
+ 조회수가 가장 높은 15개 글을 인기 매물 리스트로 나열합니다.
+ 로그인 상태시 상단의 로그인/회원가입 버튼이 마이페이지로 변경됩니다.


#### 검색창(필터, 정렬기능)
![alssle_result](https://user-images.githubusercontent.com/103241214/202350998-6ccbb686-3d88-4348-a910-d1619227b438.png)
+ 정렬기능의 경우 최신순, 낮은가격순, 높은 가격순 정렬이 가능합니다.
+ 필터기능의 경우 카테고리, 가격범위, 글 작성 기간에 따라 조건을 주는 것이 가능합니다.
+ 정렬버튼을 누를 경우 해당 필터 조건은 유지됩니다.
