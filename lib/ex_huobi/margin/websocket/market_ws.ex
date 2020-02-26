defmodule ExHuobi.Margin.WebSocket.MarketWs do
  defmacro __using__(_opts) do
    quote do
      use WebSockex
      require Logger
      import Process, only: [send_after: 3]
      @endpoint "wss://api.huobi.pro/ws"
      @get_snapshot_delay_time 2000

      def start_link(args \\ %{}) do
        subscription = args[:subscribe] || ["market.btcusdt.mbp.150"]
        opts = consturct_opts(args)

        state =
          args
          |> Map.merge(%{
            subscribe: subscription,
            heartbeat: 0
          })
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

      def subscribe_delta(server, topic) do
        message = %{
          sub: topic
        }

        reply_op(server, message)
      end

      def subscribe_snapshot(server, topic) do
        message = %{
          req: topic
        }

        reply_op(server, message)
      end

      defp pong(server, ts) do
        message = %{pong: ts}
        reply_op(server, message)
      end

      defp ping(server, ts) do
        message = %{ping: ts}
        reply_op(server, message)
      end

      def reply_op(server, msg) do
        json = Jason.encode!(msg)
        send(server, {:ws_reply, {:text, json}})
      end

      defp inc_heartbeat(%{heartbeat: heartbeat} = state) do
        Map.put(state, :heartbeat, heartbeat + 1)
      end

      @impl true
      def handle_connect(_conn, state) do
        Logger.info("Connected!")
        send(self(), :subscribe_delta)
        send_after(self(), :subscribe_snapshot, @get_snapshot_delay_time)
        send(self(), :init_timer)
        {:ok, state}
      end

      @impl true
      def handle_info({:ping, ts}, state) do
        %{heartbeat: inc} = inc_heartbeat(state)
        ping(self(), ts + inc)
        {:ok, state}
      end

      @impl true
      def handle_info({:pong, ts}, state) do
        pong(self(), ts)
        {:ok, state}
      end

      @impl true
      def handle_info(:check_timer, state) do
        case Map.get(state, :timer_ref) |> Process.read_timer() do
          false ->
            {:close, state}

          _ ->
            send_after(self(), :check_timer, 1_000)
            {:ok, state}
        end
      end

      @impl true
      def handle_info(:init_timer, state) do
        {:ok, Map.put(state, :timer_ref, send_after(self(), :done_timer, 5_000))}
      end

      @impl true
      def handle_info(:done_timer, state) do
        {:ok, state}
      end

      @impl true
      def handle_info(:subscribe_delta, state) do
        topics = Map.get(state, :subscribe)
        Enum.each(topics, &subscribe_delta(self(), &1))
        send_after(self(), {:ping, 0}, 1_000)
        send_after(self(), :check_timer, 1_000)
        {:ok, state}
      end

      @impl true
      def handle_info(:subscribe_snapshot, state) do
        topics = Map.get(state, :subscribe)
        Enum.each(topics, &subscribe_snapshot(self(), &1))
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

          {:ok, %{"pong" => ts} = payload} ->
            send(self(), :init_timer)
            send_after(self(), {:ping, ts}, 2_000)

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
