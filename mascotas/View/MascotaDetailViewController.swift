import UIKit

class MascotaDetailViewController: UITableViewController {
    
    var mascota: MascotaDTO?
    var responsable: ResponsableDTO?
    
    private let mascotaSection = 0
    private let responsableSection = 1

    init(mascota: MascotaDTO) {
        self.mascota = mascota
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = mascota?.nombre ?? "Detalle"
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        if let mascota = mascota {
            responsable = DataManager.shared.responsable(forMascota: mascota)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case mascotaSection:
            return 5 // Ahora 5 filas: ID + Nombre + Tipo + Género + Edad
        case responsableSection:
            return responsable != nil ? 2 : 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case mascotaSection:
            return "Información de la Mascota"
        case responsableSection:
            return "Responsable"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        switch indexPath.section {
        case mascotaSection:
            switch indexPath.row {
            case 0:
                content.image = UIImage(systemName: "number.circle.fill")
                content.text = "ID Mascota: \(mascota?.id ?? 0)"
            case 1:
                content.image = UIImage(systemName: "pawprint")
                content.text = "Nombre: \(mascota?.nombre ?? "-")"
            case 2:
                content.image = UIImage(systemName: "tortoise.fill")
                content.text = "Tipo: \(mascota?.tipo ?? "-")"
            case 3:
                content.image = UIImage(systemName: "person.fill")
                let genero = mascota?.genero == "M" ? "Macho" : "Hembra"
                content.text = "Género: \(genero)"
            case 4:
                content.image = UIImage(systemName: "calendar")
                if let edad = mascota?.edad {
                    content.text = String(format: "Edad: %.1f años", edad)
                } else {
                    content.text = "Edad: -"
                }
            default:
                break
            }
            content.imageProperties.tintColor = .systemBlue
            content.textProperties.color = .label
            
        case responsableSection:
            guard let responsable = responsable else { break }
            switch indexPath.row {
            case 0:
                content.image = UIImage(systemName: "person.crop.circle")
                content.text = "Nombre: \(responsable.nombre)"
            case 1:
                content.image = UIImage(systemName: "envelope.fill")
                content.text = "Email: \(responsable.email)"
            default:
                break
            }
            content.imageProperties.tintColor = .systemGreen
            content.textProperties.color = .label
            
        default:
            break
        }
        
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == responsableSection, let responsable = responsable {
            let vc = ResponsableDetailViewController(responsable: responsable)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
