# 자주 발생하는 에러 및 해결법

> debug-resolver 에이전트가 참조합니다. 새로운 해결법 발견 시 자동 추가.

## Next.js 에러

### 하이드레이션 불일치 (Hydration Mismatch)
```
에러: Text content does not match server-rendered HTML
원인: 서버/클라이언트 렌더링 결과가 다름
해결:
  1. 'use client' 필요한 컴포넌트에 정확히 표기
  2. typeof window !== 'undefined' 체크 사용
  3. dynamic import with { ssr: false } 사용
  4. suppressHydrationWarning 최후의 수단으로만
```

### Module not found
```
에러: Module not found: Can't resolve '@/lib/...'
해결:
  1. tsconfig.json의 paths 확인
  2. import 경로 대소문자 확인 (Mac은 무시, Linux는 구분)
  3. node_modules 삭제 후 재설치
```

### Server Component에서 Hook 사용
```
에러: You're importing a component that needs useState/useEffect
해결: 파일 최상단에 'use client' 추가
주의: 불필요한 'use client' 남발 금지 (SEO 영향)
```

## Supabase 에러

### RLS 정책 위반
```
에러: new row violates row-level security policy
해결:
  1. 해당 테이블의 RLS 정책 확인
  2. auth.uid() 조건 정확한지 확인
  3. INSERT의 경우 WITH CHECK 절 확인
  4. Service Role Key가 필요한 작업인지 확인
```

### 인증 토큰 만료
```
에러: JWT expired / Invalid refresh token
해결:
  1. middleware.ts에서 토큰 갱신 로직 확인
  2. createServerClient의 cookie 핸들러 확인
  3. Supabase Dashboard에서 JWT 만료 시간 확인
```

## n8n 에러

### Webhook 수신 안됨
```
원인: Railway 슬립 모드, URL 변경, 인증 문제
해결:
  1. n8n 인스턴스 활성 상태 확인
  2. Webhook URL 올바른지 확인 (프로덕션/테스트)
  3. 방화벽/CORS 설정 확인
  4. n8n 로그에서 에러 확인
```

### 크레덴셜 오류
```
에러: Credentials not found / Invalid credentials
해결:
  1. n8n 크레덴셜 매니저에서 재설정
  2. OAuth 토큰 만료 → 재인증
  3. API 키 변경 여부 확인
```

## Vercel 배포 에러

### 빌드 실패
```
해결 순서:
  1. 로컬에서 'npm run build' 먼저 확인
  2. 환경변수 Vercel Dashboard에 설정 확인
  3. Node.js 버전 확인 (Vercel Settings)
  4. 빌드 로그에서 첫 번째 에러 집중
```

### 환경변수 누락
```
증상: 로컬에서 작동하지만 배포 후 실패
해결:
  1. Vercel Dashboard → Settings → Environment Variables
  2. NEXT_PUBLIC_ 접두사 필요 여부 확인
  3. Production/Preview/Development 환경 구분
```

## Solapi/카카오 에러

### 알림톡 발송 실패
```
원인별 해결:
  - 템플릿 미승인 → 카카오 비즈니스 채널에서 승인 확인
  - 발신번호 미등록 → 통신사 사전등록 필요
  - 변수 불일치 → 템플릿 변수명과 API 파라미터 일치 확인
  - 수신거부 → opt-out 처리 로직 구현
```
