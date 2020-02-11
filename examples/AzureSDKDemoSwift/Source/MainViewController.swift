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

import AzureAppConfiguration
import AzureCore
import AzureStorageBlob
import MSAL
import os.log
import UIKit

class MainViewController: UITableViewController, MSALInteractiveDelegate {
    // MARK: Properties

    private var dataSource: PagedCollectionDataSource<ContainerItem, CustomTableViewCell>!

    override func viewDidLoad() {
        super.viewDidLoad()
        let dataSource = PagedCollectionDataSource<ContainerItem, CustomTableViewCell> { container, cell in
            cell.keyLabel.text = container.name
            cell.valueLabel.text = ""
        }

        // We also need to keep a strong reference to the data source,
        // since UITableView only uses a weak reference for it.
        self.tableView.dataSource = dataSource
        self.dataSource = dataSource
    }

    override func viewDidAppear(_: Bool) {
        loadInitialSettings()
    }

    // MARK: Private Methods

    /// Reload the table view on the UI thread.
    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        guard let data = dataSource?.items else { return 0 }
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = dataSource?.items else {
            fatalError("No data found to construct cell.")
        }
        let cellIdentifier = "CustomTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? CustomTableViewCell else {
            fatalError("The dequeued cell is not an instance of CustomTableViewCell")
        }
        // configure the cell
        let container = data[indexPath.row]
        cell.keyLabel.text = container.name
        cell.valueLabel.text = ""

        // load next page if at the end of the current list
        if indexPath.row == data.count - 1, noMoreData == false {
            loadMoreSettings()
        }
        return cell
    }

    // MARK: MSALInteractiveDelegate

    func didCompleteMSALRequest(withResult result: MSALResult) {
        AppState.account = result.account
    }
}
