---
name: mcp-setup
description: MCP(Model Context Protocol) 서버 설정 가이드. Claude Desktop, Claude Code용 MCP 서버 구성 및 연동.
trigger: mcp, 서버 연동, claude desktop, 도구 연결
---

# MCP 설정 스킬

## BSD 바이브코딩 추천 MCP 서버

### 필수 MCP 서버
| 서버 | 용도 | 우선순위 |
|------|------|---------|
| Context7 | 라이브러리 문서 실시간 조회 | ⭐⭐⭐ |
| Filesystem | 로컬 파일 읽기/쓰기 | ⭐⭐⭐ |
| n8n | n8n 워크플로 관리 | ⭐⭐⭐ |

### 선택 MCP 서버
| 서버 | 용도 | 사용 시점 |
|------|------|----------|
| Figma | 디자인 파일 연동 | 디자인→코드 변환 |
| Slack | 팀 커뮤니케이션 | 알림/메시지 |
| Notion | 문서/DB 관리 | 콘텐츠 관리 |
| Google Drive | 파일 공유 | 문서 협업 |
| Supabase | DB 직접 관리 | DB 작업 |

## 설정 파일 위치
```
~/.claude.json                    # Claude Desktop MCP 설정
~/.claude/settings.json           # Claude Code 전역 설정
프로젝트/.claude/settings.json     # 프로젝트별 설정
```

## claude.json MCP 설정 예시
```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-filesystem"],
      "env": {
        "ALLOWED_DIRS": "/Users/사용자명/projects"
      }
    },
    "n8n": {
      "url": "https://bsd.ai.kr/mcp-server/http"
    }
  }
}
```

## 컨텍스트 윈도우 관리 주의사항
```
⚠️ MCP 서버가 많을수록 컨텍스트 윈도우가 줄어듭니다!

200K 토큰 중:
- MCP 10개 = 약 130K 사용 가능
- MCP 20개 = 약 70K 사용 가능 (위험!)

권장: 프로젝트당 MCP 10개 이내, 도구 80개 이내

미사용 MCP 비활성화:
프로젝트/.claude/settings.json에서
"disabledMcpServers": ["supabase", "slack"]
```

## 프로젝트별 MCP 최적화 패턴
```
# 웹사이트 개발 프로젝트
활성화: filesystem, context7, supabase
비활성화: slack, notion, n8n

# n8n 자동화 프로젝트
활성화: n8n, context7, google-drive
비활성화: figma, supabase

# 콘텐츠 제작 프로젝트
활성화: notion, google-drive, slack
비활성화: filesystem, supabase
```
