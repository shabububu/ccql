require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ccql
  class Application < Rails::Application

    # The compile method (default in tinymce-rails 4.5.2) doesn't work when also
    # using tinymce-rails-imageupload, so revert to the :copy method
    # https://github.com/spohlenz/tinymce-rails/issues/183
    config.tinymce.install = :copy

    # Turn off async jobs (for development only) 
    # TODO: turn back on for production env
    config.active_job.queue_adapter = :inline

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.admin_mailer = config_for(:admin_mailer)

    # Overrides
    # TODO: If these work well, we should consider changing the other non-view monkey patching to be this way.
    config.to_prepare do
      Hyrax::WorkIndexer.prepend Hyrax::Vdc::WorkIndexerOverride
      Hyrax::CollectionIndexer.prepend Hyrax::Vdc::CollectionIndexerOverride
      Hyrax::CatalogSearchBuilder.prepend Hyrax::Vdc::CatalogSearchBuilderOverride
      Hyrax::My::CollectionsController.prepend Hyrax::My::Vdc::CollectionsControllerOverride
    end
    
  end
end
