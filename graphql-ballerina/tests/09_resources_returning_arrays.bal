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

service /graphql on new Listener(9100) {
    resource function get people() returns Person[] {
        return people;
    }

    isolated resource function get ids() returns int[] {
        return [0, 1, 2];
    }

    resource function get students() returns Student[] {
        return students;
    }

    isolated resource function get allVehicles() returns Vehicle[] {
        return [new Vehicle()];
    }

    isolated resource function get searchVehicles(string keyword) returns Vehicle[]? {
        return [new Vehicle()];
    }
}

service class Vehicle {
    isolated resource function get id () returns string|error {
        return "v1";
    }

    isolated resource function get name () returns string|error {
        return "vehicle1";
    }
}

@test:Config {
    groups: ["array", "service", "unit"]
}
isolated function testResourcesReturningScalarArrays() returns error? {
    string graphqlUrl = "http://localhost:9100/graphql";
    string document = "{ ids }";
    json actualResult = check getJsonPayloadFromService(graphqlUrl, document);

    json expectedResult = {
        data: {
            ids: [0, 1, 2]
        }
    };
    test:assertEquals(actualResult, expectedResult);
}

@test:Config {
    groups: ["array", "service", "unit"]
}
isolated function testResourcesReturningArrays() returns error? {
    string graphqlUrl = "http://localhost:9100/graphql";
    string document = "{ people { name address { city } } }";
    json actualResult = check getJsonPayloadFromService(graphqlUrl, document);

    json expectedResult = {
        data: {
            people: [
                {
                    name: "Sherlock Holmes",
                    address: {
                        city: "London"
                    }
                },
                {
                    name: "Walter White",
                    address: {
                        city: "Albuquerque"
                    }
                },
                {
                    name: "Tom Marvolo Riddle",
                    address: {
                        city: "Hogwarts"
                    }
                }
            ]
        }
    };
    test:assertEquals(actualResult, expectedResult);
}

@test:Config {
    groups: ["array", "service", "unit"]
}
isolated function testResourcesReturningArraysMissingFields() returns error? {
    string graphqlUrl = "http://localhost:9100/graphql";
    string document = "{ people }";
    json actualResult = check getJsonPayloadFromService(graphqlUrl, document);

    string expectedMessage = string`Field "people" of type "[Person!]!" must have a selection of subfields. Did you mean "people { ... }"?`;
    json expectedResult = {
        errors: [
            {
                message: expectedMessage,
                locations: [
                    {
                        line: 1,
                        column: 3
                    }
                ]
            }
        ]
    };
    test:assertEquals(actualResult, expectedResult);
}

@test:Config {
    groups: ["array", "service", "unit"]
}
isolated function testComplexArraySample() returns error? {
    string graphqlUrl = "http://localhost:9100/graphql";
    string document = "{ students { name courses { name books { name } } } }";
    json actualResult = check getJsonPayloadFromService(graphqlUrl, document);

    json expectedResult = {
        data: {
            students: [
                {
                    name: "John Doe",
                    courses: [
                        {
                            name: "Electronics",
                            books: [
                                {
                                    name: "The Art of Electronics"
                                },
                                {
                                    name: "Practical Electronics"
                                }
                            ]
                        },
                        {
                            name: "Computer Science",
                            books: [
                                {
                                    name: "Algorithms to Live By"
                                },
                                {
                                    name: "Code: The Hidden Language"
                                }
                            ]
                        }
                    ]
                },
                {
                    name: "Jane Doe",
                    courses: [
                        {
                            name: "Computer Science",
                            books: [
                                {
                                    name: "Algorithms to Live By"
                                },
                                {
                                    name: "Code: The Hidden Language"
                                }
                            ]
                        },
                        {
                            name: "Mathematics",
                            books: [
                                {
                                    name: "Calculus Made Easy"
                                },
                                {
                                    name: "Calculus"
                                }
                            ]
                        }
                    ]
                },
                {
                    name: "Jonny Doe",
                    courses: [
                        {
                            name: "Electronics",
                            books: [
                                {
                                    name: "The Art of Electronics"
                                },
                                {
                                    name: "Practical Electronics"
                                }
                            ]
                        },
                        {
                            name: "Computer Science",
                            books: [
                                {
                                    name: "Algorithms to Live By"
                                },
                                {
                                    name: "Code: The Hidden Language"
                                }
                            ]
                        },
                        {
                            name: "Mathematics",
                            books: [
                                {
                                    name: "Calculus Made Easy"
                                },
                                {
                                    name: "Calculus"
                                }
                            ]
                        }
                    ]
                }
            ]
        }
    };
    test:assertEquals(actualResult, expectedResult);
}

@test:Config {
    groups: ["array", "service", "unit"]
}
isolated function testResourceReturningServiceObjectArray() returns error? {
    string graphqlUrl = "http://localhost:9100/graphql";
    string document = string `{ allVehicles { name } }`;
    json result = check getJsonPayloadFromService(graphqlUrl, document);

    json expectedPayload = {
        data: {
            allVehicles: [
                {
                    name: "vehicle1"
                }
            ]
        }
    };
    test:assertEquals(result, expectedPayload);
}

@test:Config {
    groups: ["array", "service", "unit"]
}
isolated function testOptionalArray() returns error? {
    string graphqlUrl = "http://localhost:9100/graphql";
    string document = string `{ searchVehicles(keyword: "vehicle") { name } }`;
    json result = check getJsonPayloadFromService(graphqlUrl, document);

    json expectedPayload = {
        data: {
            searchVehicles: [
                {
                    name: "vehicle1"
                }
            ]
        }
    };
    test:assertEquals(result, expectedPayload);
}

@test:Config {
    groups: ["array", "service", "unit", "test"]
}
isolated function testOptionalArrayInvalidQuery() returns error? {
    string graphqlUrl = "http://localhost:9100/graphql";
    string document = string `{ searchVehicles(keyword: "vehicle") }`;
    json result = check getJsonPayloadFromService(graphqlUrl, document);

    json expectedPayload = {
        errors: [
            {
                message: string`Field "searchVehicles" of type "[Vehicle!]" must have a selection of subfields. Did you mean "searchVehicles { ... }"?`,
                locations: [
                    {
                        line: 1,
                        column: 3
                    }
                ]
            }
        ]
    };
    test:assertEquals(result, expectedPayload);
}
