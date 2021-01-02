//
//  CurrencyController.swift
//  Currency
//
//  Created by Giorgi on 12/31/20.
//

import UIKit

class CurrencyController: UITableViewController {
    
    //MARK: - Properties
    
    private let reuseId = CurrencyCell.description()
    private var currencies = [Currency]()
    private var filteredCurrencies = [Currency]()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
 
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getCurrencies()
        configureSearchController()
    }
    
    //MARK: - API

    func getCurrencies() {
        showLoader(true)
        NetworkingManager.getCurrencies {[weak self] data in
            guard let self = self else {return}
            self.showLoader(false)
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: reuseId)
        tableView.rowHeight = 70
        title = "Currency rates"
        navigationController?.navigationBar.prefersLargeTitles = true
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
        DispatchQueue.main.async { [weak self] in
           guard let self = self else {return}
            self.tableView.reloadData()
        }
    }

    func prettify(string: String?) -> String {
        guard var str = string else {return " "}
        
        let vowels: Set<Character> = [">", "<","\""]
        str.removeAll(where: { vowels.contains($0)})
        
        let str0 = str.replacingOccurrences(of: "img  src=", with: "")
        let str1 = str0.replacingOccurrences(of: "/td", with: ",")
        let str2 = str1.replacingOccurrences(of: "td", with: "")
        let str3 = str2.replacingOccurrences(of: "/trtr", with: "sep")
        let str4 = str3.replacingOccurrences(of: "/tr/table", with: "")
        let str5 = str4.replacingOccurrences(of: "table border=0tr", with: "")
        let str6 = str5.replacingOccurrences(of: "\n\t\t\t", with: "")
                
        return str6
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search.."
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

    //MARK: - TableView Data Source

extension CurrencyController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return inSearchMode ? filteredCurrencies.count : currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! CurrencyCell
        let currency = inSearchMode ? filteredCurrencies[indexPath.row] : currencies[indexPath.row]
        cell.currency = currency
        
        return cell
    }
}

//MARK: - XMLParserDelegate

extension CurrencyController: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        let data = Data(CDATABlock)
        let stringEncoding = String.Encoding(rawValue: 4)
        let stringData = String(data: data, encoding: stringEncoding)

        let refactoredString = prettify(string: stringData)
        makeAnArray(fromString: refactoredString) 
    }
}

//MARK: - UISearchResultsUpdating & UISearchControllerDelegate

extension CurrencyController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        
        filteredCurrencies = currencies.filter({  $0.acronym.lowercased().contains(searchText) || $0.name.lowercased().contains(searchText) })
        self.tableView.reloadData()
    }
}






