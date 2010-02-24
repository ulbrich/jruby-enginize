# Adds a reduced version of the run method of the boot loader skipping stuff
# incompatible or unneeded on Google AppEngine.

class Merb::BootLoader
  
  # Just the same as the run method but with skipping some subclasses.

  def self.gaerun
    Merb.started = true

    ignored = ['Merb::BootLoader::Logger',
                'Merb::BootLoader::BackgroundServices',
                'Merb::BootLoader::ReloadClasses']
    
    subklasses = subclasses.dup

    until subclasses.empty?
      time = Time.now.to_i
      bootloader = subclasses.shift

      next if ignored.include? bootloader

      if (ENV['DEBUG'] || $DEBUG || Merb::Config[:verbose]) && Merb.logger
        Merb.logger.debug!("Loading: #{bootloader}")
      end

      Object.full_const_get(bootloader).run

      if (ENV['DEBUG'] || $DEBUG || Merb::Config[:verbose]) && Merb.logger
        Merb.logger.debug!("It took: #{Time.now.to_i - time}")
      end

      self.finished << bootloader
    end

    self.subclasses = subklasses
    nil
  end
end
