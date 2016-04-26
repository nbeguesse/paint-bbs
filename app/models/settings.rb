class Settings < Settingslogic
  source "#{Rails.root}/config/application.yml"
  namespace Rails.env

  def self.storage_settings
    #convert Settings.storage.s3 keys to symbols
    system = Settings.storage_system
    Settings.storage[system].each_with_object({}){|(k,v), h| h[k.to_sym] = v}.merge({:styles=>Settings.storage.styles})
  end

end