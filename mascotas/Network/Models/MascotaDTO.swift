//
//  MascotaDTO.swift
//  mascotas
//
//  Created by ruizvi | VIDAL RUIZ VARGAS on 26/04/25.
//

// MascotaDTO.swift
import Foundation

struct MascotaDTO: Codable {
    let id: Int
    let nombre: String
    let tipo: String
    let genero: String
    let edad: Double
}
