// Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/file;
import ballerina/http;
import ballerina/io;

isolated function getJsonPayloadFromService(string url, string document, string? operationName = ())
returns json|error {
    http:Client httpClient = check new(url);
    if (operationName is string) {
        return check httpClient->post("/", { query: document, operationName: operationName }, targetType = json);
    }
    return check httpClient->post("/", { query: document }, targetType = json);
}

isolated function getJsonContentFromFile(string fileName) returns json|error {
    string path = check file:joinPath("tests", "resources", fileName);
    return io:fileReadJson(path);
}
