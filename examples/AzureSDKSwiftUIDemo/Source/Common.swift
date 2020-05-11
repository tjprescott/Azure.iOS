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

struct AppConstants {
    static let videoContainer = "videos"

    // swiftlint:disable line_length
    static let sasConnectionString =
        "BlobEndpoint=https://iosdemostorage1.blob.core.windows.net/;QueueEndpoint=https://iosdemostorage1.queue.core.windows.net/;FileEndpoint=https://iosdemostorage1.file.core.windows.net/;TableEndpoint=https://iosdemostorage1.table.core.windows.net/;SharedAccessSignature=sv=2019-10-10&ss=bfqt&srt=co&sp=rwdlacupx&se=2020-05-12T01:01:13Z&st=2020-05-11T17:01:13Z&spr=https&sig=%2FHUsW9753QB%2FIDKxMcx2VZ2vs5XThfps8IzAb5xOfQ0%3D"
}

struct AppState {
    static var error: Error?

    private static var internalBlobClient: StorageBlobClient?
    static func blobClient(withDelegate delegate: TransferDelegate? = nil) throws -> StorageBlobClient {
        let error = AzureError.general("Unable to create Blob Storage Client.")
        if AppState.internalBlobClient == nil {
            guard let credential = try? StorageSASCredential(connectionString: AppConstants.sasConnectionString) else {
                throw error
            }
            let options = StorageBlobClientOptions(
                apiVersion: StorageBlobClient.ApiVersion.latest.rawValue,
                logger: ClientLoggers.none
            )
            AppState.internalBlobClient = try? StorageBlobClient(
                credential: credential,
                withRestorationId: "AzureSDKDemoSwift",
                withOptions: options
            )
        }
        guard AppState.internalBlobClient != nil else {
            throw error
        }
        let client = AppState.internalBlobClient!
        client.transferDelegate = delegate
        StorageBlobClient.maxConcurrentTransfers = 4
        return client
    }
}
