import UIKit

class ResponsableDetailViewController: UITableViewController {
    
    private let responsable: ResponsableDTO
    private var mascotas: [MascotaDTO] = []
    
    private let datosResponsableSection = 0
    private let mascotasSection = 1
    
    init(responsable: ResponsableDTO) {
        self.responsable = responsable
        super.init(style: .grouped)
        title = responsable.nombre
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .systemGroupedBackground
        
        // Cargar mascotas
        mascotas = DataManager.shared.mascotas(forResponsable: responsable)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case datosResponsableSection:
            return 5  // Ahora son 5 datos (ID + nombre + email + teléfono + ciudad)
        case mascotasSection:
            return mascotas.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case datosResponsableSection:
            return "Información del Responsable"
        case mascotasSection:
            return "Mascotas a su cargo"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        switch indexPath.section {
        case datosResponsableSection:
            switch indexPath.row {
            case 0:
                content.image = UIImage(systemName: "number.circle.fill")
                content.text = "ID Responsable: \(responsable.dueno_de ?? 0)"
            case 1:
                content.image = UIImage(systemName: "person.crop.circle")
                content.text = "Nombre: \(responsable.nombre) \(responsable.apellido_paterno) \(responsable.apellido_materno)"
            case 2:
                content.image = UIImage(systemName: "envelope.fill")
                content.text = "Email: \(responsable.email)"
            case 3:
                content.image = UIImage(systemName: "phone.fill")
                content.text = "Teléfono: \(responsable.tel)"
            case 4:
                content.image = UIImage(systemName: "building.2.fill")
                content.text = "Ciudad: \(responsable.ciudad), \(responsable.estado)"
            default:
                break
            }
            content.imageProperties.tintColor = .systemBlue
            content.textProperties.color = .label
            
        case mascotasSection:
            let mascota = mascotas[indexPath.row]
            content.image = UIImage(systemName: "pawprint.fill")
            content.text = mascota.nombre
            content.secondaryText = "\(mascota.tipo) - \(mascota.edad) años"
            content.imageProperties.tintColor = .systemGreen
            content.textProperties.color = .label
            content.secondaryTextProperties.color = .secondaryLabel
            
        default:
            break
        }
        
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == mascotasSection && mascotas.isEmpty {
            return "Este responsable no tiene mascotas asignadas actualmente."
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == mascotasSection {
            let mascota = mascotas[indexPath.row]
            let vc = MascotaDetailViewController(mascota: mascota)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
