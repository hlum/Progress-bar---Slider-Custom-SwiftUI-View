// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct MusicSlider<KnobView: View>: View {
    @Binding var value: Double
    let totalValue: Double
    let onEnded: (Double) -> Void
    let onChange: ((Double) -> Void)?
    let valueIndicatorColor: Color
    let sliderBackgroundColor: Color
    @Binding var heightOfSlider: CGFloat
    
    let knob: () -> KnobView
    
    public init(
        value: Binding<Double>,
        totalValue: Double,
        valueIndicatorColor: Color = .blue,
        sliderBackgroundColor: Color = .gray.opacity(0.3),
        heightOfSlider: Binding<CGFloat> = .constant(6),
        
        @ViewBuilder knob: @escaping () -> KnobView = { Circle().foregroundStyle(.white).shadow(radius: 2) },

        onChange: ((Double) -> Void)? = nil,
        onEnded: @escaping (Double) -> Void
        
        
        
    ) {
        _value = value
        self.totalValue = totalValue
        self.onChange = onChange
        self.onEnded = onEnded
        _heightOfSlider = heightOfSlider
        self.knob = knob
        self.valueIndicatorColor = valueIndicatorColor
        self.sliderBackgroundColor = sliderBackgroundColor
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                
                ZStack(alignment: .leading) {
                    Capsule()
                        .foregroundStyle(sliderBackgroundColor)
                        .frame(height: heightOfSlider)
                       
                    
                    Capsule()
                        .foregroundStyle(valueIndicatorColor)
                        .frame(width: CGFloat(self.value / totalValue) * geometry.size.width, height: heightOfSlider)
                        
                    
                    knob()
                        .offset(x: CGFloat(self.value / totalValue) * geometry.size.width - 9)
                       
                }
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let newX = min(max(0, gesture.location.x), geometry.size.width)
                            let newValue = (newX / geometry.size.width) * totalValue
                            self.value = newValue
                            onChange?(value)
                        }
                        .onEnded { _  in
                            onEnded(value)
                        }
                )

            }
        }
        .frame(height: 24)
    }
}


#Preview {
    @Previewable
    @State var value: Double = 10
    @Previewable
    @State var onChangeCalled: Bool = false
    @Previewable
    @State var height: CGFloat = 10
    var totalDuration: Double = 100
    VStack {
        MusicSlider(
            value: $value,
            totalValue: 100,
            valueIndicatorColor: .blue,
            
            heightOfSlider: $height,
            knob: { Circle().opacity(0.000001) },
            onChange: { _ in
                withAnimation(.spring) {
                    height = 20
                }
                onChangeCalled = true
            },
            onEnded: { _ in
                withAnimation(.spring) {
                    height = 10
                }
                onChangeCalled = false
            }
        )
        .padding(.horizontal)
    }
}
