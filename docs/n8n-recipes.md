# n8n 워크플로 레시피 모음

> 검증된 n8n 워크플로 패턴 모음. n8n-architect 에이전트가 참조합니다.

## 레시피 1: RSS → AI 콘텐츠 → 쓰레드 자동 포스팅

### 용도
RSS 피드에서 새 글을 감지하면 AI가 쓰레드용 콘텐츠로 변환하여 자동 포스팅

### 노드 구성
```
[Schedule Trigger: 매 1시간]
  → [RSS Feed Read: 피드 URL]
  → [IF: 새 글인지 확인 (Google Sheets 중복 체크)]
  → [OpenAI Chat: 쓰레드용 변환 프롬프트]
  → [HTTP Request: Threads API 포스팅]
  → [Google Sheets: 포스팅 기록 저장]
  → [Error Trigger → Slack 알림]
```

### AI 프롬프트
```
원본 기사를 500자 이내의 쓰레드 포스트로 변환하세요.

규칙:
- 첫 줄은 강력한 훅 (질문 또는 충격적 사실)
- 본문은 3-5줄로 핵심만
- 마지막 줄에 CTA
- 해시태그 3개
- 이모지 적절히 사용
- 한국어로 작성

원본: {{$json.content}}
```

---

## 레시피 2: Facebook Lead → 자동 응대 시퀀스

### 용도
Facebook 리드 광고로 들어온 신규 리드에게 즉시 환영 메시지 + 이메일 시퀀스 시작

### 노드 구성
```
[Facebook Lead Ads Trigger]
  → [Set: 데이터 정리 (이름, 전화, 이메일)]
  → [Google Sheets: 리드 DB 저장]
  → [분기 (Parallel)]
      ├→ [Gmail: 환영 이메일 발송]
      ├→ [Solapi: 카카오 알림톡 발송]
      ├→ [ConvertKit: 구독자 추가 + 시퀀스 태그]
      └→ [Slack: #신규리드 채널 알림]
  → [Error Trigger → 관리자 이메일 알림]
```

### 환경변수 필요 목록
```
FACEBOOK_PAGE_ACCESS_TOKEN
GMAIL_OAUTH_CREDENTIALS
SOLAPI_API_KEY / SOLAPI_API_SECRET
CONVERTKIT_API_SECRET
SLACK_WEBHOOK_URL
```

---

## 레시피 3: 유튜브 쇼츠 자동 생성 파이프라인

### 용도
주제를 입력하면 스크립트→음성→아바타→자막→최종 영상을 자동 생성

### 노드 구성
```
[Webhook Trigger: POST /generate-shorts]
  → [OpenAI Chat: 60초 스크립트 생성]
  → [HTTP Request: ElevenLabs TTS API]
  → [HTTP Request: D-ID 아바타 영상 생성]
  → [Wait: 아바타 렌더링 대기 (폴링)]
  → [HTTP Request: 아바타 영상 다운로드]
  → [MediaFX: 자막 오버레이]
  → [MediaFX: BGM 믹싱]
  → [MediaFX: 인트로/아웃트로 병합]
  → [HTTP Request: YouTube Upload API]
  → [Slack: 완료 알림 + 영상 링크]
```

### D-ID 폴링 패턴
```
[D-ID 생성 요청]
  → [Wait 30초]
  → [HTTP Request: 상태 확인]
  → [IF: status === 'done']
      ├→ YES: 다운로드 진행
      └→ NO: [Wait 15초] → 상태 재확인 (최대 5회)
```

---

## 레시피 4: 카카오톡 토큰 자동 갱신

### 용도
카카오 OAuth 토큰을 만료 전 자동으로 갱신하여 알림톡 발송 중단 방지

### 노드 구성
```
[Schedule Trigger: 매 50분]
  → [HTTP Request: 카카오 토큰 정보 조회]
  → [IF: 만료까지 600초 미만]
      ├→ YES: [HTTP Request: Refresh Token으로 갱신]
      │        → [n8n Credential 업데이트]
      │        → [Slack: 갱신 성공 알림]
      └→ NO: [No Operation]
  → [Error Trigger]
      → [Slack: ⚠️ 토큰 갱신 실패 알림]
      → [Gmail: 관리자에게 수동 갱신 요청]
```

---

## 레시피 5: 원소스 멀티플랫폼 자동 업로드

### 용도
하나의 콘텐츠(블로그 글, 영상)를 여러 플랫폼에 맞게 변환하여 동시 게시

### 노드 구성
```
[Webhook: 새 콘텐츠 등록]
  → [OpenAI: 원본 분석 및 핵심 추출]
  → [Switch: 활성화된 플랫폼 분기]
      ├→ [OpenAI: 쓰레드용] → [Threads API]
      ├→ [OpenAI: 인스타용] → [Instagram API]
      ├→ [OpenAI: 블로그용] → [Naver Blog API]
      ├→ [OpenAI: 뉴스레터용] → [ConvertKit]
      └→ [OpenAI: 카카오용] → [카카오 채널 포스트]
  → [Google Sheets: 게시 현황 기록]
  → [Slack: 전체 게시 완료 요약]
```

---

## 공통 규칙

### 에러 처리 필수 패턴
```
모든 워크플로에 반드시 포함:
1. Error Trigger 노드
2. 에러 발생 시 Slack 또는 이메일 알림
3. 재시도 로직 (최대 3회, 간격 점진 증가)
4. 에러 로그 Google Sheets 기록
```

### 크레덴셜 관리
```
절대 금지:
- 워크플로 JSON에 크레덴셜 하드코딩
- Webhook URL에 API 키 포함
- 노드 설명에 비밀번호 기록

필수:
- n8n 크레덴셜 매니저 사용
- 환경변수 활용
- 백업 시 크레덴셜 ID 제거
```
