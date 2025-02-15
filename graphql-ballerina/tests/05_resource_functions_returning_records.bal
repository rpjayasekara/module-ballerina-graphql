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

import ballerina/test;

@test:Config {
    groups: ["service", "unit"]
}
isolated function testGetFieldFromRecordResource() returns error? {
    string document = "query getPerson { profile { name, address { street } } }";
    string url = "http://localhost:9094/graphql";
    json actualPayload = check getJsonPayloadFromService(url, document);

    json expectedPayload = {
        data: {
            profile: {
                name: "Sherlock Holmes",
                address: {
                    street: "Baker Street"
                }
            }
        }
    };
    test:assertEquals(actualPayload, expectedPayload);
}

service /graphql on new Listener(9094) {
    isolated resource function get profile() returns Person {
        return {
            name: "Sherlock Holmes",
            age: 40,
            address: {
                number: "221/B",
                street: "Baker Street",
                city: "London"
            }
        };
    }
}
