if ::File.exist?('/Users/shared/manage_touchid')
  node.default['cpe_touchid']['manage'] = true
end
