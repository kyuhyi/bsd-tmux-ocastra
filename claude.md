# Claude Code 팀 에이전트 tmux 설정 가이드

> BSD 바이브코딩 교육센터 - 실전 설정 가이드

---

## ⚠️ 팀 에이전트 필수 규칙 (반드시 준수)

### 규칙 1: 리더는 반드시 tmux 창을 분할해서 팀을 생성한다

팀 에이전트 요청 시 리더는 **tmux로 창을 분할**하여 오른쪽에 프론트엔드, 백엔드, 검수자(QA) pane을 생성해야 한다.  
각 pane의 **색상은 반드시 다르게** 설정한다.

```
┌─────────────┬──────────────┐
│             │ @frontend-dev│  ← 초록색
│  Leader     ├──────────────┤
│  (좌측)     │ @backend-dev │  ← 파란색
│             ├──────────────┤
│             │ @qa-engineer │  ← 노란색
└─────────────┴──────────────┘
```

tmux 분할 명령:

```bash
# 오른쪽을 3등분 (수평 분할)
tmux split-window -h          # 좌우 분할
tmux select-pane -t 1
tmux split-window -v          # 우측 상하 분할
tmux select-pane -t 2
tmux split-window -v          # 우측 다시 상하 분할
```

### 규칙 2: tmux 마우스 활성화 필수

`~/.tmux.conf`에 반드시 포함:

```bash
set -g mouse on
```

### 규칙 3: 리더는 절대 혼자 한 창에서 개발하지 않는다

- 리더 역할: **오직 위임(Delegate)과 조율**
- 실제 코드 작성: 프론트엔드/백엔드/QA 에이전트가 각자 pane에서 수행
- 리더가 직접 코드를 작성하는 것은 **금지**

### 규칙 4: 모델 비율 확인 후 병렬 개발

팀 생성 전 반드시 Claude Code 모델 사용 비율 확인:

```
리더:    claude-opus-4-5    → 15% (Delegate Mode - 지시만)
팀원:    claude-sonnet-4-5  → 85% (실제 구현 - 병렬 실행)
```

팀 생성 프롬프트 예시:

```
Todo 앱을 3명의 팀으로 병렬 개발해줘.

리더: Opus (15%) - Delegate Mode, 지시 전달만
팀원 (Sonnet 85%, 병렬 실행):
  @frontend-dev - 프론트엔드 담당
  @backend-dev  - 백엔드 담당
  @qa-engineer  - 검수 담당
```

---

## 🛠️ 3가지 필수 설정

### 1. `~/.claude/settings.json`

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",
    "TERM": "xterm-256color",
    "COLORTERM": "truecolor",
    "FORCE_COLOR": "1"
  },
  "teammateMode": "tmux",
  "defaultModel": "claude-sonnet-4-5-20250929"
}
```

### 2. `~/.tmux.conf`

```bash
# 256 컬러 지원
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm-256color:Tc"

# 마우스 활성화 (필수)
set -g mouse on

# 상태바
set -g status-bg colour235
set -g status-fg colour136

# Pane 경계선
set -g pane-border-style fg=colour238
set -g pane-active-border-style fg=colour51

# 히스토리
set -g history-limit 10000
```

설정 적용:

```bash
tmux source-file ~/.tmux.conf
# 또는
tmux kill-server
```

### 3. 터미널 256 컬러 확인

```bash
echo $TERM       # xterm-256color 이어야 함
tput colors      # 256 이어야 함
```

256이 아닌 경우:

```bash
export TERM=xterm-256color
echo 'export TERM=xterm-256color' >> ~/.zshrc
source ~/.zshrc
```

---

## 🚀 실행 순서

```bash
# 1. 설정 확인
cat ~/.claude/settings.json

# 2. tmux 컬러 모드 실행
tmux -2          # 일반 터미널
# 또는
tmux -CC         # macOS iTerm2

# 3. Claude Code 시작
claude

# 4. 팀 생성 요청 (규칙 1~4 자동 적용)
```

---

## 🎨 Pane 색상 설정 (에이전트별 구분)

`~/.tmux.conf`에 추가:

```bash
# 각 pane에 색상 적용 (pane-id 기준)
# 프론트엔드: 초록
set-hook -g after-split-window 'select-pane -P fg=colour46'

# 에이전트 색상 규칙
# @frontend-dev → 초록 (colour46)
# @backend-dev  → 파란 (colour39)
# @qa-engineer  → 노란 (colour226)
```

WSL2 / Windows Terminal 추가 설정:

```bash
export TERM=xterm-256color
echo 'export TERM=xterm-256color' >> ~/.zshrc
```

---

## ✅ 원클릭 자동 설정 스크립트

```bash
#!/bin/bash
# 저장: ~/setup-claude-team.sh
# 실행: chmod +x ~/setup-claude-team.sh && ~/setup-claude-team.sh

mkdir -p ~/.claude

cat > ~/.claude/settings.json << 'EOF'
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",
    "TERM": "xterm-256color",
    "COLORTERM": "truecolor",
    "FORCE_COLOR": "1"
  },
  "teammateMode": "tmux",
  "defaultModel": "claude-sonnet-4-5-20250929"
}
EOF

cat > ~/.tmux.conf << 'EOF'
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm-256color:Tc"
set -g mouse on
set -g status-bg colour235
set -g status-fg colour136
set -g pane-border-style fg=colour238
set -g pane-active-border-style fg=colour51
set -g history-limit 10000
EOF

echo "✅ 설정 완료!"
echo "→ tmux kill-server && tmux -2 && claude"
```

---

**작성**: BSD 바이브코딩 교육센터 | **버전**: 2.0 | **업데이트**: 2026-03-03
