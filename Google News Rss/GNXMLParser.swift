

import UIKit


class GNXMLParser: NSObject,NSXMLParserDelegate {
    
    var parser: NSXMLParser!
    var allData = [[String : AnyObject]]()
    var currentNode = [String : String]()
    var complitionHandler: (([[String : AnyObject]]?) -> ())?
    var currentElement = ""
    var foundCharacters = ""
    var itemElementFound = false
    var stringImageURL = ""
    var urlString:String = "" {
        
        didSet{
            
            let url = NSURL(string:urlString)!
            parser = NSXMLParser(contentsOfURL:url)
            parser.delegate = self
            if !parser.parse() {
                
                complitionHandler?(nil)
            }
        }
    }
    
    override init() {
        super.init()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        // any data before "item" element is discarded
        // this bool helps to identify when the "item" element has started
        currentElement = elementName
        if elementName == "item" {
            itemElementFound = true
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        // since this method gets called multiple times, keep track of the element name and save the associated value
        if (currentElement == "title" || currentElement == "link" || currentElement == "description" || currentElement == "pubDate") && itemElementFound {
            foundCharacters += string
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !foundCharacters.isEmpty {
            // the actual url to news website is embeded within the link url
            if elementName == "link" {
                let storyURL = getFullStoryURL(foundCharacters)
                foundCharacters = storyURL
            }
            
            // image url is embedded within the description
            // description is also the last element
            if currentElement == "description" {
                
                getImageURL(foundCharacters)
                
                currentNode["imageURL"] = stringImageURL
                
                allData.append(currentNode)
            } else {
                currentNode[currentElement] = foundCharacters
            }
            foundCharacters = ""
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        if allData.count > 0 {
            allData.removeLast()
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.complitionHandler?(self.allData)
        }
    }
   
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        
        complitionHandler?(nil)

    }
    
    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
        
        complitionHandler?(nil)

    }

    // MARK: - Helper Methods
    
    func getImageURL(descriptionString: String){
        var url : NSString? = ""
        let scanner = NSScanner(string: descriptionString)
        scanner.scanUpToString("<img src=", intoString: nil)
        
        if !scanner.atEnd{
            scanner.scanLocation += 12
            scanner.scanUpToString("\"", intoString: &url)
            
            var imgURL = "https://"
            imgURL += url as! String
            stringImageURL = imgURL
        }
    }
    
    func getFullStoryURL(link: String) -> String{
        var StoryURL :NSString? = ""
        
        let scanner = NSScanner(string: link)
        scanner.scanUpToString("url=", intoString: nil)
        if !scanner.atEnd{
            scanner.scanLocation += 4
            scanner.scanUpToString("\"", intoString: &StoryURL)
        }
        let fullStoryURL = StoryURL as! String
        return fullStoryURL
    }
    
    
    
}
