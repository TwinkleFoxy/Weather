//
//  Extension+Reactive.swift
//  Weather
//
//  Created by Алексей Однолько on 21.02.2024.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UITableView {
    
    func items<Sequence: Swift.Sequence, Cell: BaseTableCell, Source: ObservableType>
    (cellType: Cell.Type = Cell.self)
    -> (_ source: Source)
    -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
    -> Disposable where Source.Element == Sequence { items(cellIdentifier: cellType.identifier, cellType: cellType) }
}
