module Indicator
  def self.table_name_prefix
    'indicator_'
  end
  
  def self.sync_device_instances
    Apiotics.sync_device_instances(self.name)
  end
  
  def self.sync_devices
    Apiotics.sync_device_instances(self.name, true)
  end
    
end