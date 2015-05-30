if Rails.env.development?
  require 'yaml'
  yaml_data = YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'application.yml'))).result)
  HashWithIndifferentAccess.new(yaml_data).map { |k,v| ENV[k] = v }
end
