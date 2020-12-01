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

// Lexer errors
# Represents an error due to unterminated string in the GraphQL document
public type UnterminatedStringError distinct error<Location>;

# Represents an error due to invalid token in the GraphQL document
public type InvalidTokenError distinct error<Location>;

# Represents an error due to invalid character in the GraphQL document
public type InvalidCharacterError distinct error<Location>;

# Represents an internal error occurred during the document parsing
public type InternalError distinct error<Location>;

# Represents a syntax error in a GraphQL document
public type SyntaxError InvalidTokenError|InvalidCharacterError|UnterminatedStringError|InternalError;

# Represents the errors occurred while parsing a GraphQL document
public type Error SyntaxError;
