namespace :template do
  desc "Update templates in configuration file"
  task :update do
    config_file = FileList.new('config.y?ml').first
    config = Cog::Config.new(config_file)

    puts "Current bundle configuration version is #{config['version']}."

    templates = FileList.new('templates/*/*.mustache')
    return if templates.nil? || templates.size == 0

    config['templates'] ||= {}
    templates.each do |file|
      (provider, template) = file.split('/')[-2..-1]
      template.gsub!(/\.mustache\z/, '')
      template_content = File.read(file)

      config['templates'][provider] ||= {}
      prev_content = config['templates'][provider][template]

      if template_content != prev_content
        puts "Updating bundle configuration for template #{provider}/#{template}."
        config['templates'][provider][template] = template_content
      end
    end

    if config.stale?
      config.update_version
      puts "Writing new configuration file for version #{config['version']}."
      config.save
    else
      puts "No updated templates found. Configuration not updated."
    end
  end
end
