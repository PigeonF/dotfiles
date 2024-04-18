{
  flake.darwinModules = {
    pigeon =
      { inputs, pkgs, ... }:
      {
        home-manager.users.pigeon = inputs.self.homeModules.users.pigeon;

        users = {
          users.pigeon = {
            home = "/Users/pigeon";
            shell = pkgs.zsh;
          };
        };

        programs.zsh.enable = true;

        environment.userLaunchAgents = {
          _1password = {
            enable = true;
            target = "com.1password.SSH_AUTH_SOCK.plist";
            text = ''
              <?xml version="1.0" encoding="UTF-8"?>
              <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
              <plist version="1.0">
              <dict>
                <key>Label</key>
                <string>com.1password.SSH_AUTH_SOCK</string>
                <key>ProgramArguments</key>
                <array>
                  <string>/bin/sh</string>
                  <string>-c</string>
                  <string>/bin/ln -sf /Users/pigeon/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock $SSH_AUTH_SOCK</string>
                </array>
                <key>RunAtLoad</key>
                <true/>
              </dict>
              </plist>
            '';
          };
        };

        nix.settings.trusted-users = [ "pigeon" ];
      };
  };
}
