//
//  CoreDataService.swift
//  mascotas
//
//  Created by ruizvi | VIDAL RUIZ VARGAS on 26/04/25.
//

// CoreDataService.swift
import Foundation
import CoreData
import UIKit

class CoreDataService {
    
    static let shared = CoreDataService()
    private init() {}

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Mascotas") // <-- nombre exacto de tu modelo .xcdatamodeld
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading persistent stores: \(error)")
            }
        }
        return container
    }()

    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Mascotas
    
    func saveMascotas(_ mascotas: [MascotaDTO]) {
        // Primero, limpia las mascotas actuales (opcional si quieres sobrescribir todo)
        deleteAllMascotas()
        
        for dto in mascotas {
            let mascota = Mascota(context: context)
            mascota.id = Int16(dto.id)
            mascota.nombre = dto.nombre
            mascota.tipo = dto.tipo
            mascota.genero = dto.genero
            mascota.edad = dto.edad
        }
        
        saveContext()
    }
    
    func fetchMascotas() -> [MascotaDTO] {
        let request: NSFetchRequest<Mascota> = Mascota.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results.map {
                MascotaDTO(id: Int($0.id),
                           nombre: $0.nombre ?? "",
                           tipo: $0.tipo ?? "",
                           genero: $0.genero ?? "",
                           edad: $0.edad)
            }
        } catch {
            print("Error fetching mascotas: \(error)")
            return []
        }
    }
    
    private func deleteAllMascotas() {
        let fetchRequest: NSFetchRequest<Mascota> = Mascota.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error deleting mascotas: \(error)")
        }
    }
    
    // MARK: - Responsables
    
    func saveResponsables(_ responsables: [ResponsableDTO]) {
        deleteAllResponsables()
        
        for dto in responsables {
            let responsable = Responsable(context: context)
            responsable.nombre = dto.nombre
            responsable.apellido_paterno = dto.apellido_paterno
            responsable.apellido_materno = dto.apellido_materno
            responsable.ciudad = dto.ciudad
            responsable.estado = dto.estado
            responsable.email = dto.email
            responsable.tel = dto.tel
            if let duenoId = dto.dueno_de {
                responsable.dueno_de = Int16(duenoId)
            }
        }
        
        saveContext()
    }
    
    func fetchResponsables() -> [ResponsableDTO] {
        let request: NSFetchRequest<Responsable> = Responsable.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results.map {
                ResponsableDTO(
                    nombre: $0.nombre ?? "",
                    apellido_paterno: $0.apellido_paterno ?? "",
                    apellido_materno: $0.apellido_materno ?? "",
                    ciudad: $0.ciudad ?? "",
                    estado: $0.estado ?? "",
                    email: $0.email ?? "",
                    tel: $0.tel ?? "",
                    dueno_de: $0.dueno_de == 0 ? nil : Int($0.dueno_de)
                )
            }
        } catch {
            print("Error fetching responsables: \(error)")
            return []
        }
    }
    
    private func deleteAllResponsables() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Responsable.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error deleting responsables: \(error)")
        }
    }
    
    // MARK: - Save Context
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
