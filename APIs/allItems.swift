/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class AllItems {
	public var title : String?
	public var hebrew : String?
	public var category : String?
	public var date : String?

 public class func modelsFromDictionaryArray(array:NSArray) -> [AllItems]
    {
        var models:[AllItems] = []
        for item in array
        {
            models.append(AllItems(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {

		title = dictionary["title"] as? String
		hebrew = dictionary["hebrew"] as? String
		category = dictionary["category"] as? String
		date = dictionary["date"] as? String
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.hebrew, forKey: "hebrew")
		dictionary.setValue(self.category, forKey: "category")
		dictionary.setValue(self.date, forKey: "date")

		return dictionary
	}

}
