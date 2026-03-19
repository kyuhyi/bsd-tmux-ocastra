#!/bin/bash
# ============================================
# BSD Team Agent — 더블클릭 실행 파일
# Finder에서 더블클릭하면 터미널이 열리고 자동 실행됩니다
# ============================================

# Homebrew PATH 보장
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# 스크립트 위치로 이동 (더블클릭 시에도 정확한 경로 보장)
cd "$(dirname "$0")" || exit 1

# bsd-tmuxp.sh 실행
exec bash ./bsd-tmuxp.sh
