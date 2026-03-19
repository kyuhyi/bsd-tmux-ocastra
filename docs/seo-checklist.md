# 한국 SEO 체크리스트

> seo-optimizer 에이전트가 /deploy 명령어 실행 시 참조합니다.

## 기본 SEO

```
□ title 태그: 핵심 키워드 포함, 30-60자
□ meta description: 행동 유도 문구, 80-160자
□ H1 태그: 페이지당 1개만, 핵심 키워드 포함
□ H2-H3 구조: 논리적 계층 구조
□ 이미지 alt 태그: 모든 이미지에 한국어 설명
□ URL 구조: 짧고 의미 있는 슬러그
□ canonical URL 설정
□ sitemap.xml 생성 및 등록
□ robots.txt 설정
```

## 한국 특화 SEO

### 네이버 최적화
```
□ 네이버 서치어드바이저 등록
□ naver-site-verification 메타태그
□ 네이버 웹마스터 도구 sitemap 제출
□ 네이버 블로그/카페 백링크 확보
□ 모바일 최적화 (네이버 모바일 검색 우선)
```

### 카카오 최적화
```
□ OG 이미지: 800x400 이상, 핵심 내용 포함
□ og:title: 카카오톡 공유 시 노출될 제목
□ og:description: 카카오톡 공유 시 노출될 설명
□ og:image: 카카오톡 미리보기 이미지
□ 카카오 디버거로 미리보기 확인
```

### 구글 최적화
```
□ Google Search Console 등록
□ google-site-verification 메타태그
□ 구조화 데이터 (JSON-LD)
□ Core Web Vitals 통과
□ 모바일 친화성 테스트 통과
```

## Next.js SEO 구현

```typescript
// app/layout.tsx
export const metadata: Metadata = {
  metadataBase: new URL('https://yourdomain.com'),
  title: {
    default: '메인 키워드 | 브랜드명',
    template: '%s | 브랜드명',
  },
  description: '80-160자 설명, 핵심 키워드 2-3개 포함',
  openGraph: {
    type: 'website',
    locale: 'ko_KR',
    url: 'https://yourdomain.com',
    siteName: '브랜드명',
    images: [{ url: '/og-image.png', width: 1200, height: 630 }],
  },
  twitter: {
    card: 'summary_large_image',
  },
  robots: { index: true, follow: true },
  verification: {
    google: 'google-verification-code',
    other: { 'naver-site-verification': 'naver-code' },
  },
}
```

## 페이지 속도 최적화
```
□ Lighthouse 점수 90+ (모바일 기준)
□ LCP (Largest Contentful Paint) < 2.5초
□ FID (First Input Delay) < 100ms
□ CLS (Cumulative Layout Shift) < 0.1
□ 이미지: next/image 사용, WebP 형식
□ 폰트: next/font 사용 (FOUT 방지)
□ 번들 사이즈: dynamic import 활용
```
