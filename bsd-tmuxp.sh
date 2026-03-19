#!/bin/bash
# ============================================
# BSD Tmux 자동 분할 세팅 v7 (tmuxp 버전)
# Claude Team Agent 최적화 모드
# ============================================
# CLAUDE.md.bak 필수 규칙 적용:
#   규칙 1: tmux 5분할 (리더 + 기획자/프론트엔드/백엔드/검수자)
#   규칙 2: 네이티브 팀 기능 사용 금지 (CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=0)
#   규칙 3: tmux 마우스 및 변수 조작 방지 (~/.tmux.conf 자동 설정)
# ============================================

# Homebrew PATH 보장 (macOS)
if [ -d "/opt/homebrew/bin" ]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi
if [ -d "/usr/local/bin" ]; then
  export PATH="/usr/local/bin:$PATH"
fi

SESSION="bsd"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="${1:-$PWD}"

# ===========================================
# 필수 도구 확인
# ===========================================
for cmd in tmux tmuxp claude; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "❌ 오류: '$cmd'이(가) 설치되어 있지 않습니다."
    echo "   설치 방법:"
    case "$cmd" in
      tmux)   echo "   brew install tmux" ;;
      tmuxp)  echo "   pip install tmuxp" ;;
      claude) echo "   npm install -g @anthropic-ai/claude-code" ;;
    esac
    exit 1
  fi
done

# ===========================================
# 규칙 3: ~/.tmux.conf 필수 설정 자동 적용
# ===========================================
TMUX_CONF="$HOME/.tmux.conf"
REQUIRED_SETTINGS=(
  "set -g mouse on"
  "set -g pane-border-status top"
  'set -g pane-border-format " #{@pane_name} "'
  "set -g allow-rename off"
  "setw -g automatic-rename off"
)

touch "$TMUX_CONF"
for setting in "${REQUIRED_SETTINGS[@]}"; do
  if ! grep -qF "$setting" "$TMUX_CONF" 2>/dev/null; then
    echo "$setting" >> "$TMUX_CONF"
    echo "  [+] tmux.conf에 추가: $setting"
  fi
done

# 터미널 컬러 지원 강제 설정
export TERM=xterm-256color
export COLORTERM=truecolor
export FORCE_COLOR=1

# ===========================================
# 기존 세션 및 팀 세션 정보 초기화 (충돌 방지)
# ===========================================
tmux kill-session -t "$SESSION" 2>/dev/null
rm -rf ~/.claude/teams/* 2>/dev/null

# ===========================================
# 규칙 1: tmuxp로 5분할 세션 생성
# ===========================================
cd "$WORK_DIR" || exit 1
echo ""
echo "🚀 BSD Claude Team Agent 시작!"
echo "📁 작업 폴더: $WORK_DIR"
echo ""

tmuxp load -d "$SCRIPT_DIR/bsd-tmux.yaml"

# ===========================================
# tmuxp로 처리 불가한 커스텀 설정 후처리
# ===========================================

# 규칙 2: 패인 타이틀 설정 (@pane_name으로 claude 덮어쓰기 방지)
tmux set-option -pt "$SESSION:1.1" @pane_name "👑 총괄 리더 | Leader"
tmux set-option -pt "$SESSION:1.2" @pane_name "📋 기획자 | Planner"
tmux set-option -pt "$SESSION:1.3" @pane_name "🎨 프론트엔드 | Frontend"
tmux set-option -pt "$SESSION:1.4" @pane_name "⚙️  백엔드 | Backend"
tmux set-option -pt "$SESSION:1.5" @pane_name "🔍 검수자 | QA"

# 패인 색상 설정
tmux select-pane -t "$SESSION:1.1" -P "fg=colour15,bg=colour234"
tmux select-pane -t "$SESSION:1.2" -P "fg=colour226,bg=colour234"
tmux select-pane -t "$SESSION:1.3" -P "fg=colour46,bg=colour234"
tmux select-pane -t "$SESSION:1.4" -P "fg=colour39,bg=colour234"
tmux select-pane -t "$SESSION:1.5" -P "fg=colour196,bg=colour234"

# 리더 패인 포커스
tmux select-pane -t "$SESSION:1.1"

# 세션 연결
tmux attach-session -t "$SESSION"
