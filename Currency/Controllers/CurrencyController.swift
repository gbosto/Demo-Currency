//
//  CurrencyController.swift
//  Currency
//
//  Created by Giorgi on 12/31/20.
//

import UIKit

struct Currency {
    let acronym: String
    let name: String
    let rate: String
    let imageUrl: String
    let currencyChanged: String
}

class CurrencyController: UITableViewController {
    
    //MARK: - Properties
    
    private let reuseId = "cell"
    var currencies = [Currency]()
 
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getCurrencies()

    }
    
    //MARK: - Networking
    
    func getCurrencies() {
        let url = URL(string: "http://www.nbg.ge/rss.php")!

        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, _, error in

            if let error = error {
                print("DEBUG: \(error.localizedDescription) ")
                return
            }

            guard let data = data else {return}
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }

    
    
    
    //MARK: - Helpers
    
    func configureUI() {
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: reuseId)
        tableView.rowHeight = 70
    }


    func makeAnArray(fromString text: String){
        let array = text.components(separatedBy: "sep")
        
        for i in array {
            let array = i.components(separatedBy: ",")
            let acronym = array[0]
            let name = array[1]
            let rate = array[2]
            let imageUrl = array[3]
            let currencyChanged = array[4]
            
            let currency = Currency(acronym: acronym, name: name,
                                    rate: rate, imageUrl: imageUrl,
                                    currencyChanged: currencyChanged)
            
            currencies.append(currency)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func prettify(string: String?) -> String {
        guard var str = string else {return " "}
        
        let vowels: Set<Character> = [">", "<"]
        str.removeAll(where: { vowels.contains($0)})
        
        let str0 = str.replacingOccurrences(of: "img  src=", with: " ")
        let str1 = str0.replacingOccurrences(of: "/td", with: ",")
        let str2 = str1.replacingOccurrences(of: "td", with: " ")
        let str3 = str2.replacingOccurrences(of: "/trtr", with: "sep")
        var str4 = str3.replacingOccurrences(of: "/tr/table", with: " ")
        str4.removeFirst(18)
        
        return str4
    }

}





    //MARK: - TableView Data Source

extension CurrencyController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! CurrencyCell
        let currency = currencies[indexPath.row]
        cell.currency = currency
        
        return cell
    }
}

//MARK: - XMLParserDelegate

extension CurrencyController: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        let data = Data(CDATABlock)
        let stringEncoding = String.Encoding(rawValue: 1)
        let stringData = String(data: data, encoding: stringEncoding)
        

        let refactoredString = prettify(string: stringData)
        makeAnArray(fromString: refactoredString) 
    }
}








