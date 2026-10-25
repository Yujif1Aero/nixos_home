{
  programs = {
    firefox.enable = true;
    firefox.configPath = ".mozilla/firefox";
    google-chrome.enable = true;
    vivaldi = {
      enable = true;
      commandLineArgs = ["--enable-features=WebUIDarkMode" "--force-dark-mode"];
    };
  };
}
