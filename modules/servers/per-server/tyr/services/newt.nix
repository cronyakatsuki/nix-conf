{config, ...}: {
  services.newt = {
    enable = true;

    # Path to the file containing NEWT_ID and NEWT_SECRET
    environmentFile = "${config.age.secrets.newt-env.path}";

    settings = {
      endpoint = "https://pangolin.cronyakatsuki.xyz";
    };
  };
}
