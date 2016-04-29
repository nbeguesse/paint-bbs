class Settings < Settingslogic
  source "#{Rails.root}/config/application.yml"
  namespace Rails.env

  def self.storage_settings(image=true)
    #convert Settings.storage.s3 keys to symbols
    system = Rails.env.production? ? :s3 : :filesystem
    out = Settings.storage[system].each_with_object({}){|(k,v), h| h[k.to_sym] = v}
        .merge({:s3_credentials=>{:access_key_id   => ENV['S3_KEY'],
        :secret_access_key => ENV['S3_SECRET']}})
    if image
      out = out.merge({:styles=>Settings.storage.styles})
    end
    out
  end



end