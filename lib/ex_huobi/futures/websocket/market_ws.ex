defmodule ExHuobi.Future.Websocket.MarketWs do
  defmacro __using__(_opts) do
    quote do
      use WebSockex
      require Logger
      import Process, only: [send_after: 3]
      @endpoint "wss://www.hbdm.com/ws"

      def start_link(args \\ %{}) do
        subscription = args[:subscribe] || ["market.BTC_CQ.depth.size_150.high_freq"]
        opts = construct_opts(args)

        state =
          args
          |> Map.merge(%{subscribe: subscription})
          |> Map.merge(Map.new(opts))

        WebSockex.start_link(@endpoint, __MODULE__, state, opts)
      end

      defp construct_opts(args) do
        name = args[:name] || __MODULE__

        debug =
          case args do
            %{trace: true} -> [debug: [:trace]]
            _ -> []
          end

        [name: name] ++ debug
      end

      def subscribe(server, topic) do
        message = %{
          sub: topic,
          data_type: "incremental"
        }

        reply_op(server, message)
      end

      defp pong(server, ts) do
        message = %{pong: ts}
        reply_op(server, message)
      end

      defp reply_op(server, msg) do
        json = Jason.encode!(msg)
        send(server, {:ws_reply, {:text, json}})
      end

      @impl true
      def handle_connect(_conn, state) do
        Logger.info("Connected!")
        send(self(), :subscribe)
        {:ok, state}
      end

      @impl true
      def handle_info({:pong, ts}, state) do
        pong(self(), ts)
        {:ok, state}
      end

      @impl true
      def handle_info(:subscribe, state) do
        topics = Map.get(state, :subscribe)
        Enum.each(topics, &subscribe(self(), &1))
        {:ok, state}
      end

      @impl true
      def handle_info({:ws_reply, frame}, state) do
        {:reply, frame, state}
      end

      @impl true
      def handle_frame({:binary, gzip_msg}, state) do
        msg = :zlib.gunzip(gzip_msg)

        case Jason.decode(msg) do
          {:ok, %{"ping" => ts}} ->
            send_after(self(), {:pong, ts}, 5_000)

          {:ok, payload} ->
            handle_response(payload, state)
        end

        {:ok, state}
      end

      def handle_response(resp, _state) do
        :ok = Logger.debug("#{__MODULE__} received response: #{inspect(resp)}")
      end

      @impl true
      def handle_disconnect(disconnect_map, state) do
        :ok = Logger.warn("#{__MODULE__} disconnected: #{inspect(disconnect_map)}")
        {:reconnect, state}
      end

      defoverridable handle_connect: 2, handle_response: 2, handle_disconnect: 2
    end
  end
end
