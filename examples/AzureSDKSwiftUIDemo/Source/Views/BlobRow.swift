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

import AzureStorageBlob
import SwiftUI

struct BlobRow: View {
    var blob: BlobItem
    var transferId: UUID?
    @State var progress = Float(0)

    init(blob: BlobItem, transferId: UUID?) {
        self.blob = blob
        self.transferId = transferId
        let blobClient = try? AppState.blobClient()
        if let transfer = transferId != nil ? blobClient?.transfers
            .element(withId: transferId!) as? BlobTransfer : nil {
            self.progress = transfer.progress
        }
    }

    var body: some View {
        return VStack {
            HStack {
                Text(blob.name)
                    .font(.subheadline)
                Spacer()
                Text(blob.properties?.blobType?.rawValue ?? "Unknown")
            }
            ProgressView(progress: $progress)
        }
    }
}
