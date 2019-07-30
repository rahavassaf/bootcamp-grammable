CarrierWave.configure do |config|
  config.ignore_integrity_errors = false
  config.ignore_processing_errors = false
  config.ignore_download_errors = false
  config.root = "#{Dir.pwd}/public" 


  if Rails.env.staging? || Rails.env.production?
    config.fog_provider = 'fog/google' 

    config.fog_credentials = {
      provider: 'Google',
      google_project: 'genuine-ridge-242303',
      google_json_key_string: ENV['GCS_KEY_JSON'],
    }

    config.fog_directory = 'grammable-assaf-rahav'

    config.fog_public = false
  else
    config.storage = :file
  end
end