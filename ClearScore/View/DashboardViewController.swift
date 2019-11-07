//
//  DashboardViewController.swift
//  ClearScore
//
//  Created by Eric Sans Alvarez on 02/11/2019.
//  Copyright © 2019 Eric Sans Alvarez. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var maxScoreLabel: UILabel!
    @IBOutlet weak var bandDescriptionLabel: UILabel!
    
    @IBOutlet weak var updateButton: UIButton!
    
    let dashboardViewModel: DashboardViewModel
    
    init(_ dashboardViewModel: DashboardViewModel) {
        self.dashboardViewModel = dashboardViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var scoreCount: Int = 0 {
        didSet {
            scoreLabel.text = "\(Int(scoreCount))"
            scoreLabel.textColor = currentColor
            
            if scoreCount == dashboardViewModel.score {
                bandDescriptionLabel.text = dashboardViewModel.bandDescription
                bandDescriptionLabel.isHidden = false
                updateButton.isHidden = false
            }
        }
    }
    
    var currentColor: UIColor = .orange
    
    var progressBar: ProgressBarView!
    
    // MARK: View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dashboardViewModel.delegate = self
        
        configureUI()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setup()
        
        dashboardViewModel.getAccount()
    }
    
    // MARK: Screen Set-up
    
    private func configureUI() {
        title = "Dashboard"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.barTintColor = .black
    }
    
    private func setup() {
        circleView.layer.borderColor = UIColor.black.cgColor
        circleView.layer.borderWidth = 1
        circleView.layer.cornerRadius = circleView.frame.height / 2
    }
    
    private func changeCurrentColor() {
        let colors = [UIColor.orange, UIColor.green, UIColor.blue]
        
        var index = 0
        
        // Define color segments for the progress bar in %
        
        if scoreCount < 700 * 55 / 100 { // 55% completed
            index = 0
        } else if scoreCount < 700 * 80 / 100 { // 80% completed
            index = 1
        } else {
            index = 2
        }
        
        currentColor = colors[index]
    }
    
    // MARK: - Actions
    
    @IBAction func updateCreditScore(_ sender: UIButton) {
        
        guard !spinnerView.isAnimating else { return }
        
        resetProgressBar()
        
        dashboardViewModel.getAccount()
    }
}

// MARK: Progress Bar

extension DashboardViewController {
    private func addProgressBar() {
        progressBar = ProgressBarView(frame: circleView.bounds)
        circleView.addSubview(progressBar)
        
        progressBar.createProgressBar()
    }
    
    private func resetProgressBar() {
        scoreCount = 0
        
        if progressBar != nil {
            progressBar.removeFromSuperview()
        }
    }
    
    // Set a timer and count to draw segments of 25 points each 0.1 ms
    
    private func trackProgress() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            self.scoreCount += 25
            
            DispatchQueue.main.async {
                let progress = CGFloat(self.scoreCount) / CGFloat(self.dashboardViewModel.maxScore ?? 700)
                self.progressBar.progress = min(progress, 1)
                self.changeCurrentColor()
                if self.scoreCount > (self.dashboardViewModel.score ?? 700 / 700) {
                    self.scoreCount = Int(self.dashboardViewModel.score ?? 0)
                    timer.invalidate()
                }
            }
        }
    }
}

// MARK: Dashboard View Model Delegate

extension DashboardViewController: DashboardViewModelDelegate {
    
    // Start spinner to indicate activity
    
    func didRequestCreditScore() {
        spinnerView.startAnimating()
    }
    
    // If score was received, start populating the information on the screen
    
    func didGetCreditScore() {
        spinnerView.stopAnimating()
        updateButton.isHidden = true
        addProgressBar()
        
        descriptionLabel.text = dashboardViewModel.message
        scoreCount = dashboardViewModel.minScore ?? 0
        maxScoreLabel.text = dashboardViewModel.maxScoreText
        
        bandDescriptionLabel.isHidden = true
        bandDescriptionLabel.text = dashboardViewModel.bandDescription
        
        trackProgress()
    }
    
    // If api call failed, inform users and show update button in case they want to try again
    
    func didGetError(_ error: ErrorType) {
        spinnerView.stopAnimating()
        
        Utils.showError(error, message: error.localizedDescription, in: self)
        
        updateButton.isHidden = false
    }
}
