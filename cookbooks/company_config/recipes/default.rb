if ::File.exist?('/Users/Shared/manage_touchid')
  node.default['cpe_touchid']['manage'] = true
  node.default['cpe_touchid']['enable'] = true
end
