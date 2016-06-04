

import UIKit

class GNDetailViewController: UIViewController {

    
    var urlString: String!
    var news:[String:AnyObject]!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let request = NSURLRequest(URL: NSURL(string: urlString)!)
        webView.loadRequest(request)
    }

    @IBAction func shareLink(sender: AnyObject) {
        
        let textToShare = "Hey!! Check out this news"
        
        if let urlToShare = NSURL(string: urlString) {
            
            let objectsToShare = [textToShare, urlToShare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveToFavs(sender: AnyObject) {
        
        
        guard var array = NSUserDefaults.standardUserDefaults().objectForKey("gn_favs") as? [[String: AnyObject]] else {
            
            var array = [[String: AnyObject]]()
            array.append(news)
            NSUserDefaults.standardUserDefaults().setObject(array, forKey: "gn_favs")
            NSUserDefaults.standardUserDefaults()
            return
        }
        
        
        if !array.contains( { $0["title"] as? String == news["title"] as? String }) {
            
            array.append(news);
        }

        NSUserDefaults.standardUserDefaults().setObject(array, forKey: "gn_favs")
        NSUserDefaults.standardUserDefaults()
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
