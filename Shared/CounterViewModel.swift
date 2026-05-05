import Foundation
import Observation

@Observable
final class CounterViewModel {
    var count: Int = 0
    var savedCounts: [Int] = []

    func increment() {
        count += 1
    }

    func decrement() {
        count = max(0, count - 1)
    }

    func reset() {
        count = 0
    }

    func saveCurrentCount() {
        guard count != 0 else { return }
        savedCounts.append(count)
        count = 0
    }

    func removeSavedCount(at index: Int) {
        savedCounts.remove(at: index)
    }

    func clearAllSavedCounts() {
        savedCounts.removeAll()
    }
}
