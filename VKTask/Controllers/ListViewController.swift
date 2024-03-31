import Foundation
import UIKit
import PinLayout

final class ListViewController: UIViewController {
    
    //MARK: Vars
    
    private var services = [ServiceDisplayModel]()
    
    private let networkManager: NetworkManagerProtocol
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .black
        table.estimatedRowHeight = 600
        table.rowHeight = UITableView.automaticDimension
        table.showsVerticalScrollIndicator = false
        table.register(ServiceCell.self, forCellReuseIdentifier: ServiceCell.reuseId)
        return table
    }()
    
    //MARK: Init
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        addSubviews()
        loadServices()
    }
    
    private func setupAppearance() {
        view.backgroundColor = .black
        title = "Сервисы"
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.overrideUserInterfaceStyle = .dark
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func loadServices() {
        NetworkManager().getServices { [weak self] result in
            switch result {
            case .success(let services):
                self?.services = services.map({ ServiceDisplayModel(name: $0.name, description: $0.description, link: $0.link, icon_url: $0.icon_url) })
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.pin.top().bottom().horizontally(view.pin.safeArea)
    }
    
}

//MARK: UITableViewDelegate, UITableViewDataSource

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServiceCell.reuseId, for: indexPath) as! ServiceCell
        
        cell.setup(model: services[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        UIApplication.shared.open(services[indexPath.row].link)
    }
    
}
