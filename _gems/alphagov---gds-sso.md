---
layout: gem_layout
title: gds-sso
---

## `class GDS::SSO::Engine`

### `.default_strategies`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso.rb#L36)

---

## `class GDS::SSO::ApiAccess`

### `.api_call?(env)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/api_access.rb#L4)

---

## `class GDS::SSO::FailureApp`

### `.call(env)`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/failure_app.rb#L13)

### `#redirect`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/failure_app.rb#L21)

### `#store_location!`

TOTALLY NOT DOING THE SCOPE THING. PROBABLY SHOULD.

**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/failure_app.rb#L32)

---

## `class GDS::SSO::Lint::UserTest`

### `#user_class`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/lint/user_test.rb#L19)

---

## `class Api::UserController`

### `#update`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/app/controllers/api/user_controller.rb#L8)

### `#reauth`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/app/controllers/api/user_controller.rb#L15)

---

## `class AuthenticationsController`

### `#callback`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/app/controllers/authentications_controller.rb#L8)

### `#failure`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/app/controllers/authentications_controller.rb#L12)

### `#sign_out`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/app/controllers/authentications_controller.rb#L16)

---

## `module GDS::SSO`

### `.config`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso.rb#L18)

---

## `module GDS::SSO::User`

### `.below_rails_4?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/user.rb#L8)

### `#has_permission?(permission)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/user.rb#L18)

### `.user_params_from_auth_hash(auth_hash)`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/user.rb#L24)

### `#clear_remotely_signed_out!`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/user.rb#L36)

### `#set_remotely_signed_out!`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/user.rb#L40)

---

## `module GDS::SSO::User::ClassMethods`

### `#find_for_gds_oauth(auth_hash)`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/user.rb#L45)

---

## `module GDS::SSO::Config`

### `.user_klass`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/config.rb#L26)

### `.use_mock_strategies?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/config.rb#L30)

---

## `module GDS::SSO::BearerToken`

### `.locate(token_string)`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/bearer_token.rb#L7)

### `.oauth_client`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/bearer_token.rb#L19)

### `.omniauth_style_response(response_body)`

Our User code assumes we're getting our user data back
via omniauth and so receiving it in omniauth's preferred
structure. Here we're addressing signonotron directly so
we need to transform the response ourselves.

**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/bearer_token.rb#L31)

---

## `module GDS::SSO::MockBearerToken`

### `.locate(token_string)`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/bearer_token.rb#L52)

---

## `module GDS::SSO::ControllerMethods`

### `#authorise_user!(permission)`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/controller_methods.rb#L16)

### `#require_signin_permission!`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/controller_methods.rb#L26)

### `#authenticate_user!`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/controller_methods.rb#L32)

### `#user_remotely_signed_out?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/controller_methods.rb#L36)

### `#user_signed_in?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/controller_methods.rb#L40)

### `#current_user`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/controller_methods.rb#L44)

### `#logout`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/controller_methods.rb#L48)

### `#warden`


**See**:
- [Source on GitHub](https://github.com/alphagov/gds-sso/blob/master/lib/gds-sso/controller_methods.rb#L52)

---
