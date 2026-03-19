---
name: email-automation
description: 이메일 마케팅 자동화 스킬. ConvertKit 시퀀스, Gmail SMTP, 리드 너처링, A/B 테스트 패턴.
trigger: 이메일, 시퀀스, 뉴스레터, convertkit, 자동 발송
---

# 이메일 자동화 스킬

## 이메일 시퀀스 아키텍처

### 전체 시스템 구조
```
[리드 유입] → [ConvertKit 구독자 등록]
    → [태그 기반 시퀀스 자동 시작]
    → [행동 기반 분기 (오픈/클릭/구매)]
    → [n8n: 카카오/SMS 보조 알림]
```

### BSD 182 이메일 시퀀스 구조 (1년)
```
Phase 1: 온보딩 (Day 0-7, 7통)
  → 환영, 가치 전달, 신뢰 구축

Phase 2: 교육 (Day 8-30, 10통)
  → 바이브코딩 팁, 케이스 스터디

Phase 3: 관계 구축 (Day 31-90, 20통)
  → 심화 콘텐츠, 커뮤니티 참여

Phase 4: 소프트 셀 (Day 91-120, 15통)
  → 성공 사례, 강의 소개

Phase 5: 장기 너처링 (Day 121-365, 130통)
  → 주 2-3회, 가치+소프트 셀 반복
```

### 이메일 제목 패턴 (오픈율 30%+)
```
숫자형: "바이브코딩으로 3일 만에 만든 5가지 웹사이트"
질문형: "아직도 개발자한테 돈 내고 계신가요?"
호기심: "제가 절대 안 알려주려던 n8n 자동화 비밀"
긴급성: "[마감 D-3] 올해 마지막 마스터클래스"
실패담: "첫 온라인 강의에서 매출 0원을 찍은 이유"
```

### n8n 이메일 자동화 워크플로
```
[Facebook Lead Ad 트리거]
    → [Google Sheets 저장]
    → [ConvertKit: 구독자 추가 + 태그]
    → [Gmail: 즉시 환영 이메일]
    → [Solapi: 카카오 알림톡]
    → [Wait 24h]
    → [ConvertKit: 시퀀스 시작]
```

### ConvertKit API 연동
```typescript
// lib/convertkit.ts
const CK_API = 'https://api.convertkit.com/v3'
const CK_SECRET = process.env.CONVERTKIT_API_SECRET!

export async function addSubscriber(email: string, firstName: string, tags: number[]) {
  const response = await fetch(`${CK_API}/forms/{FORM_ID}/subscribe`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      api_secret: CK_SECRET,
      email,
      first_name: firstName,
      tags,
    }),
  })
  return response.json()
}
```

## A/B 테스트 규칙
- 한 번에 **하나의 변수만** 테스트
- 최소 **100명** 이상 표본
- **48시간** 이상 운영 후 판단
- 승자를 기본값으로 설정 후 다음 변수 테스트
