import UIKit

class MascotasListViewController: UIViewController {

    private var mascotas: [MascotaDTO] = []
    private var filteredMascotas: [MascotaDTO] = []
    private var isSearching = false

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MascotaCell")
        return tableView
    }()

    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mascotas"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupSearchController()
        fetchMascotas()
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
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar mascota"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func fetchMascotas() {
        Task {
            do {
                self.mascotas = try await APIService.shared.fetchMascotas()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error al traer mascotas: \(error.localizedDescription)")
            }
        }
    }
}

extension MascotasListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredMascotas.count : mascotas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mascota = isSearching ? filteredMascotas[indexPath.row] : mascotas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MascotaCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(systemName: "pawprint.fill")
        content.text = mascota.nombre
        content.secondaryText = "\(mascota.tipo) - \(String(format: "%.1f", mascota.edad)) años"
        content.imageProperties.tintColor = .systemTeal
        content.textProperties.color = .label
        
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mascotaSeleccionada = isSearching ? filteredMascotas[indexPath.row] : mascotas[indexPath.row]
        let detailVC = MascotaDetailViewController(mascota: mascotaSeleccionada)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MascotasListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.lowercased(), !query.isEmpty else {
            isSearching = false
            tableView.reloadData()
            return
        }
        isSearching = true
        filteredMascotas = mascotas.filter { $0.nombre.lowercased().contains(query) }
        tableView.reloadData()
    }
}
