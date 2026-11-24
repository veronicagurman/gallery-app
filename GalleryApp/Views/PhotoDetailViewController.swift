import UIKit

final class PhotoDetailViewController: UIViewController {
    private let viewModel: PhotoDetailViewModel

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let imageView = UIImageView()
    private let authorLabel = UILabel()
    private let likesLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let spinner = UIActivityIndicatorView(style: .large)
    private var imageHeightConstraint: NSLayoutConstraint?
    private var loadTask: Task<Void, Never>?

    init(viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        setupFavoriteButton()
        setupLayout()
        configure()
        loadImage()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            loadTask?.cancel()
        }
    }

    private func setupFavoriteButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(favoriteTapped)
        )
    }

    @objc private func favoriteTapped() {
      
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .secondarySystemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false

        authorLabel.font = .preferredFont(forTextStyle: .title2)
        authorLabel.adjustsFontForContentSizeCategory = true
        authorLabel.numberOfLines = 0

        likesLabel.font = .preferredFont(forTextStyle: .subheadline)
        likesLabel.textColor = .secondaryLabel

        descriptionLabel.font = .preferredFont(forTextStyle: .body)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.numberOfLines = 0

        let textStack = UIStackView(arrangedSubviews: [authorLabel, likesLabel, descriptionLabel])
        textStack.axis = .vertical
        textStack.spacing = 8
        textStack.isLayoutMarginsRelativeArrangement = true
        textStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)

        contentStack.addArrangedSubview(imageView)
        contentStack.addArrangedSubview(textStack)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(spinner)

        let heightConstraint = imageView.heightAnchor.constraint(
            equalTo: imageView.widthAnchor,
            multiplier: 0.75
        )
        imageHeightConstraint = heightConstraint

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            heightConstraint,
            spinner.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }

    private func configure() {
        authorLabel.text = viewModel.authorText
        likesLabel.text = viewModel.likesText
        descriptionLabel.text = viewModel.descriptionText
    }

    private func loadImage() {
        spinner.startAnimating()
        loadTask = Task { [weak self] in
            guard let self else { return }

            if let small = await ImageLoader.shared.load(from: viewModel.placeholderURLString) {
                guard !Task.isCancelled else { return }
                show(small)
                spinner.stopAnimating()
            }

            let full = await ImageLoader.shared.load(from: viewModel.imageURLString)
            guard !Task.isCancelled else { return }
            spinner.stopAnimating()
            if let full {
                show(full)
            }
        }
    }

    private func show(_ image: UIImage) {
        imageHeightConstraint?.isActive = false
        let ratio = image.size.height / image.size.width
        let newConstraint = imageView.heightAnchor.constraint(
            equalTo: imageView.widthAnchor,
            multiplier: ratio
        )
        newConstraint.isActive = true
        imageHeightConstraint = newConstraint
        imageView.image = image
    }
}
