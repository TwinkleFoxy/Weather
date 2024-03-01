//
//  FavouriteViewController.swift
//  Weather
//
//  Created by Алексей Однолько on 20.02.2024.
//

import UIKit
import RxSwift
import RxRelay

final class FavouriteViewController: BaseViewController {
    
    //MARK: - UI
    private lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a query"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var refreshControl = UIRefreshControl()
    
    
    //MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel = FavouriteViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupUI()
        setupTheme()
        bind()
    }
    
    func setupUI() {
        view.addSubview(searchField)
        view.addSubview(tableView)
        
        searchField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func bind() {
        searchField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(searchField.rx.text)
            .bind { [weak self] in self?.viewModel.searchQuery.accept($0 ?? "") }
            .disposed(by: bag)
        
        
        viewModel.weatherDataForPrisent
            .bind(to: tableView.rx.items(cellType: WeatherTableViewCell.self)) {
                $2.configure(weatherCell: $1)
            }
            .disposed(by: bag)
        
        tableView.rx.contentOffset
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMap { [weak self] (contentOffset) -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                let tableViewHeight = self.tableView.frame.size.height
                let contentSize = self.tableView.contentSize.height
                let offset = contentOffset.y + tableViewHeight
                if offset >= contentSize - 150 {
                    return Observable.just(())
                } else {
                    return Observable.empty()
                }
            }
            .bind { [weak self] _ in
                self?.viewModel.uplateData.accept(.loadMore)
            }
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .bind { [weak self] indexPath in
                let selectedWeather = self?.viewModel.weatherDataForPrisent.value[indexPath.row]
                
                let detailViewController = DetailViewController(forecast: selectedWeather?.location.name ?? "")
                
                self?.navigationController?.pushViewController(detailViewController, animated: true)
                
            }
            .disposed(by: bag)
        
        
        viewModel.weatherDataForPrisent
            .bind { [weak self] _ in
                self?.refreshControl.endRefreshing()
            }
            .disposed(by: bag)
    }
    
    // Светлая тема
    override func setupLightTheme() {
        super.setupLightTheme()
        tableView.backgroundColor = .white
        searchField.backgroundColor = nil
        searchField.textColor = .black
        searchField.tintColor = .red
        refreshControl.tintColor = .gray
        let lightPlaceholderColor = UIColor.gray.withAlphaComponent(0.5)
        searchField.attributedPlaceholder = NSAttributedString(string: "Enter a query",
                                                            attributes: [NSAttributedString.Key.foregroundColor: lightPlaceholderColor])
    }
    
    // Темная тема
    override func setupDarkTheme() {
        super.setupDarkTheme()
        tableView.backgroundColor = .black
        searchField.backgroundColor = .darkGray
        searchField.textColor = .white
        refreshControl.tintColor = .white
        let darkPlaceholderColor = UIColor.lightGray.withAlphaComponent(0.5)
        searchField.attributedPlaceholder = NSAttributedString(string: "Enter a query",
                                                            attributes: [NSAttributedString.Key.foregroundColor: darkPlaceholderColor])
    }
}

extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}


private extension FavouriteViewController {
    @objc private func refreshData() {
        searchField.rx.text.onNext("")
        viewModel.uplateData.accept(.pullToRefresh)
    }
}
