//
//  BaseTableCell.swift
//  Weather
//
//  Created by Алексей Однолько on 20.02.2024.
//

import UIKit

class BaseTableCell: UITableViewCell {

    static var nib : UINib { return UINib(nibName: String(describing: self), bundle: nil) }
    static var identifier : String { return String(describing: self) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configure()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectionStyle = .none
        setup()
    }
    
    func setupTheme() {
        let isNightMode = Calendar.current.isNightTime()
        if isNightMode {
            setupDarkTheme()
        } else {
            setupLightTheme()
        }
    }
    
    func setupLightTheme() {
        contentView.backgroundColor = .white
    }
    
    func setupDarkTheme() {
        contentView.backgroundColor = .black
    }
    
    func configure() { }
    func setup() { }

}
