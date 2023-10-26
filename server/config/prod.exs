import Config

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside
# OrcasiteWeb.Endpoint.init/2 when load_from_system_env is
# true. Any dynamic configuration should be done there.
#
# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
#
# Finally, we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the mix phx.digest task
# which you typically run after static files are built.
config :orcasite, OrcasiteWeb.Endpoint,
  load_from_system_env: true,
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  watchers: [npm: ["run", "start", cd: Path.expand("../ui", __DIR__)]],
  check_origin: (System.get_env("URLS") || "") |> String.split(" ")

# Configure your database
config :orcasite, Orcasite.Repo,
  adapter: Ecto.Adapters.Postgres,
  ssl: true,
  types: Orcasite.PostgresTypes

# Do not print debug messages in production
config :logger, level: :info, format: {Orcasite.Logger, :format}

config :orcasite, :orcasite_s3_url, System.get_env("ORCASITE_S3_URL")

config :orcasite, Orcasite.Mailer,
  adapter: Swoosh.Adapters.AmazonSES,
  region: "us-west-2",
  access_key: System.get_env("ORCASITE_AWS_ACCESS_KEY_ID"),
  secret: System.get_env("ORCASITE_AWS_SECRET_ACCESS_KEY")

config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: Orcasite.Finch

config :orcasite, OrcasiteWeb.Guardian,
  issuer: "orcasite",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

config :orcasite, OrcasiteWeb.BasicAuth,
  username: System.get_env("ADMIN_USER"),
  password: System.get_env("ADMIN_PASSWORD")

if System.get_env("REDIS_URL") do
  config :orcasite, :cache_adapter, NebulexRedisAdapter

  config :orcasite, Orcasite.Cache,
    conn_opts: [
      url: System.get_env("REDIS_URL"),
      pool_size: String.to_integer(System.get_env("REDIS_POOL_SIZE") || "5")
    ]
end
