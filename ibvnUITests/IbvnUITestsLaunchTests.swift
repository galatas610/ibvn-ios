//
//  IbvnUITestsLaunchTests.swift
//  ibvnUITests
//
//  Created by Jose Letona on 25/3/24.
//

import XCTest

class IbvnUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
    }
}
