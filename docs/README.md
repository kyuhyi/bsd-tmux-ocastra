# docs/ — Progressive Disclosure 가이드

> AGENTS.md에서 "상세 내용은 docs/ 참조"로 연결되는 심화 문서입니다.
> 에이전트가 필요할 때만 이 폴더의 문서를 참조합니다.

## 문서 목록

| 문서 | 용도 |
|------|------|
| `nextjs-patterns.md` | Next.js 15 App Router 심화 패턴 |
| `supabase-advanced.md` | RLS 고급 정책, Edge Functions, Realtime |
| `n8n-recipes.md` | 검증된 n8n 워크플로 레시피 모음 |
| `meta-ads-playbook.md` | Meta 광고 세팅 및 최적화 플레이북 |
| `seo-checklist.md` | 한국 SEO 체크리스트 (네이버 + 구글) |
| `deployment-guide.md` | Vercel/Railway 배포 상세 가이드 |
| `troubleshooting.md` | 자주 발생하는 에러 및 해결법 DB |

## Progressive Disclosure 원칙

```
Level 0: CLAUDE.md (항상 로드, 150~500줄)
   ↓ 필요 시
Level 1: AGENTS.md (에이전트/스킬 목차, ~100줄)
   ↓ 필요 시
Level 2: skills/*/SKILL.md (특정 스킬 상세)
   ↓ 필요 시
Level 3: docs/*.md (심화 레퍼런스)
```

이 구조를 통해 컨텍스트 윈도우를 효율적으로 사용합니다.
불필요한 문서를 미리 로드하지 않고, 작업에 필요한 문서만 점진적으로 참조합니다.
