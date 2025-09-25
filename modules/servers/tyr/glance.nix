{
  services.glance = {
    enable = true;
    openFirewall = true;
    settings = {
      server = {
        host = "0.0.0.0";
      };
      pages = [
        {
          name = "Home";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "calendar";
                  first-day-of-week = "monday";
                }
                {
                  type = "twitch-channels";
                  channels = [
                    "theprimeagen"
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "group";
                  widgets = [
                    {type = "hacker-news";}
                    {type = "lobsters";}
                  ];
                }
                {
                  type = "server-stats";
                  servers = [
                    {
                      type = "local";
                      name = "Tyr";
                    }
                  ];
                }
                {
                  type = "videos";
                  channels = [
                    "UCR-DXc1voovS8nhAvccRZhg"
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "weather";
                  units = "metric";
                  hour-format = "24h";
                  location = "Otočac, Hrvatska";
                }
                {
                  type = "releases";
                  cache = "1d";
                  repositories = [
                    "glanceapp/glance"
                    "immich-app/immich"
                    "syncthing/syncthing"
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
