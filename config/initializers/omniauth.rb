OmniAuth.config.allowed_request_methods = %i[get post]

# Temporarily skip CSRF protection for OmniAuth
OmniAuth.config.request_validation_phase = proc { }

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "324405924578-kmc64rb6lqsv7h1anhkbvarg2dk12bv3.apps.googleusercontent.com",
           "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"
end
