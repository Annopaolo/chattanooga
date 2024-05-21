Mix.install([{:mississippi, github: "Annopaolo/mississippi", branch: "nimble"}])

Logger.configure(level: :warning)

init_options = [
  amqp_producer_options: [host: "localhost"],
  events_producer_connection_number: 10,
  mississippi_config: [
    events_exchange_name: "",
    data_queue_count: 128,
    data_queue_prefix: "mississippi_"
  ]
]

{:ok, _pid} = Mississippi.Producer.start_link(init_options)

defmodule Pub do
  def chat do
    message = IO.gets("What do you want to send? ")
    sharding_key = IO.gets("Any direction for it? ")

    Mississippi.Producer.EventsProducer.publish(message, sharding_key: sharding_key)

    IO.puts("Ack!")
    chat()
  end
end

Pub.chat()
