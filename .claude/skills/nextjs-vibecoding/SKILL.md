---
name: nextjs-vibecoding
description: Next.js 15 App Router 바이브코딩 패턴. 서버/클라이언트 컴포넌트, Server Actions, 미들웨어, SEO 최적화.
trigger: nextjs, next, 페이지, 컴포넌트, 라우팅, app router
---

# Next.js 바이브코딩 스킬

## 트리거 조건
- "Next.js", "페이지", "컴포넌트", "라우팅" 키워드 감지 시
- 웹사이트 구축, 프론트엔드 개발 요청 시

## 핵심 원칙
1. 서버 컴포넌트가 기본 (SEO + 성능)
2. 클라이언트 컴포넌트는 인터랙션이 필요할 때만
3. Server Actions로 폼 처리 (API 라우트 최소화)
4. 한국어 SEO 메타태그 필수

## 파일 구조
```
src/
├── app/
│   ├── layout.tsx          # 루트 레이아웃 (폰트, 메타)
│   ├── page.tsx            # 홈페이지
│   ├── globals.css         # TailwindCSS
│   ├── (marketing)/        # 마케팅 페이지 그룹
│   │   ├── page.tsx        # 랜딩페이지
│   │   └── pricing/page.tsx
│   ├── (dashboard)/        # 대시보드 (인증 필요)
│   │   ├── layout.tsx      # 인증 체크 레이아웃
│   │   └── page.tsx
│   └── api/
│       └── webhooks/       # 외부 웹훅만 API 라우트
├── components/
│   ├── ui/                 # 기본 UI (Button, Card 등)
│   ├── forms/              # 폼 컴포넌트
│   └── sections/           # 페이지 섹션
├── lib/
│   ├── supabase/           # Supabase 클라이언트
│   ├── actions/            # Server Actions
│   └── utils.ts            # 유틸리티
└── types/                  # 타입 정의
```

## Server Action 패턴
```typescript
// lib/actions/contact.ts
'use server'

import { z } from 'zod'
import { createClient } from '@/lib/supabase/server'

const ContactSchema = z.object({
  name: z.string().min(2, '이름을 입력해주세요'),
  phone: z.string().regex(/^01[016789]\d{7,8}$/, '올바른 전화번호를 입력해주세요'),
  message: z.string().optional(),
})

export async function submitContact(formData: FormData) {
  const parsed = ContactSchema.safeParse(Object.fromEntries(formData))
  if (!parsed.success) {
    return { success: false, error: parsed.error.flatten().fieldErrors }
  }

  const supabase = await createClient()
  const { error } = await supabase
    .from('contacts')
    .insert(parsed.data)

  if (error) {
    return { success: false, error: '저장 중 오류가 발생했습니다' }
  }

  return { success: true, data: '문의가 접수되었습니다' }
}
```

## SEO 메타태그 패턴
```typescript
// app/layout.tsx
import type { Metadata } from 'next'

export const metadata: Metadata = {
  metadataBase: new URL('https://yourdomain.com'),
  title: {
    default: 'BSD 바이브코딩 | 비전공자를 위한 AI 코딩 교육',
    template: '%s | BSD 바이브코딩',
  },
  description: '코딩 몰라도 8일이면 웹사이트를 만듭니다',
  openGraph: {
    type: 'website',
    locale: 'ko_KR',
    siteName: 'BSD 바이브코딩',
  },
  robots: { index: true, follow: true },
  verification: {
    google: 'google-verification-code',
    other: { 'naver-site-verification': 'naver-code' },
  },
}
```

## 미들웨어 (인증 보호)
```typescript
// middleware.ts
import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

export async function middleware(request: NextRequest) {
  const response = NextResponse.next()
  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    { cookies: { /* cookie handlers */ } }
  )
  const { data: { user } } = await supabase.auth.getUser()

  if (!user && request.nextUrl.pathname.startsWith('/dashboard')) {
    return NextResponse.redirect(new URL('/login', request.url))
  }
  return response
}

export const config = {
  matcher: ['/dashboard/:path*'],
}
```

## 배포 체크리스트
```
□ npm run build 성공 (에러 0)
□ 환경변수 Vercel에 설정 완료
□ OG 이미지 정적 생성 확인
□ 모바일 반응형 테스트
□ 카카오/네이버 공유 미리보기 확인
□ Google Analytics / Meta 픽셀 설치
□ sitemap.xml, robots.txt 생성
```
