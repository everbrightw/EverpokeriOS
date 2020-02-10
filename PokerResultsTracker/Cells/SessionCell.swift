//
//  SessionCell.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 11/27/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit

class SessionCell: UITableViewCell {
    
    var sessionImageView = UIImageView()
    var sessionTitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        addSubview(sessionImageView)
        
        //configure cell style
        self.backgroundColor = UIColor(red:42/255, green:43/255, blue:55/255, alpha:1)
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
        
        addSubview(sessionTitleLabel)
        configureImageView()
        configureTitleView()
        setImageConstraints()
        setTitleLabelConstraints()
        
    }
    
    func configureImageView(){
        sessionImageView.layer.cornerRadius = 10
        sessionImageView.clipsToBounds = true
    }
    
    func configureTitleView(){
        sessionTitleLabel.numberOfLines = 0
        sessionTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setImageConstraints(){
        sessionImageView.translatesAutoresizingMaskIntoConstraints = false
        sessionImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sessionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        sessionImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        sessionImageView.widthAnchor.constraint(equalTo: sessionImageView.heightAnchor, multiplier: 16/9).isActive = true
    }
    
    func setTitleLabelConstraints(){
        sessionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sessionTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sessionTitleLabel.leadingAnchor.constraint(equalTo: sessionImageView.trailingAnchor, constant: 20).isActive = true
        sessionTitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        sessionTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
    func set(session: Session){
        sessionImageView.image = session.sessionImage
        sessionTitleLabel.text = session.title
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
