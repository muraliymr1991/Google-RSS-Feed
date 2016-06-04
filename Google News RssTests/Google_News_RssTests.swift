

import XCTest
@testable import Google_News_Rss

class Google_News_RssTests: XCTestCase {
    
    var viewController : GNNewsViewController!
    
    override func setUp() {
       
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("gnNews") as! GNNewsViewController
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    func testOfflineData () {
        
        viewController.loadOfflineData()
        
        XCTAssert(viewController.arrayNews.count > 0, "Offline data available")
        
    }
    
    func testFetchImage() {
        
        let expectation = self.expectationWithDescription("Downloading Image")

        let imageURL = NSURL(string:"https://images.google.com/images/branding/googleg/1x/googleg_standard_color_128dp.png")
        
        let celll = GNNewsCell()
        celll.fetchImage(imageURL!) { (image, error) -> () in
            
            
            if let error = error {
                print("Image donwload Error: %@", error);
            }
            else{
                expectation.fulfill()

            }

            
        }
        
        self.waitForExpectationsWithTimeout(7 ) { (error) in
            
            if let error = error {
                print("Timeout Error: %@", error);
            }
        }

    }
    
    func testWithFalseData () {
        
        let expectation = self.expectationWithDescription("Check parsing")
        let parser = GNXMLParser()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            XCTAssert(self.viewController.arrayNews.count == 0, "No data avialble")
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(7 ) { (error) in
            
            if let error = error {
                print("Timeout Error: %@", error);
            }
        }
        parser.urlString = "http://google.com"
    }
    
    func testPerformance() {
       
        let vc = GNNewsViewController()
        measureBlock() {
            
            vc.loadData()
            _ = vc.arrayNews
        
        }
    }
    
}
