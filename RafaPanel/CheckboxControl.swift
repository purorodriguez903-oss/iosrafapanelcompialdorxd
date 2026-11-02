import UIKit

class CheckboxControl: UIView {

    var isOn: Bool = false {
        didSet {
            updateVisualState()
        }
    }

    var onValueChanged: ((Bool) -> Void)?

    private let boxView = UIView()
    private let checkLabel = UILabel()
    private let titleLabel = UILabel()
    private let badgeLabel = UILabel()
    private let feedback = UIImpactFeedbackGenerator(style: .medium)

    init(title: String, initialValue: Bool = false) {
        super.init(frame: .zero)
        self.isOn = initialValue
        setupUI(title: title)
        updateVisualState()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(title: String) {
        backgroundColor = UIColor.white.withAlphaComponent(0.06)
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor

        // Checkbox box
        boxView.translatesAutoresizingMaskIntoConstraints = false
        boxView.layer.cornerRadius = 6
        boxView.layer.borderWidth = 2
        addSubview(boxView)

        // Check icon
        checkLabel.translatesAutoresizingMaskIntoConstraints = false
        checkLabel.text = "✓"
        checkLabel.font = .boldSystemFont(ofSize: 14)
        checkLabel.textColor = .black
        checkLabel.textAlignment = .center
        boxView.addSubview(checkLabel)

        // Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        addSubview(titleLabel)

        // Badge ON/OFF
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.font = .boldSystemFont(ofSize: 11)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 6
        badgeLabel.clipsToBounds = true
        addSubview(badgeLabel)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 44),

            boxView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            boxView.centerYAnchor.constraint(equalTo: centerYAnchor),
            boxView.widthAnchor.constraint(equalToConstant: 22),
            boxView.heightAnchor.constraint(equalToConstant: 22),

            checkLabel.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
            checkLabel.centerYAnchor.constraint(equalTo: boxView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: badgeLabel.leadingAnchor, constant: -8),

            badgeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            badgeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            badgeLabel.widthAnchor.constraint(equalToConstant: 44),
            badgeLabel.heightAnchor.constraint(equalToConstant: 22)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleTapped))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    @objc private func toggleTapped() {
        feedback.impactOccurred()
        isOn.toggle()
        onValueChanged?(isOn)

        // Animación de pulso
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        }
    }

    private func updateVisualState() {
        if isOn {
            boxView.backgroundColor = UIColor.systemGreen
            boxView.layer.borderColor = UIColor.systemGreen.cgColor
            checkLabel.isHidden = false
            badgeLabel.text = "ON"
            badgeLabel.textColor = .white
            badgeLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.85)
            layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.5).cgColor
        } else {
            boxView.backgroundColor = .clear
            boxView.layer.borderColor = UIColor.lightGray.cgColor
            checkLabel.isHidden = true
            badgeLabel.text = "OFF"
            badgeLabel.textColor = UIColor.lightGray
            badgeLabel.backgroundColor = UIColor.white.withAlphaComponent(0.08)
            layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
        }
    }
}
