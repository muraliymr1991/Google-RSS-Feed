

import UIKit

class GNNewsCell: UITableViewCell, NSXMLParserDelegate {

    
    @IBOutlet weak var imageViewNews: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDiscription: UILabel!
    
    var cache = NSCache()
    
    var news: [String: AnyObject] = [:] {
        
        didSet {
            
            self.prepareUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepareUI () {
        
        if let title = news["title"] as? String {
            labelTitle.text = title
            labelDiscription.text = news["title"] as? String
        }
        if let imgURLString = news["imageURL"] as? String {
            let imgURL = NSURL(string: imgURLString)
            fetchImage(imgURL!) { (image,error) -> () in
                if let img = image {
                    self.imageViewNews.image = img
                } else if let err = error{
                    print(err)
                }
            }
        }

    }

    
    func fetchImage(imageURL : NSURL, completionHandler: (image: UIImage?, error: String?) -> ()){
        
        //check for cached image first; otherwise, download image and add to cache
        if let cachedVersion = cache.objectForKey(imageURL.absoluteString){
            completionHandler(image: cachedVersion as? UIImage, error: nil)
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                let data : NSData? = NSData(contentsOfURL: imageURL)
                if let imageData = data{
                    let img = UIImage(data: imageData)
                    self.cache.setObject(img!, forKey: imageURL.absoluteString)
                    
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        completionHandler(image: img!, error: nil)
                    }
                } else {
                    completionHandler(image: nil, error: "Network problem")
                }
            }
        }
    }
}
