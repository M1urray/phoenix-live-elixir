defmodule ShopWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :shop

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_shop_key",
    signing_salt: "h85A/jJa",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]],
    longpoll: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :shop,
    gzip: false,
    only: ShopWeb.static_paths()

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :shop
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug :check_promo_code, code: "Xbox is amazing@"
  plug ShopWeb.Router

  def check_promo_code(%Plug.Conn{} = conn, _opts) do
    promo_code = conn.params["promo"]

    if promo_code do
      IO.inspect("Promo is true!")
      assign(conn, :promo, true)
    else
      assign(conn, :promo, false)
    end
  end

  def check_promo_code(%Plug.Conn{:params => %{"promo" => "secret-code"}} = conn, _opts) do
    assign(conn, :promo, false)
  end

  def check_promo_code(%Plug.Conn{} = conn, opts) do
    IO.inspect(opts)
    assign(conn, :promo, false)
  end
end
