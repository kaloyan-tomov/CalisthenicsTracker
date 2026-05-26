require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings.
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Enable caching
  config.action_controller.perform_caching = true

  # Serve static files if Heroku tells Rails to do so
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # Cache assets for far-future expiry
  config.public_file_server.headers = {
    "cache-control" => "public, max-age=#{1.year.to_i}"
  }

  config.active_storage.service = :cloudflare_r2

  config.active_storage.analyzers = []


  # Delete files synchronously (prevents PurgeJob)
  config.active_storage.queues.purge = nil

  config.force_ssl = true

  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Silence health check noise
  config.silence_healthcheck_path = "/up"

  config.active_job.queue_adapter = :sidekiq

  config.cache_store = :memory_store

  resolved_app_host = ENV["APP_HOST"].to_s.sub(%r{\Ahttps?://}, "").sub(%r{/\z}, "")
  smtp_domain = ENV.fetch("SMTP_DOMAIN", resolved_app_host).to_s.sub(%r{\Ahttps?://}, "").sub(%r{/\z}, "")

  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: resolved_app_host, protocol: "https" }

  if ENV["SMTP_ADDRESS"].present?
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              ENV["SMTP_ADDRESS"],
      port:                 ENV.fetch("SMTP_PORT", 587).to_i,
      user_name:            ENV["SMTP_USER_NAME"],
      password:             ENV["SMTP_PASSWORD"],
      domain:               smtp_domain,
      authentication:       :plain,
      enable_starttls_auto: true
    }
  else
    config.action_mailer.delivery_method = :test
  end

  config.action_mailer.raise_delivery_errors = false

  config.i18n.fallbacks = true

  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [:id]

  config.hosts << ".herokuapp.com"
end
