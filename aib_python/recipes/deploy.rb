include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  
  Chef::Log.info("Stuff: #{deploy[:application_type]}")
  if deploy[:application_type] != 'custom'
    Chef::Log.info("Skipping python deploy for application #{application} as it is not a python app")
    next
  end
  
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end
  
  opsworks_deploy do
    deploy_data deploy
    app application
  end
  
  venv_options = deploy["venv_options"] || node["deploy_python"]["venv_options"]
  venv_path = ::File.join(deploy[:deploy_to], "shared", "env")
  node.normal[:deploy][application]["venv"] = venv_path
  python_virtualenv "#{application}-venv" do
    path venv_path
    owner deploy[:user]
    group deploy[:group]
    options venv_options
    action :create
  end
end
