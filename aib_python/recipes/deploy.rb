include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'python'
    Chef::Log.debug("Skipping python deploy for application #{application} as it is not a python app")
    next
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
