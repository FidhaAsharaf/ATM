# OmniAuth.config.allowed_request_methods = [ :post, :get ]
OmniAuth.config.allowed_request_methods = [ :post ]


Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.application.credentials.google_oauth[:client_id],
           Rails.application.credentials.google_oauth[:client_secret],
           {
             scope: "userinfo.email,userinfo.profile",
             prompt: "select_account",
              redirect_uri: "http://localhost:3000/auth/google_oauth2/callback"
           }
end
