defmodule FlyIoTest.Repo do
  use Ecto.Repo,
    otp_app: :fly_io_test,
    adapter: Ecto.Adapters.Postgres
end
