// --------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the ""Software""), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
// --------------------------------------------------------------------------

import Foundation
import UIKit

open class PagedCollectionDataSource<Model: Codable, Cell: UITableViewCell>: NSObject, UITableViewDataSource {

    // MARK: Properties

    internal var data: PagedCollection<Model>?

    private var noMoreData = false
    private let cellIdentifier: String
    private let cellConfigurator: (Model, Cell) -> Void
    private let requestor: () -> PagedCollection<Model>?

    // MARK: Initializers

    public init(cellReuseIdentifier: String? = nil, cellConfigurator: @escaping (Model, Cell) -> Void) {
        self.cellIdentifier = cellReuseIdentifier ?? String(describing: Cell.self)
        self.cellConfigurator = cellConfigurator
    }

    // MARK: UITableViewDataSource Methods

    public func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        guard let data = data?.items else { return 0 }
        return data.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = data?.items else {
            fatalError("No data found to construct cell.")
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Cell else {
            fatalError("Dequeued cell is not of type \(Cell.self).")
        }
        let model = data[indexPath.row]

        // configure the cell
        cellConfigurator(model, cell)

        // load next page if at the end of the current list
        if indexPath.row == data.count - 1, noMoreData == false {
            loadMore()
        }
        return cell
    }

    // MARK: Internal Methods

    /// Constructs the PagedCollection and retrieves the first page of results to initalize the table view.
    public func loadInitial() {
        guard let blobClient = getBlobClient() else { return }
        let options = ListContainersOptions()
        options.maxResults = 20
        blobClient.listContainers(withOptions: options) { result, _ in
            switch result {
            case let .success(paged):
                self.dataSource = paged
                self.reloadTableView()
            case let .failure(error):
                self.showAlert(error: String(describing: error))
                self.noMoreData = true
            }
        }
    }

    /// Uses asynchronous "nextPage" method to fetch the next page of results and update the table view.
    public func loadMore() {
        guard noMoreData == false else { return }
        data?.nextPage { result in
            switch result {
            case .success:
                self.table
            case let .failure(error):
                self.showAlert(error: String(describing: error))
                self.noMoreData = true
            }
        }
    }
}
