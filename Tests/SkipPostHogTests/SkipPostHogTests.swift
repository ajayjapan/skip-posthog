// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

import XCTest
import OSLog
import Foundation
@testable import SkipPostHog

let logger: Logger = Logger(subsystem: "SkipPostHog", category: "Tests")

@available(macOS 13, *)
final class SkipPostHogTests: XCTestCase {
    func testSkipPostHog() throws {
        PostHogSDK.shared.setup(PostHogConfig(apiKey: ""))
    }
}
