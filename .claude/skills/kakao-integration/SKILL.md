---
name: kakao-integration
description: 카카오톡 알림톡/친구톡 연동 전문 스킬. Solapi API 활용, OAuth 토큰 자동 갱신, n8n 워크플로 연동.
trigger: 카카오, 알림톡, 친구톡, solapi, 카톡
---

# 카카오톡 연동 스킬

## 트리거 조건
- "카카오톡", "알림톡", "친구톡", "Solapi" 키워드 감지 시
- SMS/MMS 발송 관련 요청 시

## Solapi 연동 패턴

### 알림톡 발송 (Node.js)
```typescript
import axios from 'axios'
import crypto from 'crypto'

function getSolapiAuth() {
  const apiKey = process.env.SOLAPI_API_KEY!
  const apiSecret = process.env.SOLAPI_API_SECRET!
  const date = new Date().toISOString()
  const salt = crypto.randomBytes(32).toString('hex')
  const signature = crypto
    .createHmac('sha256', apiSecret)
    .update(date + salt)
    .digest('hex')

  return {
    'Authorization': `HMAC-SHA256 apiKey=${apiKey}, date=${date}, salt=${salt}, signature=${signature}`,
    'Content-Type': 'application/json'
  }
}

async function sendAlimtalk(to: string, templateId: string, variables: Record<string, string>) {
  const response = await axios.post(
    'https://api.solapi.com/messages/v4/send',
    {
      message: {
        to,
        from: process.env.SOLAPI_SENDER_NUMBER,
        kakaoOptions: {
          pfId: process.env.KAKAO_CHANNEL_ID,
          templateId,
          variables
        }
      }
    },
    { headers: getSolapiAuth() }
  )
  return response.data
}
```

### 카카오 OAuth 토큰 관리 (n8n 패턴)
```
[스케줄: 매 50분] → [현재 토큰 확인]
    → [만료 임박?]
        ├─ YES → [Refresh Token 요청] → [새 토큰 저장] → [성공 로그]
        └─ NO → [스킵]

[에러 발생 시]
    → [Slack 알림: "카카오 토큰 갱신 실패"]
    → [수동 갱신 링크 제공]
```

### 알림톡 템플릿 패턴
```
# 강의 등록 완료
#{고객명}님, 바이브코딩 마스터클래스 등록이 완료되었습니다!

📅 일정: #{시작일} ~ #{종료일}
📍 장소: #{장소}
💳 결제금액: #{금액}원

자세한 안내는 이메일을 확인해주세요.

[강의 안내 확인하기](#{링크})
```

## n8n 워크플로 연동

### Facebook Lead → 카카오 알림
```
[Facebook Trigger]
    → [데이터 매핑: 이름, 전화번호]
    → [Solapi 알림톡 발송]
    → [Google Sheets 기록]
    → [실패 시 SMS 대체 발송]
```

### 필수 환경변수
```bash
SOLAPI_API_KEY=         # Solapi API 키
SOLAPI_API_SECRET=      # Solapi API 시크릿
SOLAPI_SENDER_NUMBER=   # 발신번호 (사전 등록 필수)
KAKAO_CHANNEL_ID=       # 카카오 채널 ID (pfId)
KAKAO_REST_API_KEY=     # 카카오 REST API 키
KAKAO_REDIRECT_URI=     # OAuth 리다이렉트 URI
```

## 주의사항
- 알림톡 템플릿은 카카오 비즈니스 채널에서 **사전 승인** 필요
- 발신번호는 통신사에 **사전 등록** 필요
- 야간 발송 제한: 20:50 ~ 08:00 (광고성)
- 수신 거부 처리 로직 필수 구현
