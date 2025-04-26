import UIKit

class ResponsablesListViewController: UIViewController {

    private var responsables: [ResponsableDTO] = []
    private var responsablesFiltrados: [ResponsableDTO] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResponsableCell")
        return tableView
    }()
    
    private var isSearching: Bool {
        return !(navigationItem.searchController?.searchBar.text?.isEmpty ?? true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Responsables"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupSearchController()
        fetchResponsables()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar responsable"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func fetchResponsables() {
        Task {
            do {
                self.responsables = try await APIService.shared.fetchResponsables()
                self.tableView.reloadData()
            } catch {
                print("Error al traer responsables: \(error.localizedDescription)")
            }
        }
    }
}

extension ResponsablesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? responsablesFiltrados.count : responsables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let responsable = isSearching ? responsablesFiltrados[indexPath.row] : responsables[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResponsableCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(systemName: "person.circle.fill")
        content.imageProperties.tintColor = .systemBlue
        content.text = "\(responsable.nombre) \(responsable.apellido_paterno)"
        content.secondaryText = responsable.email
        content.textProperties.font = .systemFont(ofSize: 18, weight: .medium)
        content.secondaryTextProperties.font = .systemFont(ofSize: 14)
        content.secondaryTextProperties.color = .secondaryLabel
        
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let responsableSeleccionado = isSearching ? responsablesFiltrados[indexPath.row] : responsables[indexPath.row]
        let detailVC = ResponsableDetailViewController(responsable: responsableSeleccionado)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ResponsablesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText.isEmpty {
            responsablesFiltrados = []
        } else {
            responsablesFiltrados = responsables.filter {
                $0.nombre.localizedCaseInsensitiveContains(searchText) ||
                $0.apellido_paterno.localizedCaseInsensitiveContains(searchText) ||
                $0.email.localizedCaseInsensitiveContains(searchText)
            }
        }
        tableView.reloadData()
    }
}
