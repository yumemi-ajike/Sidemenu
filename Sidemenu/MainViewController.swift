//
//  MainViewController.swift
//  Sidemenu
//
//  Created by Atsushi Jike on 2018/06/13.
//  Copyright © 2018 Yumemi Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let contentViewController = UINavigationController(rootViewController: UIViewController())
    let sidemenuViewController = SidemenuViewController()
    private var isShownSidemenu: Bool {
        return sidemenuViewController.parent == self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        contentViewController.viewControllers[0].navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sidemenu", style: .plain, target: self, action: #selector(sidemenuBarButtonTapped(sender:)))
        addChildViewController(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParentViewController: self)

        sidemenuViewController.delegate = self
    }

    @objc private func sidemenuBarButtonTapped(sender: Any) {
        showSidemenu()
    }
    
    private func showSidemenu() {
        if isShownSidemenu { return }

        addChildViewController(sidemenuViewController)
        sidemenuViewController.view.autoresizingMask = .flexibleHeight
        sidemenuViewController.view.frame = contentViewController.view.bounds
        view.insertSubview(sidemenuViewController.view, aboveSubview: contentViewController.view)
        sidemenuViewController.didMove(toParentViewController: self)
        sidemenuViewController.showContentView(animated: true)
    }

    private func hideSidemenu(animated: Bool) {
        if !isShownSidemenu { return }

        sidemenuViewController.hideContentView(animated: animated, completion: { (_) in
            self.sidemenuViewController.willMove(toParentViewController: nil)
            self.sidemenuViewController.removeFromParentViewController()
            self.sidemenuViewController.view.removeFromSuperview()
        })
    }
}

extension MainViewController: SidemenuViewControllerDelegate {
    func sidemenuViewController(_ sidemenuViewController: SidemenuViewController, didSelectItemAt indexPath: IndexPath) {
        hideSidemenu(animated: true)
    }
}
