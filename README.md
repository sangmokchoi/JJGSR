# 찍신강림
<img
  src="https://github.com/user-attachments/assets/ed77fb9f-f917-4947-a9ad-5738fc586f79"
  width="50%"
/>
</br>


## 00. 개요

- **개발 기간:** 2023.06.19 - 2023.06.28

- **Github:** [https://github.com/sangmokchoi/JJGSR](https://github.com/sangmokchoi/JJGSR)

- **App Store:** [<찍신강림> 다운로드 바로가기](https://apps.apple.com/app/%EC%B0%8D%EC%8B%A0%EA%B0%95%EB%A6%BC/id6504901441)
- **Play Store:** (배포중)[<찍신강림> 다운로드 바로가기](https://play.google.com/store/apps/details?id=com.app.JJGSR)

- 기술 구조 요약
  - **UI:** `Figma`
  - **Architecture**: `MVVM`
  - **Data Storage**: (Firebase) `Firestore Database`
  - **Library/Framework:**
      - **Firebase**
      `Crashlyitics`, `Remote Config`
      - **Google**
      `Analytics`
      - **Flutter**
      `Provider`

</br>

## 01. 찍신강림 소개 및 기능

<aside>

■ [ 쇼츠만 보지말고 공부해야지~? ]
그래서, 숏폼 형태의 학습 플랫폼을 만들었습니다.
'빠르게' 그리고 '많이' 풀다보면 자연스럽게 실력이 오를거에요!

■ [ 바쁘다 바빠, 현대사회! ]
출퇴근 길에서, 자기 전 침대에 누워
빠르게 풀고 넘기는 '찍신강림'을 이용해보세요.

■ [ 공부도 숏폼처럼 빠르게, 많이 ]
유튜브 쇼츠, 인스타그램 릴스 보듯이 위아래로 넘겨 푸는 방식의 교육 앱이에요.
주어진 시간 동안 빠르게 풀수 있는 객관식 문제를 제공해요.
한번 푼 문제는 '정답', '오답', 'PASS' 카테고리로 분류해드려요.
별도의 로그인 없이 홈 화면에서 화면을 끌어당기면, 수십개의 문제를 불러올 수 있어요.

■ [ 다음 업데이트는? ]
토익, 한국사, 컴활, 한국어 등 공기업, 공무원 취업 준비를 위한 문제를 업데이트 할 예정이에요.

</aside>

</br>


## 02. 구현 사항

<table>
  <tr>
    <td align="center"><b>2.1. 풀고 싶은 문제 찾아보기</b><br /><br /><img src="https://github.com/user-attachments/assets/29e09372-5ea1-4ac5-9fc1-092a65017709" width="200"/></td>
    <td>
      <p>
        원하는 카테고리를 선택하면, 문제들이 숏츠나 릴스의 썸네일처럼 화면에 나타납니다. 풀고싶은 문제를 누르면, 퀴즈 화면으로 넘어갑니다.
        맞춘 문제, 틀린 문제, Pass한 문제들을 나눠서 볼 수 있습니다.
      </p>
    </td>
  </tr>
  <tr>
    <td align="center"><b>2.2. 위 아래로 쓱쓱 넘기며 퀴즈 풀기</b><br /><br /><img src="https://github.com/user-attachments/assets/74803f05-f06e-4deb-a7fc-e25950f4ed57" width="200"/></td>
    <td>
    <p>
        주어진 시간 내에 객관식 문제를 풉니다. 시간이 경과되면, 그 다음 문제로 자동으로 넘어갑니다.
      Pass하고 싶다면, 그 다음 문제로 쓱쓱 넘겨주세요.
      </p>
    </td>

  </tr>
  <tr>
    <td align="center"><b>2.3. 정답 확인하기</b><br /><br /><img src="https://github.com/user-attachments/assets/8f5789ae-f40a-491a-9a17-71fe2635c507" width="200"/></td>
    <td>
<p>
        보기 중에서 답을 고르면, 곧장 정답과 오답이 나타납니다. 정답을 맞추게 되면 정답인 보기가 녹색으로 바뀝니다.
      </p>
</td>
</table>



</br>



</br>
