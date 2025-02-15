// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

service /graphql on new Listener(9104) {
    isolated resource function get profile/name/first() returns string {
        return "Sherlock";
    }

    isolated resource function get profile/name/last() returns string {
        return "Holmes";
    }

    isolated resource function get profile/age() returns int {
        return 40;
    }

    isolated resource function get profile/address/city() returns string {
        return "London";
    }

    isolated resource function get profile/address/street() returns string {
        return "Baker Street";
    }

    isolated resource function get profile/name/address/number() returns string {
        return "221/B";
    }
}

@test:Config {
    groups: ["hierarchicalPaths", "unit"]
}
isolated function testHierarchicalResourcePaths() returns error? {
    string document = "{ profile { name { first } } }";
    string url = "http://localhost:9104/graphql";
    json actualPayload = check getJsonPayloadFromService(url, document);

    json expectedPayload = {
        data: {
            profile: {
                name: {
                    first: "Sherlock"
                }
            }
        }
    };
    test:assertEquals(actualPayload, expectedPayload);
}

@test:Config {
    groups: ["hierarchicalPaths", "unit"]
}
isolated function testHierarchicalResourcePathsMultipleFields() returns error? {
    string document = "{ profile { name { first last } } }";
    string url = "http://localhost:9104/graphql";
    json actualPayload = check getJsonPayloadFromService(url, document);

    json expectedPayload = {
        data: {
            profile: {
                name: {
                    first: "Sherlock",
                    last: "Holmes"
                }
            }
        }
    };
    test:assertEquals(actualPayload, expectedPayload);
}

@test:Config {
    groups: ["hierarchicalPaths", "unit"]
}
isolated function testHierarchicalResourcePathsComplete() returns error? {
    string document = "{ profile { name { first last } age } }";
    string url = "http://localhost:9104/graphql";
    json actualPayload = check getJsonPayloadFromService(url, document);

    json expectedPayload = {
        data: {
            profile: {
                name: {
                    first: "Sherlock",
                    last: "Holmes"
                },
                age: 40
            }
        }
    };
    test:assertEquals(actualPayload, expectedPayload);
}

isolated function testHierarchicalPathsSameTypeInMultiplePaths() returns error? {
    string document = "{ profile { name { address { street } } } }";
    string url = "http://localhost:9104/graphql";
    json actualPayload = check getJsonPayloadFromService(url, document);

    json expectedPayload = {
        data: {
            profile: {
                name: {
                    address: {
                        street: "Baker Street"
                    }
                }
            }
        }
    };
    test:assertEquals(actualPayload, expectedPayload);
}

@test:Config {
    groups: ["negative", "hierarchicalPaths", "unit"]
}
isolated function testInvalidHierarchicalResourcePaths() returns error? {
    string document = "{ profile { name { first middle } } }";
    string url = "http://localhost:9104/graphql";
    json actualPayload = check getJsonPayloadFromService(url, document);

    string expectedErrorMessage = "Cannot query field \"middle\" on type \"name\".";
    json expectedPayload = {
        errors: [
            {
                message: expectedErrorMessage,
                locations: [
                    {
                        line: 1,
                        column: 26
                    }
                ]
            }
        ]
    };
    test:assertEquals(actualPayload, expectedPayload);
}

@test:Config {
    groups: ["introspection", "hierarchicalPaths", "unit"]
}
isolated function testHierarchicalResourcePathsIntrospection() returns error? {
    string document = "{ __schema { types { name fields { name } } } }";
    string url = "http://localhost:9104/graphql";
    json expectedPayload = check getJsonContentFromFile("hierarchical_resource_path_introspection_result.json");
    json actualPayload = check getJsonPayloadFromService(url, document);
    test:assertEquals(actualPayload, expectedPayload);
}
