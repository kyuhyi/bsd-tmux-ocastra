---
description: 배포 전 체크리스트를 실행합니다.
---

# /deploy 명령어

배포 전 필수 점검 사항을 자동으로 확인합니다.

## 체크리스트
1. `npm run build` 성공 여부
2. 시크릿 노출 검사 (API 키, 비밀번호)
3. 환경변수 설정 확인
4. Supabase RLS 정책 확인
5. SEO 메타태그 확인
6. 모바일 반응형 확인
7. .env.example 업데이트 여부

## 사용법
```
/deploy
/deploy --skip-tests
```
