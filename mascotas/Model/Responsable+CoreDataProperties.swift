//
//  Responsable+CoreDataProperties.swift
//  mascotas
//
//  Created by ruizvi | VIDAL RUIZ VARGAS on 26/04/25.
//
//

import Foundation
import CoreData


extension Responsable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Responsable> {
        return NSFetchRequest<Responsable>(entityName: "Responsable")
    }

    @NSManaged public var apellido_materno: String?
    @NSManaged public var apellido_paterno: String?
    @NSManaged public var ciudad: String?
    @NSManaged public var dueno_de: Int16
    @NSManaged public var email: String?
    @NSManaged public var estado: String?
    @NSManaged public var nombre: String?
    @NSManaged public var tel: String?
    @NSManaged public var mascotas: NSSet?

}

// MARK: Generated accessors for mascotas
extension Responsable {

    @objc(addMascotasObject:)
    @NSManaged public func addToMascotas(_ value: Mascota)

    @objc(removeMascotasObject:)
    @NSManaged public func removeFromMascotas(_ value: Mascota)

    @objc(addMascotas:)
    @NSManaged public func addToMascotas(_ values: NSSet)

    @objc(removeMascotas:)
    @NSManaged public func removeFromMascotas(_ values: NSSet)

}

extension Responsable : Identifiable {

}
