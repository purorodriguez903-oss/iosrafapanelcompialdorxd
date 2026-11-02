import UIKit

class ViewController: UIViewController {

    private var floatingPanel: FloatingPanelView?
    private let ffButton = UIButton(type: .system)
    private let togglePanelButton = UIButton(type: .system)
    private let statusCard = UIView()
    private let statusText = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupMainUI()
        setupFloatingPanel()
    }

    private func setupBackground() {
        view.backgroundColor = UIColor(red: 0.05, green: 0.07, blue: 0.11, alpha: 1.0)

        // Gradiente sutil
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.10, green: 0.14, blue: 0.22, alpha: 1.0).cgColor,
            UIColor(red: 0.04, green: 0.05, blue: 0.08, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupMainUI() {
        // Encabezado
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "RAFA PANEL"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 28, weight: .heavy)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "Free Fire Launcher & Floating Controls"
        subtitleLabel.textColor = .systemCyan
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textAlignment = .center
        view.addSubview(subtitleLabel)

        // Botón principal: Free Fire Normal
        ffButton.translatesAutoresizingMaskIntoConstraints = false
        ffButton.setTitle("🔥 FREE FIRE NORMAL", for: .normal)
        ffButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        ffButton.setTitleColor(.white, for: .normal)
        ffButton.backgroundColor = UIColor(red: 0.95, green: 0.35, blue: 0.12, alpha: 1.0) // Naranja fuego
        ffButton.layer.cornerRadius = 14
        ffButton.layer.shadowColor = UIColor.systemOrange.cgColor
        ffButton.layer.shadowOpacity = 0.5
        ffButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        ffButton.layer.shadowRadius = 8
        ffButton.addTarget(self, action: #selector(openFreeFireTapped), for: .touchUpInside)
        view.addSubview(ffButton)

        // Botón secundario: Mostrar/Ocultar Panel
        togglePanelButton.translatesAutoresizingMaskIntoConstraints = false
        togglePanelButton.setTitle("👁 MOSTRAR / OCULTAR PANEL", for: .normal)
        togglePanelButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        togglePanelButton.setTitleColor(.systemCyan, for: .normal)
        togglePanelButton.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        togglePanelButton.layer.cornerRadius = 10
        togglePanelButton.layer.borderWidth = 1
        togglePanelButton.layer.borderColor = UIColor.systemCyan.withAlphaComponent(0.4).cgColor
        togglePanelButton.addTarget(self, action: #selector(togglePanelVisibility), for: .touchUpInside)
        view.addSubview(togglePanelButton)

        // Tarjeta informativa inferior
        statusCard.translatesAutoresizingMaskIntoConstraints = false
        statusCard.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        statusCard.layer.cornerRadius = 12
        statusCard.layer.borderWidth = 1
        statusCard.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        view.addSubview(statusCard)

        statusText.translatesAutoresizingMaskIntoConstraints = false
        statusText.text = "💡 Toca y arrastra el panel flotante a cualquier lado de la pantalla. Activa los checkboxes tocando sobre ellos (ON / OFF)."
        statusText.textColor = UIColor.lightGray
        statusText.font = .systemFont(ofSize: 12)
        statusText.numberOfLines = 0
        statusText.textAlignment = .center
        statusCard.addSubview(statusText)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            ffButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ffButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            ffButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            ffButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            ffButton.heightAnchor.constraint(equalToConstant: 54),

            togglePanelButton.topAnchor.constraint(equalTo: ffButton.bottomAnchor, constant: 18),
            togglePanelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            togglePanelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            togglePanelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            togglePanelButton.heightAnchor.constraint(equalToConstant: 42),

            statusCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            statusCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            statusCard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),

            statusText.topAnchor.constraint(equalTo: statusCard.topAnchor, constant: 12),
            statusText.leadingAnchor.constraint(equalTo: statusCard.leadingAnchor, constant: 14),
            statusText.trailingAnchor.constraint(equalTo: statusCard.trailingAnchor, constant: -14),
            statusText.bottomAnchor.constraint(equalTo: statusCard.bottomAnchor, constant: -12)
        ])
    }

    private func setupFloatingPanel() {
        let panel = FloatingPanelView(frame: CGRect(x: 24, y: 140, width: 220, height: 195))
        view.addSubview(panel)
        self.floatingPanel = panel
    }

    @objc private func openFreeFireTapped() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()

        // Mostrar panel si estaba oculto
        if let panel = floatingPanel {
            panel.isHidden = false
            view.bringSubviewToFront(panel)
        }

        // Esquemas URL conocidos de Free Fire en iOS
        let schemes = [
            "freefire://",
            "freefireth://",
            "freefiremax://"
        ]

        var opened = false
        for scheme in schemes {
            if let url = URL(string: scheme), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                opened = true
                break
            }
        }

        if !opened {
            // Si no está instalado o no se puede abrir el scheme
            let alert = UIAlertController(
                title: "Free Fire Normal",
                message: "Intentando conectar con Free Fire.\nSi el juego está instalado se abrirá automáticamente. El panel flotante ya está disponible en pantalla.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }

    @objc private func togglePanelVisibility() {
        guard let panel = floatingPanel else { return }
        UIView.animate(withDuration: 0.2) {
            panel.isHidden.toggle()
        }
    }
}
