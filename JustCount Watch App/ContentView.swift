import SwiftUI

struct ContentView: View {
    @State private var viewModel = CounterViewModel()

    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
            let countSize = w * 0.26

            ScrollView {
                VStack(spacing: 0) {
                    // ── Main screen: count + 4 quadrants ──
                    VStack(spacing: 0) {
                        // Count
                        Text("\(viewModel.count)")
                            .font(.system(size: countSize, weight: .bold))
                            .contentTransition(.numericText())
                            .animation(.snappy, value: viewModel.count)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 12)

                        // Row 1: − / +
                        HStack(spacing: 0) {
                            tapZone { viewModel.decrement() }
                                .overlay(alignment: .center) {
                                    Triangle()
                                        .stroke(.red, lineWidth: 2)
                                        .frame(width: 20, height: 20)
                                }
                            Rectangle()
                                .fill(.secondary.opacity(0.3))
                                .frame(width: 1)
                            tapZone { viewModel.increment() }
                                .overlay(alignment: .center) {
                                    Triangle()
                                        .stroke(.green, lineWidth: 2)
                                        .frame(width: 20, height: 20)
                                        .rotationEffect(.degrees(180))
                                }
                        }
                        // Horizontal divider
                        Rectangle()
                            .fill(.secondary.opacity(0.3))
                            .frame(height: 1)
                        // Row 2: Save / Reset
                        HStack(spacing: 0) {
                            tapZone { viewModel.saveCurrentCount() }
                                .overlay(alignment: .center) {
                                    Rectangle()
                                        .stroke(.blue, lineWidth: 2)
                                        .frame(width: 20, height: 20)
                                }
                            Rectangle()
                                .fill(.secondary.opacity(0.3))
                                .frame(width: 1)
                            tapZone { viewModel.reset() }
                                .overlay(alignment: .center) {
                                    Xmark()
                                        .stroke(.white, lineWidth: 2)
                                        .frame(width: 20, height: 20)
                                }
                        }
                    }
                    .frame(minHeight: geometry.size.height)

                    // ── Saved counts (below fold) ──
                    if !viewModel.savedCounts.isEmpty {
                        Divider()
                            .padding(.horizontal, 8)

                        LazyVStack(spacing: 1) {
                            ForEach(Array(viewModel.savedCounts.enumerated()), id: \.offset) { index, value in
                                HStack {
                                    Text("#\(index + 1)")
                                        .foregroundStyle(.secondary)
                                        .font(.system(size: 14))
                                    Spacer()
                                    Text("\(value)")
                                        .font(.system(size: 18, weight: .bold).monospacedDigit())
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                            }
                        }
                        .padding(.vertical, 4)

                        // ── Clear all button ──
                        Circle()
                            .stroke(.red, lineWidth: 2)
                            .frame(width: 20, height: 20)
                            .contentShape(Circle())
                            .onTapGesture {
                                hapticTrigger.toggle()
                                viewModel.clearAllSavedCounts()
                            }
                            .sensoryFeedback(.impact, trigger: hapticTrigger)
                            .padding(.vertical, 8)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .ignoresSafeArea()
    }

    @State private var hapticTrigger = false

    private func tapZone(action: @escaping () -> Void) -> some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture {
                hapticTrigger.toggle()
                action()
            }
            .sensoryFeedback(.impact, trigger: hapticTrigger)
    }
}

// MARK: - Shapes

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.closeSubpath()
        }
    }
}

struct Xmark: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}

#Preview {
    ContentView()
}
