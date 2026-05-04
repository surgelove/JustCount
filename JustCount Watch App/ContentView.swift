import SwiftUI

struct ContentView: View {
    @State private var viewModel = CounterViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Counter display
                Text("\(viewModel.count)")
                    .font(.system(size: 60, weight: .bold))
                    .contentTransition(.numericText())
                    .animation(.snappy, value: viewModel.count)
                    .focusable(false)

                // Count buttons
                HStack(spacing: 16) {
                    Button {
                        viewModel.decrement()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 40))
                            .symbolRenderingMode(.hierarchical)
                            .tint(.red)
                    }
                    .buttonStyle(.plain)

                    Button {
                        viewModel.increment()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 40))
                            .symbolRenderingMode(.hierarchical)
                            .tint(.green)
                    }
                    .buttonStyle(.plain)
                }

                // Action buttons
                VStack(spacing: 8) {
                    Button("Reset") {
                        viewModel.reset()
                    }
                    .buttonStyle(.bordered)
                    .tint(.gray)

                    Button("Save") {
                        viewModel.saveCurrentCount()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }

                // Saved counts list
                if !viewModel.savedCounts.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Saved Counts")
                            .font(.headline)
                            .padding(.top, 4)

                        ForEach(Array(viewModel.savedCounts.enumerated()), id: \.offset) { index, value in
                            HStack {
                                Text("#\(index + 1)")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                Spacer()
                                Text("\(value)")
                                    .font(.body.monospacedDigit().bold())
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("JustCount")
    }
}

#Preview {
    ContentView()
}
