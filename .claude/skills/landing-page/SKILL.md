---
name: landing-page
description: 전환율 높은 랜딩페이지 제작. 카피라이팅, 디자인, 기술 구현을 한 번에 처리. Next.js + TailwindCSS + Supabase.
trigger: 랜딩, LP, 랜딩페이지, 전환, 세일즈페이지
---

# 랜딩페이지 빌더 스킬

## 트리거 조건
- "랜딩페이지", "LP", "세일즈페이지" 키워드 감지 시
- 전환율, CTA, 리드 수집 관련 요청 시

## 랜딩페이지 구조 프레임워크 (퍼널띵 검증 패턴)

### 섹션 구성 순서
```
1. 히어로 섹션 (3초 안에 고객 사로잡기)
   - 헤드라인: 고객의 고통/욕구 직격
   - 서브헤드: 해결책 제시
   - CTA 버튼: 명확한 행동 유도
   - 신뢰 배지: 수강생 수, 후기 수

2. 문제 인식 섹션
   - "이런 고민 있으시죠?"
   - 3~5개 핵심 고통점 나열
   - 공감 → 긴급성 유도

3. 해결책 제시 섹션
   - 바이브코딩이란?
   - 비포/애프터 비교
   - 핵심 차별점 3가지

4. 커리큘럼/혜택 섹션
   - 구체적 제공 내용
   - 날짜별/단계별 상세
   - 보너스 혜택

5. 사회적 증거 섹션
   - 수강생 후기 (실명, 사진)
   - 수치적 성과
   - 미디어 노출

6. 강사 소개 섹션
   - 신뢰성 + 전문성
   - 약력 핵심만

7. 가격/CTA 섹션
   - 가격 앵커링
   - 한정 혜택
   - 환불 보장
   - 최종 CTA

8. FAQ 섹션
   - 구매 장벽 해소
   - 자주 묻는 질문 5~7개
```

## 기술 구현 패턴

### Next.js 랜딩페이지 보일러플레이트
```typescript
// app/page.tsx - 서버 컴포넌트 (SEO 최적화)
export const metadata = {
  title: '바이브코딩 마스터클래스 | BSD',
  description: '비전공자도 8일 만에 웹사이트를 만드는 바이브코딩',
  openGraph: { /* ... */ }
}

// 섹션별 컴포넌트 분리
import { Hero } from '@/components/landing/Hero'
import { Problem } from '@/components/landing/Problem'
import { Solution } from '@/components/landing/Solution'
// ...
```

### 리드 수집 Form → Supabase
```typescript
// lib/actions/lead.ts
'use server'
export async function captureLoad(formData: FormData) {
  const { name, phone, email } = Object.fromEntries(formData)
  // Zod 검증 → Supabase 저장 → Solapi 알림
}
```

### 디자인 시스템 (BSD 브랜드)
```css
/* BSD 바이브코딩 브랜드 컬러 */
--bsd-purple: #7C3AED;      /* 메인 퍼플 */
--bsd-purple-light: #A78BFA; /* 라이트 퍼플 */
--bsd-gradient: linear-gradient(135deg, #7C3AED, #4F46E5);
--bsd-dark: #1E1B4B;         /* 다크 배경 */
--bsd-text: #F8FAFC;         /* 밝은 텍스트 */
```

## 전환율 최적화 체크리스트
```
□ 모바일 퍼스트 반응형 (한국은 모바일 80%+)
□ 페이지 로딩 3초 이내
□ CTA 버튼 화면에 항상 보임 (sticky)
□ 전화번호 클릭 시 바로 전화 연결
□ 카카오톡 상담 버튼 연동
□ 메타 픽셀 / GA4 이벤트 추적 설치
□ OG 이미지 최적화 (카카오/네이버 공유용)
```
