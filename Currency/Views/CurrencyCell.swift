//
//  CustomView.swift
//  Currency
//
//  Created by Giorgi on 12/31/20.
//

import UIKit
import SDWebImage

class CurrencyCell: UITableViewCell {
    
    //MARK: - Properties
    
    var currency: Currency? {
        didSet {
            configure()
        }
    }
    
    private let acronymLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    private let namelabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    private let ratelabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    private let changelabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    private let changeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setDimensions(height: 10, width: 10)
        
        return imageView
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        isUserInteractionEnabled = false
        
        let nameStack = UIStackView(arrangedSubviews: [acronymLabel, namelabel])
        nameStack.axis = .horizontal
        nameStack.spacing = 4
        
        addSubview(nameStack)
        nameStack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(ratelabel)
        ratelabel.anchor(top: nameStack.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        let changeStack = UIStackView(arrangedSubviews: [changeImageView, changelabel])
        changeStack.axis = .horizontal
        changeStack.spacing = 8
        
        addSubview(changeStack)
        changeStack.anchor(top: nameStack.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
 
    func configure() {
        guard let currency = self.currency else {return}
        acronymLabel.text = currency.acronym
        namelabel.text = "- \(currency.name)"
        ratelabel.text = "\(currency.rate) Gel"
        changelabel.text = currency.currencyChanged
        let imageurl = URL(string: currency.imageUrl)
        changeImageView.sd_setImage(with: imageurl)
        
    }
    
}
