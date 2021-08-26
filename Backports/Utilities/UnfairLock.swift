/*

 Source was part of Apple Sample Code "Building High-Performance Lists and Collection Views"
 https://developer.apple.com/documentation/uikit/uiimage/building_high-performance_lists_and_collection_views

 Original LICENSE:

 Copyright © 2021 Apple Inc.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Abstract: A custom unfair lock implementation.
*/

import Foundation
import Combine

final class UnfairLock {
    @usableFromInline let lock: UnsafeMutablePointer<os_unfair_lock>
    
    public init() {
        lock = .allocate(capacity: 1)
        lock.initialize(to: os_unfair_lock())
    }

    deinit {
        lock.deallocate()
    }
    
    @inlinable
    @inline(__always)
    func withLock<Result>(body: () throws -> Result) rethrows -> Result {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        return try body()
    }
    
    @inlinable
    @inline(__always)
    func withLock(body: () -> Void) {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        body()
    }
    
    // Assert that the current thread owns the lock.
    @inlinable
    @inline(__always)
    public func assertOwner() {
        os_unfair_lock_assert_owner(lock)
    }

    // Assert that the current thread does not own the lock.
    @inlinable
    @inline(__always)
    public func assertNotOwner() {
        os_unfair_lock_assert_not_owner(lock)
    }

    private final class LockAssertion: Cancellable {
        private var _owner: UnfairLock

        init(owner: UnfairLock) {
            _owner = owner
            os_unfair_lock_lock(owner.lock)
        }

        __consuming func cancel() {
            os_unfair_lock_unlock(_owner.lock)
        }
    }

    func acquire() -> Cancellable {
        return LockAssertion(owner: self)
    }
}
