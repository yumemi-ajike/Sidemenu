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

        contentViewController.viewControllers[0].view.backgroundColor = .white
        contentViewController.viewControllers[0].navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sidemenu", style: .plain, target: self, action: #selector(sidemenuBarButtonTapped(sender:)))
        addChildViewController(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParentViewController: self)

        sidemenuViewController.delegate = self
        sidemenuViewController.startPanGestureRecognizing()
    }

    @objc private func sidemenuBarButtonTapped(sender: Any) {
        showSidemenu(animated: true)
    }
    
    private func showSidemenu(contentAvailability: Bool = true, animated: Bool) {
        if isShownSidemenu { return }

        addChildViewController(sidemenuViewController)
        sidemenuViewController.view.autoresizingMask = .flexibleHeight
        sidemenuViewController.view.frame = contentViewController.view.bounds
        view.insertSubview(sidemenuViewController.view, aboveSubview: contentViewController.view)
        sidemenuViewController.didMove(toParentViewController: self)
        if contentAvailability {
            sidemenuViewController.showContentView(animated: animated)
        }
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
    func parentViewControllerForSidemenuViewController(_ sidemenuViewController: SidemenuViewController) -> UIViewController {
        return self
    }

    func shouldPresentForSidemenuViewController(_ sidemenuViewController: SidemenuViewController) -> Bool {
        /* You can specify sidemenu availability */
        return true
    }

    func sidemenuViewControllerDidRequestShowing(_ sidemenuViewController: SidemenuViewController, contentAvailability: Bool, animated: Bool) {
        showSidemenu(contentAvailability: contentAvailability, animated: animated)
    }

    func sidemenuViewControllerDidRequestHiding(_ sidemenuViewController: SidemenuViewController, animated: Bool) {
        hideSidemenu(animated: animated)
    }

    func sidemenuViewController(_ sidemenuViewController: SidemenuViewController, didSelectItemAt indexPath: IndexPath) {
        hideSidemenu(animated: true)
    }
}
