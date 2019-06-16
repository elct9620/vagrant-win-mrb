# frozen_string_literal: true

Vagrant.configure('2') do |config|
  # Configure for Windows
  config.vm.box = 'elct9620/win10-base'
  config.vm.guest = :windows
  config.vm.communicator = 'winrm'

  # Allow RDP
  config.vm.network 'forwarded_port', guest: 3389, host: 3389

  # Setup mruby compile environment
  config.vm.provision :shell, path: 'provision.ps1'
  profile_name = 'Microsoft.PowerShell_profile.ps1'
  profile_path = 'C:\\Users\\vagrant\\Documents' \
                 "\\WindowsPowerShell\\#{profile_name}"
  config.vm.provision :shell, inline: 'Set-ExecutionPolicy RemoteSigned'
  config.vm.provision :file, source: profile_name,
                             destination: profile_path
  config.vm.provision :shell, inline: 'Restart-Service -Name sshd'

  config.vm.provider 'virtualbox' do |v|
    v.memory = 2048
    v.cpus = 2
  end
end
