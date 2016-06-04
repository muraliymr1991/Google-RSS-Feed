
import UIKit

class GNFavsViewController: UITableViewController {

    
    var arrayNews = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let array = NSUserDefaults.standardUserDefaults().objectForKey("gn_favs") as? [[String: AnyObject]] else {
            return
        }
        
        arrayNews = array
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSUserDefaults.standardUserDefaults().setObject(arrayNews, forKey: "gn_favs")
        NSUserDefaults.standardUserDefaults()

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayNews.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath) as? GNNewsCell
        
        cell?.news = arrayNews[indexPath.row]
        
        return cell!
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
               return true
    }
 
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            arrayNews.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
}
