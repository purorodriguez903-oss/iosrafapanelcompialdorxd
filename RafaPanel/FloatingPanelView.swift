import UIKit

class FloatingPanelView: UIView {

    let checkbox1 = CheckboxControl(title: "Checkbox 1", initialValue: false)
    let checkbox2 = CheckboxControl(title: "Checkbox 2", initialValue: false)

    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    private let dragIndicator = UIView()
    private let minimizeButton = UIButton(type: .system)
    private let contentStack = UIStackView()

    private var isMinimized: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupPanGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor(red: 0.08, green: 0.10, blue: 0.15, alpha: 0.92)
        layer.cornerRadius = 16
        layer.borderWidth = 1.2
        layer.borderColor = UIColor.systemCyan.withAlphaComponent(0.6).cgColor

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 12

        // Drag handle indicator
        dragIndicator.translatesAutoresizingMaskIntoConstraints = false
        dragIndicator.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        dragIndicator.layer.cornerRadius = 2
        addSubview(dragIndicator)

        // Header view
        headerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "⚡ PANEL RAFA"
        titleLabel.textColor = .systemCyan
        titleLabel.font = .boldSystemFont(ofSize: 14)
        headerView.addSubview(titleLabel)

        minimizeButton.translatesAutoresizingMaskIntoConstraints = false
        minimizeButton.setTitle("—", for: .normal)
        minimizeButton.setTitleColor(.white, for: .normal)
        minimizeButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        minimizeButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        minimizeButton.layer.cornerRadius = 12
        minimizeButton.addTarget(self, action: #selector(toggleMinimize), for: .touchUpInside)
        headerView.addSubview(minimizeButton)

        // Content Stack
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 10
        contentStack.distribution = .fill
        addSubview(contentStack)

        contentStack.addArrangedSubview(checkbox1)
        contentStack.addArrangedSubview(checkbox2)

        // Status Label
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.text = "Estado: C1 [OFF] | C2 [OFF]"
        statusLabel.textColor = UIColor.lightGray
        statusLabel.font = .systemFont(ofSize: 11, weight: .regular)
        statusLabel.textAlignment = .center
        contentStack.addArrangedSubview(statusLabel)

        checkbox1.onValueChanged = { [weak self] val in
            self?.updateStatusText()
        }

        checkbox2.onValueChanged = { [weak self] val in
            self?.updateStatusText()
        }

        NSLayoutConstraint.activate([
            dragIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            dragIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            dragIndicator.widthAnchor.constraint(equalToConstant: 36),
            dragIndicator.heightAnchor.constraint(equalToConstant: 4),

            headerView.topAnchor.constraint(equalTo: dragIndicator.bottomAnchor, constant: 6),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            headerView.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            minimizeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            minimizeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            minimizeButton.widthAnchor.constraint(equalToConstant: 24),
            minimizeButton.heightAnchor.constraint(equalToConstant: 24),

            contentStack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12)
        ])
    }

    private func updateStatusText() {
        let c1 = checkbox1.isOn ? "ON" : "OFF"
        let c2 = checkbox2.isOn ? "ON" : "OFF"
        statusLabel.text = "Estado: C1 [\(c1)] | C2 [\(c2)]"
    }

    @objc private func toggleMinimize() {
        isMinimized.toggle()
        UIView.animate(withDuration: 0.25) {
            self.contentStack.isHidden = self.isMinimized
            self.minimizeButton.setTitle(self.isMinimized ? "+" : "—", for: .normal)
            if self.isMinimized {
                self.frame.size.height = 54
            } else {
                self.frame.size.height = 195
            }
        }
    }

    // MARK: - Arrastre libre por cualquier lado de la pantalla
    private func setupPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(pan)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let superview = self.superview else { return }

        let translation = gesture.translation(in: superview)
        var newCenter = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)

        // Limitar dentro de los bordes de la pantalla (Safe Area)
        let halfWidth = self.bounds.width / 2
        let halfHeight = self.bounds.height / 2
        let minX = superview.safeAreaInsets.left + halfWidth
        let maxX = superview.bounds.width - superview.safeAreaInsets.right - halfWidth
        let minY = superview.safeAreaInsets.top + halfHeight
        let maxY = superview.bounds.height - superview.safeAreaInsets.bottom - halfHeight

        newCenter.x = max(minX, min(newCenter.x, maxX))
        newCenter.y = max(minY, min(newCenter.y, maxY))

        self.center = newCenter
        gesture.setTranslation(.zero, in: superview)
    }
}
