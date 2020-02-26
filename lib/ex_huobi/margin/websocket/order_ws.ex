defmodule ExHuobi.Margin.WebSocket.OrderWs do
  defmacro __using__(_opts) do
    quote do
      @endpoint "wss://api.huobi.pro/ws/v1"
      use WebSockex
      require Logger

      def start_link(args \\ %{}) do
        subscription = args[:subscribe] || ["orders.btcusdt.update"]
        opts = consturct_opts(args)

        state =
          args
          |> Map.merge(%{subscribe: subscription})
          |> Map.merge(Map.new(opts))

        WebSockex.start_link(@endpoint, __MODULE__, state, opts)
      end

      defp consturct_opts(args) do
        name = args[:name] || __MODULE__

        debug =
          case args do
            %{trace: true} -> [debug: [:trace]]
            _ -> []
          end

        [name: name] ++ debug
      end

      def authenticate(server, {config, endpoint}) do
        message = ExHuobi.Util.get_authen_ws_message(config, @endpoint)
        reply_op(server, message)
      end

      def subscribe(server, topic) do
        message = %{
          op: "sub",
          topic: topic
        }

        reply_op(server, message)
      end

      def pong(server, ts) do
        message = %{
          op: "pong",
          ts: ts
        }

        reply_op(server, message)
      end

      def reply_op(server, msg) do
        json = Jason.encode!(msg)
        send(server, {:ws_reply, {:text, json}})
      end

      @impl true
      def handle_connect(_conn, state) do
        Logger.info("Connected!")
        send(self(), :authenticate)
        {:ok, state}
      end

      @impl true
      def handle_info(:authenticate, state) do
        config = Map.get(state, :config)
        authenticate(self(), {config, @endpoint})
        {:ok, state}
      end

      @impl true
      def handle_info({:ws_reply, frame}, state) do
        {:reply, frame, state}
      end

      @impl true
      def handle_frame({:binary, gzip_msg}, state) do
        msg = :zlib.gunzip(gzip_msg)
        topics = Map.get(state, :subscribe)

        case Jason.decode(msg) do
          {:ok, %{"op" => "auth", "err-code" => 0}} ->
            Enum.each(topics, &subscribe(self(), &1))

          {:ok, %{"op" => "ping", "ts" => ts}} ->
            pong(self(), ts)

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

      defoverridable handle_response: 2, handle_disconnect: 2
    end
  end
end
