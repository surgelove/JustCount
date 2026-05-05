import SwiftUI

struct ContentView: View {
    @State private var viewModel = CounterViewModel()
    @State private var hapticTrigger = false

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // ── Count (centered) ──
                    Text("\(viewModel.count)")
                        .font(.system(size: geometry.size.width * 0.26, weight: .bold))
                        .contentTransition(.numericText())
                        .animation(.snappy, value: viewModel.count)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                        .padding(.bottom, 12)

                    // ── 2×2 Grid (half screen height) ──
                    VStack(spacing: 0) {
                        // Row 1: − / +
                        HStack(spacing: 0) {
                            tapZone { viewModel.decrement() }
                                .overlay(alignment: .center) {
                                    Triangle()
                                        .stroke(.red, lineWidth: 3)
                                        .frame(width: 32, height: 32)
                                }
                            Rectangle()
                                .fill(.secondary.opacity(0.2))
                                .frame(width: 1)
                            tapZone { viewModel.increment() }
                                .overlay(alignment: .center) {
                                    Triangle()
                                        .stroke(.green, lineWidth: 3)
                                        .frame(width: 32, height: 32)
                                        .rotationEffect(.degrees(180))
                                }
                        }
                        // Horizontal divider
                        Rectangle()
                            .fill(.secondary.opacity(0.2))
                            .frame(height: 1)
                        // Row 2: Save / Reset
                        HStack(spacing: 0) {
                            strongTapZone { viewModel.saveCurrentCount() }
                                .overlay(alignment: .center) {
                                    Rectangle()
                                        .stroke(.blue, lineWidth: 3)
                                        .frame(width: 32, height: 32)
                                }
                            Rectangle()
                                .fill(.secondary.opacity(0.2))
                                .frame(width: 1)
                            strongTapZone { viewModel.reset() }
                                .overlay(alignment: .center) {
                                    Xmark()
                                        .stroke(.primary, lineWidth: 3)
                                        .frame(width: 32, height: 32)
                                }
                        }
                    }
                    .frame(minHeight: geometry.size.height / 2)

                    // ── Saved counts (below fold) ──
                    if !viewModel.savedCounts.isEmpty {
                        Divider()
                            .padding(.horizontal, 24)

                        LazyVStack(spacing: 1) {
                            ForEach(Array(viewModel.savedCounts.enumerated()), id: \.offset) { index, value in
                                HStack {
                                    Text("#\(index + 1)")
                                        .foregroundStyle(.secondary)
                                        .font(.title3)
                                    Spacer()
                                    Text("\(value)")
                                        .font(.title.monospacedDigit().bold())
                                    Xmark()
                                        .stroke(.primary, lineWidth: 2)
                                        .frame(width: 16, height: 16)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            viewModel.removeSavedCount(at: index)
                                        }
                                        .padding(.leading, 12)
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 8)
                            }
                        }
                        .padding(.vertical, 8)

                        Divider()
                            .padding(.horizontal, 24)

                        // Total
                        HStack {
                            Text("Total")
                                .foregroundStyle(.secondary)
                                .font(.title3)
                            Spacer()
                            Text("\(viewModel.savedCounts.reduce(0, +))")
                                .font(.title.monospacedDigit().bold())
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)

                        Divider()
                            .padding(.horizontal, 24)

                        // Clear all button
                        Xmark()
                            .stroke(.red, lineWidth: 3)
                            .frame(width: 32, height: 32)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                hapticTrigger.toggle()
                                viewModel.clearAllSavedCounts()
                            }
                            .sensoryFeedback(.impact, trigger: hapticTrigger)
                            .padding(.vertical, 12)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    @State private var strongHapticTrigger = false

    private func tapZone(action: @escaping () -> Void) -> some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture {
                hapticTrigger.toggle()
                action()
            }
            .sensoryFeedback(.impact, trigger: hapticTrigger)
    }

    private func strongTapZone(action: @escaping () -> Void) -> some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture {
                strongHapticTrigger.toggle()
                action()
            }
            .sensoryFeedback(.impact(flexibility: .solid, intensity: 1.0), trigger: strongHapticTrigger)
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
