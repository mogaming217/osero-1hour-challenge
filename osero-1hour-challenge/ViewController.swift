//
//  ViewController.swift
//  osero-1hour-challenge
//
//  Created by Seiya Mogami on 2019/02/10.
//  Copyright © 2019 mogaming. All rights reserved.
//

import UIKit

enum OseroType: String, Equatable {
    case white = "○", black = "●", none = ""
}

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var isWhiteTern = false

    var currentType: OseroType {
        return isWhiteTern ? .white : .black
    }

    var targetType: OseroType {
        return isWhiteTern ? .black : .white
    }

    var source = [[OseroType]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "OseroCell", bundle: nil), forCellWithReuseIdentifier: "OseroCell")

        setupInitData()

        collectionView.reloadData()
    }

    private func setupInitData() {
        for _ in 0...7 {
            let row = [OseroType](repeating: .none, count: 8)
            source.append(row)
        }

        source[3][3] = .white
        source[4][4] = .white
        source[3][4] = .black
        source[4][3] = .black
    }

    private func extractFlipPlace(x: Int, y: Int) -> [(x: Int, y: Int)] {
        if source[x][y] != .none {
            return []
        }

        let pattern = [(0, 1), (0, -1), (1, 1), (1, 0), (1, -1), (-1, 1), (-1, 0), (-1, -1)]
        var flips = [(Int, Int)]()
        pattern.forEach {
            // 置こうとしてる隣が相手のものか
            guard let type = getType(x: x, y: y, xOffset: $0.0, yOffset: $0.1), type == targetType else {
                return
            }

            var i = 1
            var point = (x + $0.0 * i, y + $0.1 * i)
            var next = source[safe: point.0]?[safe: point.1]

            var possible = [(Int, Int)]()
            while (next != nil) {
                if next! == targetType {
                    possible.append(point)
                } else if next! == currentType {
                    break
                } else {
                    possible.removeAll()
                    break
                }

                i += 1
                point = (x + $0.0 * i, y + $0.1 * i)
                next = source[safe: point.0]?[safe: point.1]
            }

            if !possible.isEmpty {
                possible.append((x, y))
            }

            flips.append(contentsOf: possible)
        }

        return flips
    }

    private func getType(x: Int, y: Int, xOffset: Int, yOffset: Int) -> OseroType? {
        return source[safe: x + xOffset]?[safe: y + yOffset]
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let targets = extractFlipPlace(x: indexPath.section, y: indexPath.row)
        if targets.isEmpty {
            return
        }

        let me = currentType
        targets.forEach {
            source[$0.0][$0.1] = me
        }

        isWhiteTern.toggle()
        collectionView.reloadData()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return source.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OseroCell", for: indexPath) as! OseroCell
        cell.label.text = source[indexPath.section][indexPath.row].rawValue
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    // Cellのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullWidth = UIScreen.main.bounds.width - 7
        let length = fullWidth / 8
        return CGSize(width: length, height: length)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
}


extension Array {
    subscript (safe index: Index) -> Element? {
        guard case self.indices = index else {
            return nil
        }
        return self[index]
    }
}
