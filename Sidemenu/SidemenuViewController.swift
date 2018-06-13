//
//  SidemenuViewController.swift
//  Sidemenu
//
//  Created by Atsushi Jike on 2018/06/13.
//  Copyright © 2018 Yumemi Inc. All rights reserved.
//

import UIKit

protocol SidemenuViewControllerDelegate: class {
    func sidemenuViewController(_ sidemenuViewController: SidemenuViewController, didSelectItemAt indexPath: IndexPath)
}

class SidemenuViewController: UIViewController {
    private let contentView = UIView(frame: .zero)
    private let tableView = UITableView(frame: .zero, style: .plain)
    weak var delegate: SidemenuViewControllerDelegate?
    private var contentMaxWidth: CGFloat {
        return view.bounds.width * 0.8
    }
    private var contentRatio: CGFloat {
        get {
            return contentView.frame.maxX / contentMaxWidth
        }
        set {
            let ratio = min(max(newValue, 0), 1)
            contentView.frame.origin.x = contentMaxWidth * ratio - contentView.frame.width
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowRadius = 3.0
            contentView.layer.shadowOpacity = 0.8

            view.backgroundColor = UIColor(white: 0, alpha: 0.3 * ratio)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var contentRect = view.bounds
        contentRect.size.width = contentMaxWidth
        contentRect.origin.x = -contentRect.width
        contentView.frame = contentRect
        contentView.backgroundColor = .white
        contentView.autoresizingMask = .flexibleHeight
        view.addSubview(contentView)

        tableView.frame = contentView.bounds
        tableView.separatorInset = .zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Default")
        contentView.addSubview(tableView)
        tableView.reloadData()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(sender:)))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func backgroundTapped(sender: UITapGestureRecognizer) {
        hideContentView(animated: true) { (_) in
            self.willMove(toParentViewController: nil)
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        }
    }

    func showContentView(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.contentRatio = 1.0
            }
        } else {
            contentRatio = 1.0
        }
    }

    func hideContentView(animated: Bool, completion: ((Bool) -> Swift.Void)?) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentRatio = 0
            }, completion: { (finished) in
                completion?(finished)
            })
        } else {
            contentRatio = 0
            completion?(true)
        }
    }
}

extension SidemenuViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
        cell.textLabel?.text = "Item \(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sidemenuViewController(self, didSelectItemAt: indexPath)
    }
}
