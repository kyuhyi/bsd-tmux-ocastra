#!/bin/bash
# ============================================
# BSD Tmux 자동 분할 세팅 v5
# Claude Team Agent 최적화 모드
# ============================================

SESSION="bsd"
# 스크립트를 실행한 현재 디렉토리를 작업 공간으로 설정 (수강생 범용 지원)
WORK_DIR="$PWD"

# 환경 변수 (팀 모드 및 컬러 강제)
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
export TERM=xterm-256color
export COLORTERM=truecolor
export FORCE_COLOR=1

# 기존 세션 및 팀 세션 정보 초기화 (충돌 방지)
tmux kill-session -t $SESSION 2>/dev/null
rm -rf ~/.claude/teams/* 2>/dev/null

# ===========================================
# 새 세션 생성 (리더 패인 1.1)
# ===========================================
tmux new-session -d -s $SESSION -x 220 -y 55

# ===========================================
# 레이아웃 분할
# ===========================================
# 1. 좌우 분할
tmux split-window -h -t "$SESSION:1.1"

# 2. 우측 4분할
tmux split-window -v -t "$SESSION:1.2"
tmux split-window -v -t "$SESSION:1.3"
tmux split-window -v -t "$SESSION:1.4"

# 3. 크기 조정 (리더 패인 넓게)
tmux resize-pane -t "$SESSION:1.1" -x 110

# ===========================================
# 패인 타이틀 설정 (claude 덮어쓰기 방지)
# ===========================================
tmux set-option -pt "$SESSION:1.1" @pane_name "👑 총괄 리더 | Leader"
tmux set-option -pt "$SESSION:1.2" @pane_name "📋 기획자 | Planner"
tmux set-option -pt "$SESSION:1.3" @pane_name "🎨 프론트엔드 | Frontend"
tmux set-option -pt "$SESSION:1.4" @pane_name "⚙️  백엔드 | Backend"
tmux set-option -pt "$SESSION:1.5" @pane_name "🔍 검수자 | QA"

# ===========================================
# 패인 색상 설정
# ===========================================
tmux select-pane -t "$SESSION:1.1" -P "fg=colour15,bg=colour234"
tmux select-pane -t "$SESSION:1.2" -P "fg=colour226,bg=colour234"
tmux select-pane -t "$SESSION:1.3" -P "fg=colour46,bg=colour234"
tmux select-pane -t "$SESSION:1.4" -P "fg=colour39,bg=colour234"
tmux select-pane -t "$SESSION:1.5" -P "fg=colour196,bg=colour234"

# ===========================================
# 패인별 초기화 (리더가 인식할 수 있도록 대기 메시지 출력)
# ===========================================
tmux send-keys -t "$SESSION:1.2" "cd $WORK_DIR && clear && echo '=== 📋 기획자 (Planner) 대기 중 ===' && echo '리더는 이 패인에 [ tmux send-keys -t bsd:1.2 claude C-m ] 명령으로 나를 소환해주세요.'" C-m
tmux send-keys -t "$SESSION:1.3" "cd $WORK_DIR && clear && echo '=== 🎨 프론트엔드 (Frontend) 대기 중 ===' && echo '리더는 이 패인에 [ tmux send-keys -t bsd:1.3 claude C-m ] 명령으로 나를 소환해주세요.'" C-m
tmux send-keys -t "$SESSION:1.4" "cd $WORK_DIR && clear && echo '=== ⚙️ 백엔드 (Backend) 대기 중 ===' && echo '리더는 이 패인에 [ tmux send-keys -t bsd:1.4 claude C-m ] 명령으로 나를 소환해주세요.'" C-m
tmux send-keys -t "$SESSION:1.5" "cd $WORK_DIR && clear && echo '=== 🔍 검수자 (QA) 대기 중 ===' && echo '리더는 이 패인에 [ tmux send-keys -t bsd:1.5 claude C-m ] 명령으로 나를 소환해주세요.'" C-m

# ===========================================
# 리더 패인: 인지 강화 및 실행
# ===========================================
tmux select-pane -t "$SESSION:1.1"

# 화면 정리 및 시작 메시지
tmux send-keys -t "$SESSION:1.1" "cd $WORK_DIR" C-m
tmux send-keys -t "$SESSION:1.1" "clear" C-m
tmux send-keys -t "$SESSION:1.1" "echo '------------------------------------------------'" C-m
tmux send-keys -t "$SESSION:1.1" "echo '🚀 BSD Claude Team Agent Mode Activated'" C-m
tmux send-keys -t "$SESSION:1.1" "echo '우측 패인: 2=기획자, 3=프론트엔드, 4=백엔드, 5=검수자'" C-m
tmux send-keys -t "$SESSION:1.1" "echo '💡 팁: 번거롭게 명령어를 칠 필요 없이, 그냥 \"기획자 프론트엔드 소환해줘\" 라고만 말해도 알아서 우측 화면에 띄웁니다!'" C-m
tmux send-keys -t "$SESSION:1.1" "echo '------------------------------------------------'" C-m

# Claude 실행 (네이티브 기능 완전 차단, 오직 독립 실행)
tmux send-keys -t "$SESSION:1.1" "export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=0 && claude" C-m

# 세션 연결
tmux attach-session -t $SESSION
