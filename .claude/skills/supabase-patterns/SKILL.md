---
name: supabase-patterns
description: Supabase 활용 패턴. Auth, RLS, Storage, Edge Functions, Realtime 구현 가이드. Next.js SSR/CSR 연동.
trigger: supabase, 데이터베이스, DB, 인증, auth, RLS, 스토리지
---

# Supabase 패턴 스킬

## 트리거 조건
- "Supabase", "DB", "인증", "RLS" 키워드 감지 시
- 데이터베이스 설계, 사용자 관리 요청 시

## 클라이언트 초기화 패턴

### 서버 컴포넌트용
```typescript
// lib/supabase/server.ts
import { createServerClient } from '@supabase/ssr'
import { cookies } from 'next/headers'

export async function createClient() {
  const cookieStore = await cookies()
  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll: () => cookieStore.getAll(),
        setAll: (cookiesToSet) => {
          cookiesToSet.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options))
        },
      },
    }
  )
}
```

### 클라이언트 컴포넌트용
```typescript
// lib/supabase/client.ts
import { createBrowserClient } from '@supabase/ssr'

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
}
```

## RLS 정책 패턴

### 기본 CRUD 정책
```sql
-- 사용자 자신의 데이터만 접근
CREATE POLICY "자기 데이터 조회" ON public.profiles
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "자기 데이터 수정" ON public.profiles
  FOR UPDATE USING (auth.uid() = user_id);

-- 인증된 사용자만 생성
CREATE POLICY "인증 사용자 생성" ON public.posts
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- 공개 읽기, 작성자만 수정
CREATE POLICY "공개 조회" ON public.posts
  FOR SELECT USING (true);

CREATE POLICY "작성자만 수정" ON public.posts
  FOR UPDATE USING (auth.uid() = author_id);
```

## 테이블 설계 패턴 (교육 서비스용)

```sql
-- 수강생
CREATE TABLE students (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users NOT NULL,
  name TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  cohort TEXT,
  enrolled_at TIMESTAMPTZ DEFAULT now(),
  status TEXT DEFAULT 'active' CHECK (status IN ('active','completed','paused'))
);

-- 강의
CREATE TABLE courses (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  price INTEGER NOT NULL,
  max_students INTEGER DEFAULT 20,
  start_date DATE,
  end_date DATE,
  is_active BOOLEAN DEFAULT true
);

-- 수강 신청
CREATE TABLE enrollments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  student_id UUID REFERENCES students NOT NULL,
  course_id UUID REFERENCES courses NOT NULL,
  paid_amount INTEGER,
  payment_status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(student_id, course_id)
);
```

## 마이그레이션 규칙
- 파일 위치: `supabase/migrations/`
- 파일명: `YYYYMMDDHHMMSS_설명.sql`
- 직접 DB 수정 절대 금지 → 마이그레이션 파일만 사용
- 롤백 SQL 항상 주석으로 포함

## 주의사항
- `getUser()`로 인증 확인 (세션만으론 불충분)
- `select('*')` 대신 명시적 컬럼 지정
- `.limit()` 없는 쿼리 금지 (무한 결과 방지)
- Service Role Key는 서버 사이드에서만 사용
