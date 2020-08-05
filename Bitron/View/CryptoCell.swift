//
//  CryptoCell.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class CryptoCell: UITableViewCell {

   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
       
   }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)

       // Configure the view for the selected state
   }
}
