---
name: youtube-shorts
description: AI 유튜브 쇼츠 자동 생성 파이프라인. 스크립트 생성→TTS→아바타→영상 합성→업로드까지 전체 자동화.
trigger: 쇼츠, 숏폼, 유튜브, shorts, 영상 자동화
---

# 유튜브 쇼츠 자동화 스킬

## 트리거 조건
- "쇼츠", "숏폼", "유튜브 영상" 키워드 감지 시
- AI 영상, 자동 생성, 자동 업로드 요청 시

## 쇼츠 자동 생성 파이프라인

### 전체 흐름
```
[주제/키워드 입력]
    ↓
[1. 스크립트 생성] ← OpenAI GPT-4o
    ↓
[2. 음성 생성] ← ElevenLabs TTS
    ↓
[3. 아바타 생성] ← D-ID / HeyGen
    ↓
[4. 영상 합성] ← n8n-nodes-mediafx (FFmpeg)
    ↓  ├─ 자막 오버레이
    ↓  ├─ BGM 믹싱
    ↓  └─ 인트로/아웃트로
    ↓
[5. 업로드] ← YouTube API
    ↓
[6. 멀티플랫폼] ← Instagram Reels, TikTok
```

### 스크립트 생성 프롬프트 패턴
```
당신은 한국의 유명 바이브코딩 교육자입니다.
다음 주제에 대해 60초 쇼츠 스크립트를 작성하세요.

주제: {topic}
대상: 코딩 비전공 1인 창업가

구조:
- 훅 (0-3초): 시청자를 멈추게 하는 질문/충격적 사실
- 문제 (3-10초): 공감할 수 있는 고통점
- 해결 (10-40초): 바이브코딩으로 해결하는 과정 시연
- CTA (40-60초): 구독/댓글/링크 유도

톤: 친근하고 에너지 넘치는 한국어
글자수: 300자 이내 (60초 분량)
```

### n8n 워크플로 구성
```json
{
  "nodes": [
    { "name": "트리거", "type": "webhook/schedule" },
    { "name": "스크립트 생성", "type": "openai" },
    { "name": "음성 변환", "type": "http (ElevenLabs)" },
    { "name": "아바타 생성", "type": "http (D-ID)" },
    { "name": "영상 합성", "type": "mediafx" },
    { "name": "자막 추가", "type": "mediafx" },
    { "name": "업로드", "type": "http (YouTube API)" },
    { "name": "완료 알림", "type": "slack/telegram" }
  ]
}
```

### FFmpeg 명령어 패턴 (mediafx)
```bash
# 자막 오버레이
ffmpeg -i input.mp4 -vf "subtitles=subs.srt:force_style='FontSize=24,PrimaryColour=&HFFFFFF'" output.mp4

# BGM 믹싱 (BGM 볼륨 20%)
ffmpeg -i video.mp4 -i bgm.mp3 -filter_complex "[1:a]volume=0.2[bgm];[0:a][bgm]amix=inputs=2" output.mp4

# 세로 영상 (9:16) 크롭
ffmpeg -i input.mp4 -vf "crop=ih*9/16:ih" -c:a copy output.mp4
```

### 영상 사양
```
해상도: 1080x1920 (9:16 세로)
길이: 30~60초
프레임: 30fps
코덱: H.264
오디오: AAC 128kbps
자막: 한국어 + 영어 (선택)
```

### 콘텐츠 카테고리 (자동 순환)
```
월: 바이브코딩 팁
화: 수강생 성공 사례
수: AI 도구 소개
목: n8n 자동화 레시피
금: 마케팅/퍼널 팁
토: 비하인드/일상
일: 주간 정리/Q&A
```
