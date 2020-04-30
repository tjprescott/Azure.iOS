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

import AzureCore
import AzureStorageBlob
import Foundation

class BlobListObservable: ObservableObject {
    @Published var items: PagedCollection<BlobItem>?

    init() {
        loadBlobData()
    }

    func loadBlobData() {
        // swiftlint:disable line_length
        let connectionString =
            "BlobEndpoint=https://iosdemostorage1.blob.core.windows.net/;QueueEndpoint=https://iosdemostorage1.queue.core.windows.net/;FileEndpoint=https://iosdemostorage1.file.core.windows.net/;TableEndpoint=https://iosdemostorage1.table.core.windows.net/;SharedAccessSignature=sv=2019-10-10&ss=bfqt&srt=sco&sp=rwdlacupx&se=2020-05-08T02:43:19Z&st=2020-05-07T18:43:19Z&spr=https&sig=Ys3gJQoPIpsWBz5SDx5tW%2FwEOJuTvaPB8Ix6efmAMZI%3D"
        guard let credential = try? StorageSASCredential(connectionString: connectionString),
            let blobClient = try? StorageBlobClient(credential: credential, withRestorationId: "AzureSDKSwiftUIDemo")
        else { return }

        blobClient.listBlobs(inContainer: "videos") { result, _ in
            switch result {
            case let .success(paged):
                self.items = paged
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
