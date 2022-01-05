defmodule Theme01.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :Theme01,
    module: Theme01.Guardian,
    error_handler: Theme01.AuthErrorHandler

  plug(Guardian.Plug.VerifyHeader, scheme: "Bearer")
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
