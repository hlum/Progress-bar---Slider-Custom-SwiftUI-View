# CustomSliderView

音楽プレイヤーインターフェースとインタラクティブコントロールをサポートする、カスタマイズ可能でアニメーション対応のSwiftUI用スライダーコンポーネントです。

## 機能

- 🎵 **音楽プレイヤースライダー** - オーディオ/ビデオ進行状況スライダーに最適
- 🎨 **完全カスタマイズ可能** - カラー、高さ、ノブの外観をカスタマイズ
- ✨ **スムーズアニメーション** - スライダーの高さやその他のプロパティをリアルタイムでアニメーション
- 📱 **SwiftUIネイティブ** - 最新のSwiftUIパターンで構築
- 🎯 **精密制御** - ドラッグジェスチャーによる正確な値トラッキング
- 🔧 **柔軟なノブ** - ViewBuilderサポートによるカスタムノブビュー

## インストール

### Swift Package Manager

Xcodeを通じてMusicSliderをプロジェクトに追加：

1. File → Add Package Dependencies
2. リポジトリURLを入力
3. 希望するバージョンを選択

または`Package.swift`に追加：

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/MusicSlider.git", from: "1.0.0")
]
```

## 使い方

### 基本的な実装

```swift
import SwiftUI

struct ContentView: View {
    @State private var sliderValue: Double = 25
    @State private var sliderHeight: CGFloat = 6
    
    var body: some View {
        MusicSlider(
            value: $sliderValue,
            totalValue: 100,
            heightOfSlider: $sliderHeight,
            onEnded: { newValue in
                print("スライダー終了値: \(newValue)")
            }
        )
        .padding()
    }
}
```

### 高度なカスタマイズ

```swift
MusicSlider(
    value: $currentTime,
    totalValue: totalDuration,
    valueIndicatorColor: .blue,
    sliderBackgroundColor: .gray.opacity(0.3),
    heightOfSlider: $sliderHeight,
    knob: {
        Circle()
            .fill(.white)
            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
            .frame(width: 20, height: 20)
    },
    onChange: { value in
        // ドラッグ中に呼び出される
        print("値変更中: \(value)")
    },
    onEnded: { value in
        // ドラッグ終了時に呼び出される
        print("最終値: \(value)")
        seekToTime(value)
    }
)
```

### アニメーション高さの例

スライダーの高さを動的にアニメーションできることが特徴の一つです：

```swift
struct AnimatedMusicSlider: View {
    @State private var value: Double = 10
    @State private var height: CGFloat = 10
    @State private var isInteracting: Bool = false
    
    var body: some View {
        MusicSlider(
            value: $value,
            totalValue: 100,
            valueIndicatorColor: .blue,
            heightOfSlider: $height,
            knob: {
                Circle()
                    .opacity(isInteracting ? 1.0 : 0.000001) // 非インタラクション時にノブを非表示
            },
            onChange: { _ in
                withAnimation(.spring(response: 0.3)) {
                    height = 20 // インタラクション時に拡張
                }
                isInteracting = true
            },
            onEnded: { _ in
                withAnimation(.spring(response: 0.3)) {
                    height = 10 // インタラクション終了時に縮小
                }
                isInteracting = false
            }
        )
        .padding(.horizontal)
    }
}
```

## パラメータ

| パラメータ | 型 | デフォルト | 説明 |
|-----------|------|---------|-------------|
| `value` | `Binding<Double>` | 必須 | 現在のスライダー値 |
| `totalValue` | `Double` | 必須 | スライダーの最大値 |
| `valueIndicatorColor` | `Color` | `.blue` | 進行状況インジケーターの色 |
| `sliderBackgroundColor` | `Color` | `.gray.opacity(0.3)` | スライダートラックの背景色 |
| `heightOfSlider` | `Binding<CGFloat>` | `.constant(6)` | **アニメーション可能**なスライダーの高さ |
| `knob` | `() -> KnobView` | デフォルトの円 | カスタムノブビュー |
| `onChange` | `((Double) -> Void)?` | `nil` | 値変更中に呼び出される |
| `onEnded` | `(Double) -> Void` | 必須 | インタラクション終了時に呼び出される |

## アニメーションのコツ

### 高さアニメーション
`heightOfSlider`パラメータはバインディングなので、ユーザーインタラクションに応じてスライダーの高さをアニメーションできます：

```swift
// スムーズなスプリングアニメーション
withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
    height = isActive ? 16 : 8
}

// 弾むエフェクト
withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
    height = isPressed ? 24 : 6
}
```

### ノブアニメーション
ノブの外観とプロパティをアニメーション：

```swift
knob: {
    Circle()
        .fill(.white)
        .scaleEffect(isDragging ? 1.2 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isDragging)
}
```

### ノブを非表示にする
ノブを完全に非表示にしたい場合は、非常に低い透明度のCircleを渡すことができます：

```swift
knob: {
    Circle()
        .opacity(0.000001) // ほぼ透明でノブが見えない
}
```

この方法により、視覚的にはノブが存在しないスライダーを作成できますが、タッチ操作は正常に機能します。

## 使用例

### 音楽プレイヤー連携

```swift
struct MusicPlayerView: View {
    @State private var currentTime: Double = 0
    @State private var sliderHeight: CGFloat = 4
    let totalDuration: Double = 180 // 3分
    
    var body: some View {
        VStack {
            Text("再生中")
            
            MusicSlider(
                value: $currentTime,
                totalValue: totalDuration,
                valueIndicatorColor: .accentColor,
                heightOfSlider: $sliderHeight,
                onChange: { _ in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        sliderHeight = 8
                    }
                },
                onEnded: { newTime in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        sliderHeight = 4
                    }
                    // オーディオプレイヤーで新しい時間にシーク
                    audioPlayer.seek(to: newTime)
                }
            )
            
            HStack {
                Text(formatTime(currentTime))
                Spacer()
                Text(formatTime(totalDuration))
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
    }
}
```

### カスタムスタイルスライダー

```swift
MusicSlider(
    value: $progress,
    totalValue: 100,
    valueIndicatorColor: .gradient(colors: [.purple, .pink]),
    sliderBackgroundColor: .black.opacity(0.1),
    heightOfSlider: $height,
    knob: {
        RoundedRectangle(cornerRadius: 4)
            .fill(.white)
            .frame(width: 8, height: 16)
            .shadow(radius: 2)
    }
)
```

## 動作環境

- iOS 17.0以降
- Xcode 15.0以降
- Swift 5.9以降

## 貢献

貢献を歓迎します！プルリクエストを気軽に送信してください。

---

**プロヒント**: アニメーション高さ機能により、スライダーがより反応的で洗練された印象になります。アプリの個性に合わせて異なるアニメーションカーブとタイミングを試してみてください！🎵✨
