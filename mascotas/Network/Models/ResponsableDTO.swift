//
//  ResponsableDTO\.swift
//  mascotas
//
//  Created by ruizvi | VIDAL RUIZ VARGAS on 26/04/25.
//

// ResponsableDTO.swift
import Foundation

struct ResponsableDTO: Codable {
    let nombre: String
    let apellido_paterno: String
    let apellido_materno: String
    let ciudad: String
    let estado: String
    let email: String
    let tel: String
    let dueno_de: Int?

    enum CodingKeys: String, CodingKey {
        case nombre
        case apellido_paterno
        case apellido_materno
        case ciudad
        case estado
        case email
        case tel
        case dueno_de = "dueno_de" // Corrección porque viene mal codificado desde el endpoint
    }
}
