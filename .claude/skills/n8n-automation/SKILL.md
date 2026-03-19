---
name: n8n-automation
description: n8n 워크플로 자동화 설계 및 구현. RSS 수집, AI 콘텐츠 생성, 소셜미디어 자동 포스팅, 이메일 시퀀스, 웹훅 처리 등 자동화 파이프라인 구축 시 자동 호출.
trigger: n8n, 워크플로, 자동화, webhook, 파이프라인
---

# n8n 자동화 스킬

## 트리거 조건
- "n8n", "워크플로", "자동화" 키워드 감지 시
- webhook, 스케줄러, 트리거 관련 요청 시
- 외부 API 연동 자동화 요청 시

## 환경 정보
- n8n 호스팅: bsd.ai.kr (Railway)
- 커뮤니티 노드: n8n-nodes-mediafx (FFmpeg 기반)
- MCP 서버: https://bsd.ai.kr/mcp-server/http

## 워크플로 설계 프레임워크

### 1단계: 요구사항 분석
```
입력(Input)은 무엇인가? → RSS, Webhook, 스케줄, 수동 트리거
처리(Process)는 무엇인가? → AI 변환, 필터링, 포맷팅
출력(Output)은 무엇인가? → 소셜 포스팅, 이메일, DB 저장, 알림
에러 시 어떻게 하나? → 재시도, 알림, 로깅
```

### 2단계: 노드 구성 패턴

#### RSS → AI 콘텐츠 → 멀티플랫폼 포스팅
```
[RSS Feed] → [IF 필터] → [OpenAI Chat] → [Switch 플랫폼별]
                                              ├→ [Threads 포스트]
                                              ├→ [Instagram 이미지+캡션]
                                              └→ [YouTube 설명 업데이트]
```

#### Facebook Lead → CRM → 이메일 시퀀스
```
[Facebook Trigger] → [Google Sheets 저장]
                   → [Gmail 환영 이메일]
                   → [Solapi 카카오 알림톡]
                   → [Wait 1일] → [후속 이메일]
```

#### 유튜브 쇼츠 자동 생성
```
[Webhook 트리거] → [OpenAI 스크립트 생성]
                 → [ElevenLabs TTS]
                 → [D-ID 아바타 생성]
                 → [MediaFX 영상 합성]
                 → [YouTube 업로드]
```

### 3단계: 필수 노드 규칙
- **Error Trigger**: 모든 워크플로에 에러 처리 노드 포함
- **노드 이름**: 한국어로 명확하게 (예: "AI 콘텐츠 생성", "인스타 포스팅")
- **크레덴셜**: JSON 내 크레덴셜 정보 절대 포함 금지
- **Webhook URL**: 환경변수 또는 n8n 내부 변수 사용

### 4단계: 카카오톡 토큰 관리
```
[토큰 관리 워크플로]
├→ 토큰 만료 30분 전 자동 갱신
├→ 갱신 실패 시 Slack 알림
└→ 갱신된 토큰을 다른 워크플로에 전파
```

## 워크플로 JSON 백업 규칙
- 파일명: `n8n/YYYYMMDD_워크플로명.json`
- 크레덴셜 ID 제거 후 저장
- README에 워크플로 목록 유지

## 자주 사용하는 n8n 표현식
```javascript
// 현재 날짜 (한국 시간)
{{ $now.setZone('Asia/Seoul').toFormat('yyyy-MM-dd HH:mm') }}

// JSON 파싱
{{ JSON.parse($json.body) }}

// 이전 노드 데이터 참조
{{ $('노드이름').item.json.fieldName }}

// 조건부 값
{{ $json.type === 'post' ? '게시물' : '스토리' }}
```
