//
//  DataManager.swift
//  mascotas
//
//  Created by ruizvi | VIDAL RUIZ VARGAS on 26/04/25.
//

// DataManager.swift
import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    private init() {}
    
    private(set) var mascotas: [MascotaDTO] = []
    private(set) var responsables: [ResponsableDTO] = []
    
    func setMascotas(_ mascotas: [MascotaDTO]) {
        self.mascotas = mascotas
    }
    
    func setResponsables(_ responsables: [ResponsableDTO]) {
        self.responsables = responsables
    }
    
    func responsable(forMascota mascota: MascotaDTO) -> ResponsableDTO? {
        return responsables.first(where: { $0.dueno_de == mascota.id })
    }
    
    func mascota(forResponsable responsable: ResponsableDTO) -> MascotaDTO? {
        guard let mascotaId = responsable.dueno_de else { return nil }
        return mascotas.first(where: { $0.id == mascotaId })
    }
    func mascotas(forResponsable responsable: ResponsableDTO) -> [MascotaDTO] {
        guard let mascotaId = responsable.dueno_de else { return [] }
        return mascotas.filter { $0.id == mascotaId }
    }
}
