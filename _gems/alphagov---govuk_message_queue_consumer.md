---
layout: gem_layout
title: govuk_message_queue_consumer
---

## `class GovukMessageQueueConsumer::Message`

### `#delivery_info`

Returns the value of attribute delivery_info

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/message.rb#L4)

### `#delivery_info=(value)`

Sets the attribute delivery_info

**Params**:

- `value` (``) — the value to set the attribute delivery_info to.


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/message.rb#L4)

### `#headers`

Returns the value of attribute headers

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/message.rb#L4)

### `#headers=(value)`

Sets the attribute headers

**Params**:

- `value` (``) — the value to set the attribute headers to.


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/message.rb#L4)

### `#payload`

Returns the value of attribute payload

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/message.rb#L4)

### `#payload=(value)`

Sets the attribute payload

**Params**:

- `value` (``) — the value to set the attribute payload to.


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/message.rb#L4)

### `#status`

Returns the value of attribute status

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/message.rb#L4)

### `#status=(value)`

Sets the attribute status

**Params**:

- `value` (``) — the value to set the attribute status to.


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/message.rb#L4)

### `#initialize(payload, headers, delivery_info)`

**Returns**:

- (`Message`) — a new instance of Message

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/message.rb#L6)

### `#ack`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/message.rb#L13)

### `#retry`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/message.rb#L18)

### `#discard`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/message.rb#L23)

---

## `class GovukMessageQueueConsumer::Consumer`

### `#initialize(queue_name:, processor:, rabbitmq_connection: Consumer.default_connection_from_env, statsd_client: NullStatsd.new, logger: Logger.new(STDERR))`

Create a new consumer

**Params**:

- `queue_name` (`String`) — Your queue name. This is specific to your application,
and should already exist and have a binding via puppet


- `processor` (`Object`) — An object that responds to `process`


- `rabbitmq_connection` (`Object`) — A Bunny connection object derived from `Bunny.new`


- `statsd_client` (`Statsd`) — An instance of the Statsd class


- `logger` (`Object`) — A Logger object for emitting errors (to stderr by default)


**Returns**:

- (`Consumer`) — a new instance of Consumer

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/consumer.rb#L20)

### `#run`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/consumer.rb#L28)

---

## `class GovukMessageQueueConsumer::Consumer::NullStatsd`

### `#increment(_key)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/consumer.rb#L49)

---

## `class GovukMessageQueueConsumer::JSONProcessor`

### `#initialize(next_processor)`

**Returns**:

- (`JSONProcessor`) — a new instance of JSONProcessor

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/json_processor.rb#L5)

### `#process(message)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/json_processor.rb#L9)

---

## `class GovukMessageQueueConsumer::HeartbeatProcessor`

### `#initialize(next_processor)`

**Returns**:

- (`HeartbeatProcessor`) — a new instance of HeartbeatProcessor

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/heartbeat_processor.rb#L3)

### `#process(message)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/heartbeat_processor.rb#L7)

---

## `class GovukMessageQueueConsumer::MockMessage`

### `#acked`

Returns the value of attribute acked

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/test_helpers/mock_message.rb#L3)

### `#retried`

Returns the value of attribute retried

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/test_helpers/mock_message.rb#L3)

### `#discarded`

Returns the value of attribute discarded

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/test_helpers/mock_message.rb#L3)

### `#acked`

Returns the value of attribute acked

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/test_helpers/mock_message.rb#L5)

### `#discarded`

Returns the value of attribute discarded

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/test_helpers/mock_message.rb#L6)

### `#retried`

Returns the value of attribute retried

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/test_helpers/mock_message.rb#L7)

### `#initialize(payload = {}, headers = {}, delivery_info = {})`

**Returns**:

- (`MockMessage`) — a new instance of MockMessage

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/test_helpers/mock_message.rb#L9)

### `#ack`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/test_helpers/mock_message.rb#L15)

### `#retry`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/test_helpers/mock_message.rb#L19)

### `#discard`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/test_helpers/mock_message.rb#L23)

---

## `module GovukMessageQueueConsumer::RabbitMQConfig`

### `.from_environment(env)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_message_queue_consumer/blob/master/lib/govuk_message_queue_consumer/rabbitmq_config.rb#L6)

---
