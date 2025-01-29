# Using Chef the Facebook way

## Who is this tutorial for?

- Anyone who wants to learn how Facebook's way to use Chef. But particularly [Client Platform Engineers](https://kanenarraway.com/posts/client-platform-engineering/) who are new to Chef.

## Background

What is the Facebook way? Read over [https://github.com/facebook/chef-utils/blob/main/Philosophy.md](https://github.com/facebook/chef-utils/blob/main/Philosophy.md). It's okay if you don't understand most or even any of the content right now. Return to it after walking through this tutorial.

## Tutorial

### Prerequisites

Install [cinc](https://downloads.cinc.sh/files/stable/cinc), the fully open-source soft-fork of Chef, **or** [Chef Infra client](https://community.chef.io/downloads/tools/infra-client).

> If you use `cinc-client`, alias it to `chef-solo` to follow the tutorial.

```bash
alias chef-solo=cinc-solo
```

### Tutorial

#### Goal #1: Enable TouchID for sudo

1. Run `chef-solo` with quickstart.json from the root of this repository:

    ```
    sudo chef-solo -z -j quickstart.json --config-option cookbook_path=cookbooks
    ```

    This should produce output which contains the following:

    ```
    ...
    Recipe: cpe_touchid::default
    * cpe_touchid[Configure TouchID] action manage (up to date)

    Running handlers:
    Running handlers complete
    Infra Phase complete, 0/1 resources updated in 04 seconds
    ```

    So what happened? 
    
    Nothing happened yet (`0/1 resources updated`)!
    
1. But if we change `node.default['cpe_touchid']['manage'] = false` in [cookbooks/company_config/recipes/default.rb](cookbooks/company_config/recipes/default.rb) to `true`, then touch id for sudo should be enabled!

    1. Change `node.default['cpe_touchid']['manage']` to be `true`:

        ```diff
        # cookbooks/company_config/recipes/default.rb
        - node.default['cpe_touchid']['manage'] = false
        + node.defualt['cpe_touchid]['manage'] = true
        ``` 

    1. Run `chef-solo` again:

        ```
        sudo chef-solo -z -j quickstart.json --config-option cookbook_path=cookbooks
        ```

        Check the output to see what happened.

        ```
        ...
        Recipe: cpe_touchid::default
        * cpe_touchid[Configure TouchID] action manage
            * template[/etc/pam.d/sudo_local] action create
            - create new file /etc/pam.d/sudo_local
            - update content in file /etc/pam.d/sudo_local from none to 56fc33
            --- /etc/pam.d/sudo_local 2025-01-28 22:59:16.230962931 -0800
            +++ /etc/pam.d/.chef-sudo_local20250128-22138-hnwnce      2025-01-28 22:59:16.191995518 -0800
            @@ -1,3 +1,6 @@
            +# sudo_local: local config file which survives system update and is included for sudo
            +# uncomment following line to enable Touch ID for sudo
            +auth       sufficient     pam_tid.so
            - change mode from '' to '0644'
            - change owner from '' to 'root'
            - change group from '' to 'wheel'
        Running handlers:
        Running handlers complete
        Infra Phase complete, 2/2 resources updated in 06 seconds
        ```
        > Let's pause for a minute and walk through what happened:
        > - We changed a `node` attribute* (aka a feature flag) which causes `cpe_touchid` to change stuff.
        > - Why does this cause `cpe_touchid` to get activated? Take a look at [the cpe_touchid resource](cookbooks/cpe_touchid/resources/cpe_touchid.rb) source code: 

        ```ruby
        default_action :manage

        action :manage do
            manage if node['cpe_touchid']['manage']
        end

        action_class do
            def manage
                # https://docs.chef.io/resources/template/
                template '/etc/pam.d/sudo_local' do
                    source 'sudo_local.erb'
                    owner 'root'
                    group 'wheel'
                    mode '0644'
                    action :create
                end
            end
        end
        ```









