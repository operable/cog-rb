config_file = FileList.new('config.y?ml').first
config = Cog::Config.new(config_file)
docker_image = config['docker'].nil? ? nil : "#{config['docker']['image']}:#{config['docker']['tag']}"

namespace :template do
  desc "Update templates in configuration file"
  task :update do
    puts "Current bundle configuration version is #{config['version']}."

    templates = FileList.new('templates/*')
    return if templates.nil? || templates.size == 0

    config['templates'] ||= {}
    templates.each do |file|
      (provider, template) = file.split('/')[-2..-1]
      template.gsub!(/\..*\z/, '')
      template_content = File.read(file)

      config['templates'][template] ||= {}
      prev_content = config['templates'][template]['body']

      if template_content != prev_content
        puts "Updating bundle configuration for template #{provider}/#{template}."
        config['templates'][template]['body'] = template_content
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

namespace :docker do
  task :preflight do
    if docker_image.nil?
      puts "No Docker image defined in bundle configuration. Aborting."
      exit(1)
    end
  end

  desc "Build Docker image for current configuration file"
  task :build => [ :preflight ] do
    system("docker", "build", "-t", docker_image, ".")
  end

  desc "Push updated Docker image"
  task :push => [ :build ] do
    system("docker", "push", docker_image)
  end

  desc "Build and push updated Docker image"
  task :release => [ :build, :push ]
end
