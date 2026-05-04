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
                            .frame(maxWidth: .infinity)

                        // Row 1: − / +
                        HStack(spacing: 0) {
                            tapZone { viewModel.decrement() }
                            tapZone { viewModel.increment() }
                        }
                        // Row 2: Save / Reset
                        HStack(spacing: 0) {
                            tapZone { viewModel.saveCurrentCount() }
                            tapZone { viewModel.reset() }
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
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .ignoresSafeArea()
    }

    private func tapZone(action: @escaping () -> Void) -> some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture(perform: action)
    }
}

#Preview {
    ContentView()
}
