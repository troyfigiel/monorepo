{ username, ... }:

{
  config = {
    home-manager.users.${username}.home.sessionVariables = {
      TEST = "It works!";
    };
  };
}
