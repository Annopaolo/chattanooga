Mix.install([{:mississippi, github: "Annopaolo/mississippi", branch: "nimble"}])

Logger.configure(level: :warning)

queue_range_start_string = IO.gets("Queue range start?")
queue_range_end_string = IO.gets("Queue range end?")

{queue_range_start, _} = Integer.parse(queue_range_start_string)
{queue_range_end, _} = Integer.parse(queue_range_end_string)

defmodule Sub do
  @behaviour Mississippi.Consumer.DataUpdater.Handler

  @impl true
  def handle_message(payload, headers, _message_id, timestamp) do
    msg =
      "Received message! Payload: #{inspect(payload)} and headers #{inspect(headers)} at #{inspect(timestamp |> DateTime.from_unix!())}"

    IO.puts(msg)

    {:ok, :ok}
  end
end

init_options = [
  amqp_consumer_options: [host: "localhost"],
  events_consumer_connection_number: 20,
  mississippi_queues_config: [
    events_exchange_name: "",
    data_queue_prefix: "mississippi_",
    data_queue_range_start: queue_range_start,
    data_queue_range_end: queue_range_end,
    data_queue_total_count: 128
  ],
  message_handler: Sub
]

{:ok, _pid} = Mississippi.Consumer.start_link(init_options)

IO.puts("Start receiving")

defmodule Hello do
  def world do
    receive do
      msg -> IO.puts(msg)
    end

    world()
  end
end

Hello.world()
