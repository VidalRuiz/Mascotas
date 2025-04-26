//
//  APIService.swift
//  mascotas
//
//  Created by ruizvi | VIDAL RUIZ VARGAS on 26/04/25.
//

// APIService.swift
// APIService.swift
import Foundation

class APIService {
    static let shared = APIService()
    
    private init() {}

    private let mascotasURL = URL(string: "https://my.api.mockaroo.com/mascotas.json?key=ee082920")!
    private let responsablesURL = URL(string: "https://my.api.mockaroo.com/responsables.json?key=ee082920")!
    func fetchMascotas() async -> [MascotaDTO] {
        if NetworkMonitor.shared.isConnected {
            // Hay Internet, intentamos API
            do {
                let (data, _) = try await URLSession.shared.data(from: mascotasURL)
                let decoder = JSONDecoder()
                let mascotas = try decoder.decode([MascotaDTO].self, from: data)
                
                CoreDataService.shared.saveMascotas(mascotas)
                DataManager.shared.setMascotas(mascotas)
                
                return mascotas
            } catch {
                print("Error al descargar mascotas: \(error.localizedDescription)")
                // Falló API, leer de CoreData
                let mascotasLocales = CoreDataService.shared.fetchMascotas()
                DataManager.shared.setMascotas(mascotasLocales)
                return mascotasLocales
            }
        }
        
        else {
            // 🚫 No hay Internet, directamente leemos de CoreData
            print("Sin conexión. Leyendo mascotas locales...")
            let mascotasLocales = CoreDataService.shared.fetchMascotas()
            DataManager.shared.setMascotas(mascotasLocales)
            return mascotasLocales
        }
    }
   
    
    func fetchResponsables() async -> [ResponsableDTO] {
        if NetworkMonitor.shared.isConnected {
            do {
                let (data, _) = try await URLSession.shared.data(from: responsablesURL)
                let decoder = JSONDecoder()
                let responsables = try decoder.decode([ResponsableDTO].self, from: data)
                
                CoreDataService.shared.saveResponsables(responsables)
                DataManager.shared.setResponsables(responsables)
                
                return responsables
            } catch {
                print("Error al descargar responsables: \(error.localizedDescription)")
                let responsablesLocales = CoreDataService.shared.fetchResponsables()
                DataManager.shared.setResponsables(responsablesLocales)
                return responsablesLocales
            }
        } else {
            print("Sin conexión. Leyendo responsables locales...")
            let responsablesLocales = CoreDataService.shared.fetchResponsables()
            DataManager.shared.setResponsables(responsablesLocales)
            return responsablesLocales
        }
    }

}
