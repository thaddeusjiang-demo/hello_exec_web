import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hello_exec_web, HelloExecWebWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "8XqXG6E0trtkjuqsW2Rj40zW4vTwZFt4WsMucGH/YYkWMh4ea3NGrfG1HH2IqZQG",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
