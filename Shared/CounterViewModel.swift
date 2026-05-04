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
        count -= 1
    }

    func reset() {
        count = 0
    }

    func saveCurrentCount() {
        savedCounts.append(count)
    }
}
