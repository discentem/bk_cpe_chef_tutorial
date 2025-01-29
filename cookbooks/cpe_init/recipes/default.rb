run_list = []

if node.macos?
  run_list += [
    'company_config',
    # cpe_touchid must be included after company_config because 
    # it is an 'API' that consumes the node attributes set in 
    # company_config
    'cpe_touchid',
  ]
end

# Include all cookbooks from the run_list
run_list.uniq.each do |recipe|
  include_recipe recipe
end