// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/auth;
import ballerina/jwt;
import ballerina/oauth2;

# Represents file user store configurations for Basic Auth authentication.
public type FileUserStoreConfig record {|
    *auth:FileUserStoreConfig;
|};

# Represents LDAP user store configurations for Basic Auth authentication.
public type LdapUserStoreConfig record {|
    *auth:LdapUserStoreConfig;
|};

# Represents JWT validator configurations for JWT authentication.
#
# + scopeKey - The key used to fetch the scopes
public type JwtValidatorConfig record {|
    *jwt:ValidatorConfig;
    string scopeKey = "scope";
|};

# Represents OAuth2 introspection server configurations for OAuth2 authentication.
#
# + scopeKey - The key used to fetch the scopes
public type OAuth2IntrospectionConfig record {|
    *oauth2:IntrospectionConfig;
    string scopeKey = "scope";
|};

public type FileUserStoreConfigWithScopes record {|
   FileUserStoreConfig fileUserStoreConfig;
   string|string[] scopes?;
|};

public type LdapUserStoreConfigWithScopes record {|
   LdapUserStoreConfig ldapUserStoreConfig;
   string|string[] scopes?;
|};

public type JwtValidatorConfigWithScopes record {|
   JwtValidatorConfig jwtValidatorConfig;
   string|string[] scopes?;
|};

public type OAuth2IntrospectionConfigWithScopes record {|
   OAuth2IntrospectionConfig oauth2IntrospectionConfig;
   string|string[] scopes?;
|};

# Defines the authentication configurations for the GraphQL listener.
public type ListenerAuthConfig FileUserStoreConfigWithScopes|
                               LdapUserStoreConfigWithScopes|
                               JwtValidatorConfigWithScopes|
                               OAuth2IntrospectionConfigWithScopes;
