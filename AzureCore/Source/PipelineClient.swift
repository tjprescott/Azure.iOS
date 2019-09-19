//
//  PipelineClientBase.swift
//  AzureCore
//
//  Created by Travis Prescott on 8/29/19.
//  Copyright © 2019 Azure SDK Team. All rights reserved.
//

import Foundation

@objc(AZCorePipelineClient)
open class PipelineClient: NSObject {

    @objc public var baseUrl: String
    @objc public var config: PipelineConfiguration
    @objc public var pipeline: Pipeline

    @objc public init(baseUrl: String, config: PipelineConfiguration, pipeline: Pipeline) {
        self.baseUrl = baseUrl
        self.config = config
        self.pipeline = pipeline
    }

    @objc public func request(method: HttpMethod, urlTemplate: String?, queryParams: [String: String]? = nil,
                              content: Data? = nil, formContent: [String: AnyObject]? = nil,
                              streamContent: AnyObject? = nil) -> HttpRequest {
        let request = HttpRequest(httpMethod: method, url: format(urlTemplate: urlTemplate))
        if let queryParams = queryParams {
            request.format(queryParams: queryParams)
        }
        return request
    }

    private func formatUrlSection(template: String) -> String {
        // TODO: replace {these} with their values
        // let components = template.components(separatedBy: "/")
        return template
    }

    private func format(urlTemplate: String?) -> String {
        var url: String
        if let urlTemplate = urlTemplate {
            url = formatUrlSection(template: "\(baseUrl)\(urlTemplate)")
            // TODO: Some more URL parsing here...
        } else {
            url = baseUrl
        }
        return url
    }
}