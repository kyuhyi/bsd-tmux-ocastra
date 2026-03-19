# AGENTS.md — BSD 바이브코딩 에이전트 팀 가이드

> 100줄 이내의 목차 형태. 상세 지침은 docs/ 하위 문서 참조.
> "1,000페이지짜리 매뉴얼 대신 지도를 주어라"

## 에이전트 팀 구성

| 에이전트 | 역할 | 사용 시점 | 모델 |
|----------|------|-----------|------|
| planner | 기능 기획 및 구현 계획 | 새 기능, 리팩토링, 복잡한 변경 | opus |
| code-reviewer | 코드 품질 리뷰 | 코드 작성/수정 후 | sonnet |
| landing-builder | 랜딩페이지 제작 | 전환율 높은 LP 필요 시 | opus |
| n8n-architect | n8n 워크플로 설계 | 자동화 파이프라인 구축 | opus |
| funnel-designer | 퍼널 마케팅 설계 | 리드→전환 퍼널 설계 | opus |
| content-creator | 콘텐츠 생성/변환 | 원소스 멀티유즈 | sonnet |
| shorts-producer | 유튜브 쇼츠 자동화 | AI 쇼츠 생성 파이프라인 | sonnet |
| kakao-integrator | 카카오톡 연동 전문가 | 알림톡/친구톡 연동 | sonnet |
| debug-resolver | 빌드/런타임 에러 해결 | 에러 발생 시 | sonnet |
| seo-optimizer | SEO 및 메타 최적화 | 배포 전 SEO 점검 | haiku |

## 자동 위임 규칙

에이전트는 사용자 요청 없이도 상황에 따라 **자동으로** 위임합니다:

```
사용자: "회원가입 기능 만들어줘"
→ planner (구현 계획)
→ 코드 작성
→ code-reviewer (자동 리뷰)

사용자: "n8n으로 인스타 자동 포스팅"
→ n8n-architect (워크플로 설계)
→ 워크플로 JSON 생성
→ 테스트 검증

사용자: "강의 랜딩페이지 만들어줘"
→ funnel-designer (퍼널 구조 설계)
→ landing-builder (페이지 구현)
→ seo-optimizer (메타태그 최적화)
```

## 스킬 디렉토리

| 스킬 | 위치 | 자동 트리거 |
|------|------|-------------|
| n8n 자동화 | `skills/n8n-automation/` | n8n, 워크플로, 자동화 언급 시 |
| 랜딩페이지 | `skills/landing-page/` | LP, 랜딩, 전환 언급 시 |
| 퍼널 마케팅 | `skills/funnel-marketing/` | 퍼널, 리드, 전환율 언급 시 |
| 유튜브 쇼츠 | `skills/youtube-shorts/` | 쇼츠, 숏폼, 유튜브 언급 시 |
| 카카오 연동 | `skills/kakao-integration/` | 카카오, 알림톡, Solapi 언급 시 |
| Supabase | `skills/supabase-patterns/` | DB, 인증, RLS 언급 시 |
| Next.js | `skills/nextjs-vibecoding/` | 페이지, 컴포넌트, 라우팅 언급 시 |
| 콘텐츠 변환 | `skills/content-repurpose/` | 원소스 멀티유즈 언급 시 |
| 이메일 자동화 | `skills/email-automation/` | 이메일, 시퀀스, 뉴스레터 언급 시 |
| MCP 설정 | `skills/mcp-setup/` | MCP, 서버 연동 언급 시 |

## 슬래시 명령어

| 명령어 | 설명 |
|--------|------|
| `/plan` | 기능 구현 계획 수립 |
| `/build` | 빌드 에러 수정 |
| `/review` | 코드 리뷰 실행 |
| `/n8n` | n8n 워크플로 생성/수정 |
| `/landing` | 랜딩페이지 생성 |
| `/funnel` | 퍼널 구조 설계 |
| `/shorts` | 유튜브 쇼츠 파이프라인 |
| `/deploy` | 배포 체크리스트 실행 |
| `/learn` | 현재 세션에서 패턴 추출 |
| `/compact` | 컨텍스트 정리 (논리적 구간에서) |

## 보안 경계

- 에이전트는 `.env` 파일을 **절대 읽거나 출력하지 않음**
- API 키가 포함된 코드는 커밋 전 **자동 차단**
- 외부 서비스 호출 시 **환경변수만** 사용
- Supabase Service Role Key는 **서버 사이드에서만** 사용
