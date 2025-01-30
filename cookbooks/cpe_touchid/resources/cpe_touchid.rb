unified_mode true

resource_name :cpe_touchid
provides :cpe_touchid_configure, :os => 'darwin'

default_action :manage

action :manage do
  enable if node['cpe_touchid']['manage'] && node['cpe_touchid']['enable']
  disable if node['cpe_touchid']['manage'] && !node['cpe_touchid']['enable']
end

action_class do
  # https://dev.to/siddhantkcode/enable-touch-id-authentication-for-sudo-on-macos-sonoma-14x-4d28
  def enable
    # https://docs.chef.io/resources/template/
    template '/etc/pam.d/sudo_local' do
        source 'sudo_local.erb'
        owner 'root'
        group 'wheel'
        mode '0644'
        action :create
    end
  end
  def disable
    # pass
  end
end
