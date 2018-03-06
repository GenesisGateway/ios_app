//
//  HomeViewControllerTests.swift
//  iOSGenesisSampleTests
//

import XCTest
@testable import iOSGenesisSample
@testable import GenesisSwift

class HomeViewControllerTests: XCTestCase {
    var controller: HomeViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: HomeViewController = (storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController)!
        controller = vc
        _ = controller.view
    }
    
    override func tearDown() {
        super.tearDown()
        
        controller = nil
    }
    
    func testSegues() {
        let identifiers = segues(ofViewController: controller)
        XCTAssertEqual(identifiers.count, 1)
        XCTAssertTrue(identifiers.contains("TransactionDetailsSegue"))
    }
    
    // Mark: - Helper Methods
    
    func segues(ofViewController viewController: UIViewController) -> [String] {
        let identifiers = (viewController.value(forKey: "storyboardSegueTemplates") as? [AnyObject])?.flatMap({ $0.value(forKey: "identifier") as? String }) ?? []
        return identifiers
    }
}
