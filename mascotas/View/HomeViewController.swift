//
//  HomeViewController.swift
//  mascotas
//
//  Created by ruizvi | VIDAL RUIZ VARGAS on 26/04/25.
//
// HomeViewController.swift
import UIKit

class HomeViewController: UIViewController {
    
    private let viewMascotasButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ver Mascotas", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let viewResponsablesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ver Responsables", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Inicio"
        
        setupLayout()
        setupActions()
    }
    
    private func setupLayout() {
        view.addSubview(viewMascotasButton)
        view.addSubview(viewResponsablesButton)
        
        NSLayoutConstraint.activate([
            viewMascotasButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewMascotasButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            viewResponsablesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewResponsablesButton.topAnchor.constraint(equalTo: viewMascotasButton.bottomAnchor, constant: 20)
        ])
    }
    
    private func setupActions() {
        viewMascotasButton.addTarget(self, action: #selector(didTapViewMascotas), for: .touchUpInside)
        viewResponsablesButton.addTarget(self, action: #selector(didTapViewResponsables), for: .touchUpInside)
    }
    
    @objc private func didTapViewMascotas() {
        let mascotasVC = MascotasListViewController()
        navigationController?.pushViewController(mascotasVC, animated: true)
    }
    @objc private func didTapViewResponsables() {
        let responsablesVC = ResponsablesListViewController()
        navigationController?.pushViewController(responsablesVC, animated: true)
    }
}
