# chattanooga
Demo scripts for the Mississippi message framework

## Try it!
First of all, let's bring up a RabbitMQ instance:

```sh
docker run --rm -p 5672:5672 -p 15672:15672 rabbitmq:3.8.34-management
```

Then, start a producer with
```sh
elixir pub.exs
```

and a consumer with (the order is not important)
```sh
elixir sub.exs
```

The producer will publish data on 128 AMQP queues (0 to 127), keep that
in mind when the consumer asks for a queue range to consume from.

Then, you can let data flow through Mississippi:
```sh
# producer
What do you want to send? aaaa #payload
Any direction for it? no #mississippi sharding key
Ack!
What do you want to send? aaaa
Any direction for it? yes
Ack!

# consumer 1
Queue range start? 64
Queue range end? 127
Start receiving
Received message! Payload: "aaaa\n" and headers %{"sharding_key" => "yes\n"} at ~U[2024-05-21 07:31:24Z]

# consumer 2
Queue range start? 0
Queue range end? 63
Start receiving
Received message! Payload: "aaaa\n" and headers %{"sharding_key" => "no\n"} at ~U[2024-05-21 07:31:11Z]
```