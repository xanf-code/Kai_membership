//
//  KAICombobox.swift
//  KAI Membership
//
//  Created by Darshan Aswath on 12/03/2021.
//

import UIKit

protocol KAIComboboxDelegate: class {
    func kaiCombobox(_ kaiCombobox: KAICombobox, didSelectIndex index: Int)
}

struct ComboboxData {
    var title: String
    var subTitle: String? = nil
}

class KAICombobox: UIView {
    
    // MARK: Properties
    private let itemHeight: CGFloat = 56
    private let maxItemShow: CGFloat = 5
    private let transparentView = UIView()
    
    private let dropdownImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_dropdown"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        label.font = .workSansFont(ofSize: 14, weight: .medium)
        
        return label
    }()
    
    private lazy var selectedButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .init(hex: "FAFBFB")
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.init(hex: "E1E4E8").cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(onPressedDropdown), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        tableView.backgroundColor = .white
        tableView.register(ComboboxTableViewCell.self, forCellReuseIdentifier: ComboboxTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private var dataSources: [ComboboxData]
    
    private var selectedIndex: Int = 0 {
        didSet {
            guard selectedIndex != oldValue else { return }
            
            if let oldCell = tableView.cellForRow(at: IndexPath(row: oldValue, section: 0)) as? ComboboxTableViewCell {
                oldCell.isDropdownSelected = false
            }
            
            if let newCell = tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) as? ComboboxTableViewCell {
                newCell.isDropdownSelected = true
            }
            
            if let subTitle = dataSources[selectedIndex].subTitle {
                valueLabel.text = "\(dataSources[selectedIndex].title) (\(subTitle))"
            } else {
                valueLabel.text = dataSources[selectedIndex].title
            }
            
            delegate?.kaiCombobox(self, didSelectIndex: selectedIndex)
            removeTransparentView()
        }
    }
    
    weak var delegate: KAIComboboxDelegate?
    
    // MARK: Life cycle's
    init(with dataSources: [ComboboxData] = [], frame: CGRect = .zero) {
        self.dataSources = dataSources
        
        super.init(frame: frame)
        
        if let first = dataSources.first {
            if let subTitle = first.subTitle {
                valueLabel.text = "\(first.title) (\(subTitle))"
            } else {
                valueLabel.text = first.title
            }
        } else {
            valueLabel.text = "Option"
        }
        
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    func setupView() {
        addSubview(selectedButton)
        addSubview(valueLabel)
        addSubview(dropdownImageView)
        
        NSLayoutConstraint.activate([
            selectedButton.topAnchor.constraint(equalTo: topAnchor),
            selectedButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectedButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectedButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectedButton.heightAnchor.constraint(equalToConstant: 44),
            
            valueLabel.centerYAnchor.constraint(equalTo: selectedButton.centerYAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: selectedButton.leadingAnchor, constant: 16),
            
            dropdownImageView.centerYAnchor.constraint(equalTo: selectedButton.centerYAnchor),
            dropdownImageView.leadingAnchor.constraint(greaterThanOrEqualTo: valueLabel.trailingAnchor, constant: 8),
            dropdownImageView.trailingAnchor.constraint(equalTo: selectedButton.trailingAnchor, constant: -14),
            dropdownImageView.widthAnchor.constraint(equalToConstant: 16),
            dropdownImageView.heightAnchor.constraint(equalToConstant: 16),
        ])
    }
    
    private func addTransparentView() {
        let frames: CGRect = selectedButton.convert(selectedButton.frame, to: nil)
        let window = Navigator.window
        transparentView.frame = window?.frame ?? CGRect(origin: .zero, size: Constants.Device.screenBounds.size)
        window?.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        window?.addSubview(tableView)
        tableView.layer.cornerRadius = 8
        tableView.createShadow(radius: 8)
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        let margin: CGFloat = tableView.contentInset.left + tableView.contentInset.right
        let height: CGFloat = CGFloat(dataSources.count) * itemHeight + margin
        let maxHeight: CGFloat = (maxItemShow * itemHeight) + margin
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: height > maxHeight ? maxHeight : height)
            self.dropdownImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion: nil)
    }
    
    // MARK: Methods
    func configure(with dataSources: [ComboboxData]) {
        self.dataSources = dataSources
        self.tableView.reloadData()
    }
    
    // MARK: Handle actions
    @objc func removeTransparentView() {
        let frames: CGRect = selectedButton.convert(selectedButton.frame, to: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
            self.dropdownImageView.transform = CGAffineTransform.identity
        }, completion: { finish in
            self.tableView.removeFromSuperview()
            self.transparentView.removeFromSuperview()
        })
    }
    
    @objc private func onPressedDropdown() {
        addTransparentView()
        Navigator.window?.endEditing(true)
    }
}

// MARK: UITableViewDataSource
extension KAICombobox: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ComboboxTableViewCell.identifier, for: indexPath) as! ComboboxTableViewCell
        cell.configure(with: dataSources[indexPath.row].title, and: dataSources[indexPath.row].subTitle)
        cell.isDropdownSelected = selectedIndex == indexPath.row
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension KAICombobox: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
}

class ComboboxTableViewCell: UITableViewCell {
    
    // MARK: Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.workSansFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.workSansFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.black.withAlphaComponent(0.54)
        
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    var isDropdownSelected: Bool = false {
        didSet {
            if isDropdownSelected {
                containerView.backgroundColor = .init(hex: "F7F8F9")
                titleLabel.textColor = UIColor.black.withAlphaComponent(0.87)
            } else {
                containerView.backgroundColor = nil
                titleLabel.textColor = UIColor.black.withAlphaComponent(0.54)
            }
        }
    }
    
    // MARK: Life cycle's
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(subTitleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subTitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            subTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }
    
    // MARK: Methods
    func configure(with title: String, and subTitle: String? = nil) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
