//
//  Untitled.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 22.01.2025.
//

import Foundation

protocol Timer {
    
    var isRunning: Bool { get }
    func startTimer(interval: TimeInterval,
                    queue: DispatchQueue,
                    action: @escaping () -> Void)
    func stopTimer()
}

class TimerIml: Timer {
    
    // Non Atomic
    private(set) var isRunning: Bool = false
    
    private var timer: DispatchSourceTimer?

    // Function to start a timer
    func startTimer(interval: TimeInterval,
                    queue: DispatchQueue = DispatchQueue.global(),
                    action: @escaping () -> Void
    ) {
        self.stopTimer()
        self.isRunning = true
        self.timer = DispatchSource.makeTimerSource(queue: queue)
        self.timer?.schedule(deadline: .now(), repeating: interval)
        self.timer?.setEventHandler(handler: action)
        self.timer?.resume()
    }

    // Function to stop the timer
    func stopTimer() {
        self.timer?.cancel()
        self.isRunning = false
        self.timer = nil
    }
}
