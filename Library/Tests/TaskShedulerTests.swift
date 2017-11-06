import XCTest
@testable import SwiftyVK

final class TaskShedulerTests: XCTestCase {
    
    func test_exeuteAllConcurrentOperations_forCertainTime() {
        // Given
        let group = DispatchGroup()
        for _ in 0..<operationCount { group.enter() }
        // When
        let samples = sheduleSamples(count: operationCount, concurrent: true, completion: { group.leave() })
        _ = group.wait(timeout: .now() + totalRunTime)
        // Then        
        XCTAssertEqual(
            samples.map {$0.isFinished},
            (0..<operationCount).map { _ in true },
            "All concurrent operations should be executed"
        )
    }
    
    func test_executeMinimumSerialOpearations_forOneSecond() {
        // When
        let group = DispatchGroup()
        for _ in 0..<operationCount { group.enter() }
        let samples = sheduleSamples(count: operationCount, concurrent: false, completion: { group.leave() })
        // Then
        _ = group.wait(timeout: .now() + 1)

        XCTAssertLessThan(samples.filter { $0.isFinished }.count, operationCount,
            "Operations should be executed serially"
        )
    }
    
    func test_executeAllSerialOpearations_forCertainTime() {
        // Given
        let group = DispatchGroup()
        for _ in 0..<operationCount { group.enter() }
        // When
        let samples = sheduleSamples(count: operationCount, concurrent: false, completion: { group.leave() })
        _ = group.wait(timeout: .now() + totalRunTime * 10)
        // Then
        XCTAssertEqual(samples.filter { $0.isFinished }.count, operationCount,
            "All operations should be executed"
        )
    }
    
    func test_exeuteRandomOperations() {
        // Given
        let serialGroup = DispatchGroup()
        let concurrentGroup = DispatchGroup()
        for _ in 0..<operationCount { serialGroup.enter() }
        for _ in 0..<operationCount { concurrentGroup.enter() }
        // When
        let serial = sheduleSamples(count: operationCount, concurrent: false, completion: { serialGroup.leave() })
        let concurrent = sheduleSamples(count: operationCount, concurrent: true, completion: { concurrentGroup.leave() })
        
        // Then
        _ = concurrentGroup.wait(timeout: .now() + totalRunTime)
        
        XCTAssertLessThan( serial.filter { $0.isFinished }.count, operationCount,
            "Operations should be executed serially"
        )
        
        XCTAssertEqual(concurrent.map {$0.isFinished}, (0..<operationCount).map { _ in true },
            "All concurrent operations should be executed"
        )
        
        _ = serialGroup.wait(timeout: .now() + totalRunTime * 10)

        XCTAssertEqual(serial.filter { $0.isFinished }.count, operationCount,
            "All serial operations should be executed"
        )
    }
    
    override func setUp() {
        sheduler = TaskShedulerImpl()
    }
    
    override func tearDown() {
        sheduler = nil
    }
}

private var sheduler: TaskShedulerImpl?

private let operationCount = 100

private var totalRunTime: TimeInterval {
    return TaskMock().runTime*Double(operationCount)
}

private func sheduleSamples(count: Int, concurrent: Bool, completion: (() -> ())? = nil) -> [TaskMock] {
    let samples = (0..<count).map { _ in TaskMock(completion: completion) }
    samples.forEach { sheduler?.shedule(task: $0, concurrent: concurrent) }
    return samples
}
