class Settings < Settingslogic
  source "#{Rails.root}/config/application.yml"
  namespace Rails.env

  def self.storage_settings
    #convert Settings.storage.s3 keys to symbols
    system = :s3
    Settings.storage[system].each_with_object({}){|(k,v), h| h[k.to_sym] = v}
        .merge({:styles=>Settings.storage.styles})
        .merge Settings.s3_credentials
  end

  def self.s3_credentials
    {:s3_credentials=>{:access_key_id   => ENV['S3_KEY'],
     :secret_access_key => ENV['S3_SECRET']}}
  end

end