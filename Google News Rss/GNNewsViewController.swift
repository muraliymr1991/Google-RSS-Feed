

import UIKit

class GNNewsViewController: UITableViewController {

    let reuseIdentifier = "newsCell"
    let dataIdentifier = "gn_offline_data"
    let sDetail = "showDetail"
    let URLNewsRSS = "https://news.google.com/?output=rss"

    var parser: GNXMLParser!
    
    var arrayNews = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "News"
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(GNNewsViewController.refreshNews(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl?.beginRefreshing()
        self.loadData()
        
        
        UINavigationBar.appearance().tintColor = UIColor(red: 40/255, green: 144/255, blue: 255/255, alpha: 1.0);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func loadData() {
        
        parser = GNXMLParser()
        
        parser.complitionHandler = { array in
            
            self.refreshControl?.endRefreshing()
            
            guard let array = array else {
                
                self.loadOfflineData()
                return
            }
            self.arrayNews = array
            self.tableView.reloadData()
            
            NSUserDefaults.standardUserDefaults().setObject(array, forKey: self.dataIdentifier)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        parser.urlString = URLNewsRSS
    }
    
    func loadOfflineData() {
        
        guard let array = NSUserDefaults.standardUserDefaults().objectForKey(dataIdentifier) as? [[String: AnyObject]] else {
            return
        }
        
        self.arrayNews = array
        self.tableView.reloadData()
    }
    
    func refreshNews(sender: UIRefreshControl)  {
        
       self.loadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
               return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return arrayNews.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as? GNNewsCell

        cell?.news = arrayNews[indexPath.row]
        
        if indexPath.row % 2 == 0 {
            cell?.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 0.4)
        }
        else {
            
            cell?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        }

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier(sDetail, sender: arrayNews[indexPath.row])
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let vc = segue.destinationViewController as? GNDetailViewController
        
        guard let news = sender as? [String: AnyObject] else {
            
            return
        }
        
        vc?.news = news
        vc?.urlString = news["link"] as! String
        vc?.title = news["title"] as? String
    }
    

}
