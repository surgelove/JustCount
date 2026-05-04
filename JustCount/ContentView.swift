import SwiftUI

struct ContentView: View {
    @State private var viewModel = CounterViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Counter display
                Text("\(viewModel.count)")
                    .font(.system(size: 80, weight: .bold))
                    .contentTransition(.numericText())
                    .animation(.snappy, value: viewModel.count)

                // Count buttons
                HStack(spacing: 24) {
                    Button {
                        viewModel.decrement()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 56))
                            .symbolRenderingMode(.hierarchical)
                            .tint(.red)
                    }

                    Button {
                        viewModel.increment()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 56))
                            .symbolRenderingMode(.hierarchical)
                            .tint(.green)
                    }
                }

                // Action buttons
                HStack(spacing: 16) {
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
                            .padding(.top, 8)

                        List {
                            ForEach(Array(viewModel.savedCounts.enumerated()), id: \.offset) { index, value in
                                HStack {
                                    Text("#\(index + 1)")
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    Text("\(value)")
                                        .font(.body.monospacedDigit().bold())
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("JustCount")
        }
    }
}

#Preview {
    ContentView()
}
