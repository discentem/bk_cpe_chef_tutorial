# always manage touchid
node.default['cpe_touchid']['manage'] = true
# if we delete this file, we'll turn off touchid
if ::File.exist?('/Users/Shared/manage_touchid')
  node.default['cpe_touchid']['enable'] = true
end
