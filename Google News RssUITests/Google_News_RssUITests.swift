

import XCTest
@testable import Google_News_Rss

class Google_News_RssUITests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Test this case after first run
    
    func testOfflineFuncationality() {
        
    
        let app = XCUIApplication()
        app.tables.cells.elementBoundByIndex(0).tap()
        XCUIDevice.sharedDevice().orientation = .FaceUp
        

        let toolbarsQuery = app.toolbars
        toolbarsQuery.buttons["Organize"].tap()
        toolbarsQuery.buttons["Share"].tap()
        XCUIDevice.sharedDevice().orientation = .Portrait
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).elementBoundByIndex(1).tap()
        XCUIDevice.sharedDevice().orientation = .FaceUp
        XCUIDevice.sharedDevice().orientation = .Portrait
        app.navigationBars.buttons["Back"].tap()
        
        let newsNavigationBar = app.navigationBars["News"]
        newsNavigationBar.buttons["Organize"].tap()
        
       newsNavigationBar.buttons["News"].tap()
        
            }
    
}





