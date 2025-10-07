{config, ...}: {
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
                {
                  type = "rss";
                  title = "Rss Feeds";
                  cache = "1h";
                  feeds = [
                    {
                      url = "https://github.com/NixOS/nixpkgs/commits/nixpkgs-unstable.atom";
                      title = "Nixpkgs Unstable";
                    }
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
                  type = "custom-api";
                  title = "Beszel stats";
                  cache = "5m";
                  options = {
                    base-url = "\${BESZEL_URL}";
                    api-key = "\${BESZEL_TOKEN}";
                  };
                  template = ''
                    {{/* Required config options */}}
                    {{ $baseURL := .Options.StringOr "base-url" "" }}
                    {{ $apiKey := .Options.StringOr "api-key" "" }}

                    {{/* Error message template */}}
                    {{ define "errorMsg" }}
                      <div class="widget-error-header">
                        <div class="color-negative size-h3">ERROR</div>
                        <svg class="widget-error-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z"></path>
                        </svg>
                      </div>
                      <p class="break-all">{{ . }}</p>
                    {{ end }}

                    {{ define "formatGigabytes" }}
                      {{ $value := . }}
                      {{ $label := "GB" }}
                      {{- if lt $value 1.0 }}
                        {{ $value = mul $value 1000.0 }}
                        {{ $label = "MB" }}
                      {{- else if lt $value 1000.0 }}
                      {{ else }}
                        {{ $value = div $value 1000.0 }}
                        {{ $label = "TB" }}
                      {{ end }}
                      {{ printf "%.1f" $value }} <span class="color-base size-h5">{{ $label }}</span>
                    {{ end }}

                    {{/* Check required fields */}}
                    {{ if or (eq $baseURL "") (eq $apiKey "") }}
                      {{ template "errorMsg" "Some required options are not set." }}
                    {{ else }}

                      {{ $token := concat "Bearer " $apiKey }}

                      {{ $systemsResponse := newRequest (print $baseURL "/api/collections/systems/records")
                          | withHeader "Authorization" $token
                          | getResponse }}
                      {{ $systems := $systemsResponse.JSON.Array "items" }}


                      {{ range $n, $system := $systems }}
                        {{ $status := $system.String "status" }}

                        {{ $systemStatsRequest := newRequest (print $baseURL "/api/collections/system_stats/records")
                            | withHeader "Authorization" $token
                            | withParameter "sort" "-created"
                            | withParameter "page" "1"
                            | withParameter "perPage" "1"
                            | withParameter "filter" (print "type='1m'&&system='" ($system.String "id") "'")
                            | getResponse }}
                        {{ $systemStats := index ($systemStatsRequest.JSON.Array "items") 0 }}

                        {{ $hostname := $system.String "name" }}
                        {{ $uptimeSec := $system.Float "info.u" }}

                        {{ $systemTemp := $system.Float "info.dt"}}

                        {{ $cpuLoad := $system.Float "info.cpu" }}
                        {{ $cpuLoad1m := $system.Float "info.l1" }}
                        {{ $cpuLoad15m := $system.Float "info.l15" }}

                        {{ $memoryUsedPercent := $system.Float "info.mp" }}
                        {{ $memoryTotalGb := $systemStats.Float "stats.m" }}
                        {{ $memoryUsedGb := $systemStats.Float "stats.mu" }}

                        {{ $swapTotalGb := $systemStats.Float "stats.s" }}
                        {{ $swapUsedGb := $systemStats.Float "stats.su" }}
                        {{ $swapUsedPercent := mul (div $swapUsedGb $swapTotalGb) 100.0 }}

                        {{ $rootUsedPercent := $system.Float "info.dp" }}
                        {{ $rootTotalGb := $systemStats.Float "stats.d" }}
                        {{ $rootUsedGb := $systemStats.Float "stats.du" }}

                        <div class="server">
                          <div class="server-info">
                            <div class="server-details">
                              <div class="server-name color-highlight size-h3">{{ $hostname }}</div>
                              <div>
                                {{ if eq $status "up" }}
                                  <span>{{ printf "%.1f" (mul $uptimeSec 0.000011574) }}d</span> uptime
                                {{ else }}
                                  unreachable
                                {{ end }}
                              </div>
                            </div>
                            <div class="shrink-0"{{ if eq $status "up" }} data-popover-type="html" data-popover-margin="0.2rem" data-popover-max-width="400px"{{ end }}>
                              {{- if eq $status "up" }}
                              <div data-popover-html>
                                <div class="flex">
                                  <div class="size-h5 text-compact">Kernel</div>
                                  <div class="value-separator"></div>
                                  <div class="color-highlight">{{ $system.String "info.k" }}</div>
                                </div>
                                <div class="flex">
                                  <div class="size-h5 text-compact">CPU</div>
                                  <div class="value-separator"></div>
                                  <div class="color-highlight">{{ $system.String "info.m" }}</div>
                                </div>
                              </div>
                              {{- end }}
                              <svg class="server-icon" stroke="var(--color-{{ if eq $status "up" }}positive{{ else }}negative{{ end }})" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M21.75 17.25v-.228a4.5 4.5 0 0 0-.12-1.03l-2.268-9.64a3.375 3.375 0 0 0-3.285-2.602H7.923a3.375 3.375 0 0 0-3.285 2.602l-2.268 9.64a4.5 4.5 0 0 0-.12 1.03v.228m19.5 0a3 3 0 0 1-3 3H5.25a3 3 0 0 1-3-3m19.5 0a3 3 0 0 0-3-3H5.25a3 3 0 0 0-3 3m16.5 0h.008v.008h-.008v-.008Zm-3 0h.008v.008h-.008v-.008Z" />
                              </svg>
                            </div>
                          </div>

                          <div class="server-stats">
                            <div class="flex-1">
                              <div class="flex items-end size-h5">
                                <div>CPU</div>
                                {{- if ge $systemTemp 80.0 }}
                                <svg class="server-spicy-cpu-icon" fill="var(--color-negative)" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" >
                                  <path fill-rule="evenodd" d="M8.074.945A4.993 4.993 0 0 0 6 5v.032c.004.6.114 1.176.311 1.709.16.428-.204.91-.61.7a5.023 5.023 0 0 1-1.868-1.677c-.202-.304-.648-.363-.848-.058a6 6 0 1 0 8.017-1.901l-.004-.007a4.98 4.98 0 0 1-2.18-2.574c-.116-.31-.477-.472-.744-.28Zm.78 6.178a3.001 3.001 0 1 1-3.473 4.341c-.205-.365.215-.694.62-.59a4.008 4.008 0 0 0 1.873.03c.288-.065.413-.386.321-.666A3.997 3.997 0 0 1 8 8.999c0-.585.126-1.14.351-1.641a.42.42 0 0 1 .503-.235Z" clip-rule="evenodd" />
                                </svg>
                                {{- end }}
                                <div class="color-highlight margin-left-auto text-very-compact">{{ $cpuLoad }} <span class="color-base">%</span></div>
                              </div>
                              <div data-popover-type="html">
                                <div data-popover-html>
                                  <div class="flex">
                                    <div class="size-h5">1M AVG</div>
                                    <div class="value-separator"></div>
                                    <div class="color-highlight text-very-compact">{{ printf "%.1f" $cpuLoad1m }} <span class="color-base size-h5">%</span></div>
                                  </div>
                                  <div class="flex margin-top-3">
                                    <div class="size-h5">15M AVG</div>
                                    <div class="value-separator"></div>
                                    <div class="color-highlight text-very-compact">{{ printf "%.1f" $cpuLoad15m }} <span class="color-base size-h5">%</span></div>
                                  </div>
                                  <div class="flex margin-top-3">
                                    <div class="size-h5">TEMP C</div>
                                    <div class="value-separator"></div>
                                    <div class="color-highlight text-very-compact">{{ printf "%.1f" $systemTemp }} <span class="color-base size-h5">°</span></div>
                                  </div>
                                </div>

                                <div class="progress-bar progress-bar-combined">
                                  <div class="progress-value{{ if ge $cpuLoad1m 85.0 }} progress-value-notice{{ end }}" style="--percent: {{ $cpuLoad1m }}"></div>
                                  <div class="progress-value{{ if ge $cpuLoad15m 85.0 }} progress-value-notice{{ end }}" style="--percent: {{ $cpuLoad15m }}"></div>
                                </div>
                              </div>
                            </div>

                            <div class="flex-1">
                              <div class="flex justify-between items-end size-h5">
                                <div>RAM</div>
                                <div class="color-highlight text-very-compact">{{ $memoryUsedPercent }} <span class="color-base">%</span></div>
                              </div>
                              <div data-popover-type="html">
                                <div data-popover-html>
                                  <div class="flex">
                                    <div class="size-h5">RAM</div>
                                    <div class="value-separator"></div>
                                    <div class="color-highlight text-very-compact">
                                      {{ template "formatGigabytes" $memoryUsedGb }} <span class="color-base size-h5">/</span> {{ template "formatGigabytes" $memoryTotalGb }}
                                    </div>
                                  </div>
                                  {{- if gt $swapTotalGb 0.0 }}
                                  <div class="flex margin-top-3">
                                    <div class="size-h5">SWAP</div>
                                    <div class="value-separator"></div>
                                    <div class="color-highlight text-very-compact">
                                      {{ template "formatGigabytes" $swapUsedGb }} <span class="color-base size-h5">/</span> {{ template "formatGigabytes" $swapTotalGb }}
                                    </div>
                                  </div>
                                  {{- end }}
                                </div>
                                <div class="progress-bar progress-bar-combined">
                                  <div class="progress-value{{ if ge $memoryUsedPercent 85.0 }} progress-value-notice{{ end }}" style="--percent: {{ $memoryUsedPercent }}"></div>
                                  {{- if gt $swapTotalGb 0.0 }}
                                  <div class="progress-value{{ if ge $swapUsedPercent 85.0 }} progress-value-notice{{ end }}" style="--percent: {{ $swapUsedPercent }}"></div>
                                  {{- end }}
                                </div>
                              </div>
                            </div>

                            <div class="flex-1">
                              <div class="flex justify-between items-end size-h5">
                                <div>DISK</div>
                                <div class="color-highlight text-very-compact">{{ $rootUsedPercent }} <span class="color-base">%</span></div>
                              </div>
                              <div data-popover-type="html">
                                <div data-popover-html>
                                  <ul class="list list-gap-2">
                                    <li class="flex">
                                      <div class="size-h5">/</div>
                                      <div class="value-separator"></div>
                                      <div class="color-highlight text-very-compact">
                                        {{ template "formatGigabytes" $rootUsedGb }} <span class="color-base size-h5">/</span> {{ template "formatGigabytes" $rootTotalGb }}
                                      </div>
                                    </li>
                                    {{ range $key, $efs := ($systemStats.Get "stats.efs").Map }}
                                      <li class="flex">
                                        <div class="size-h5">{{ $key }}</div>
                                        <div class="value-separator"></div>
                                        <div class="color-highlight text-very-compact">
                                          {{ template "formatGigabytes" (($efs.Get "du").Float) }} <span class="color-base size-h5">/</span> {{ template "formatGigabytes" (($efs.Get "d").Float) }}
                                        </div>
                                      </li>
                                    {{ end }}
                                  </ul>
                                </div>
                                <div class="progress-bar progress-bar-combined">
                                  <div class="progress-value{{ if ge $rootUsedPercent 85.0 }} progress-value-notice{{ end }}" style="--percent: {{ $rootUsedPercent }}"></div>
                                  {{ range $key, $efs := ($systemStats.Get "stats.efs").Map }}
                                    {{ $efsTotalGb := (($efs.Get "d").Float) }}
                                    {{ $efsUsedGb := (($efs.Get "du").Float) }}
                                    {{ $efsPercent := mul (div $efsUsedGb $efsTotalGb) 100 }}
                                    <div class="progress-value{{ if ge $efsPercent 85.0 }} progress-value-notice{{ end }}" style="--percent: {{ $efsPercent }}"></div>
                                  {{ end }}
                                </div>
                              </div>
                            </div>

                          </div>
                        </div>
                      {{ end }}
                    {{ end }}
                  '';
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
                {
                  type = "custom-api";
                  title = "GitHub Notifications";
                  url = "https://api.github.com/notifications?all=true&per_page=20";
                  headers = {
                    Authorization = "Bearer \${GITHUB_TOKEN}";
                    Accept = "application/vnd.github+json";
                  };
                  template = ''
                    <ul class="list list-gap-14 collapsible-container" data-collapse-after="6">
                    {{ range .JSON.Array "" }}
                      {{ $url := concat (.String "repository.html_url") "/actions" }}
                      {{ if ne (.String "subject.url") "" }}
                        {{
                          $notification := newRequest (.String "subject.url")
                            | withHeader "Authorization" "Bearer ''${GITHUB_TOKEN}"
                            | getResponse
                        }}
                        {{ if eq $notification.Response.StatusCode 200 }}
                          {{ $url = $notification.JSON.String "html_url" }}
                        {{ else }}
                          {{ $url = (.String "subject.url") | replaceMatches "repos\\/" "" | replaceMatches "api\\." "" | replaceAll "pulls" "pull" }}
                        {{ end }}
                      {{ end }}
                      <li>
                        <a href="{{ $url }}" class="size-title-dynamic {{ if .Bool "unread" }}color-primary-if-not-visited{{ else }}negative-color{{ end }}" target="_blank" rel="noreferrer">{{ .String "subject.title" }}</a>
                        <ul class="list-horizontal-text flex-nowrap">
                          <li class="min-width-0" {{ .String "updated_at" | parseTime "rfc3339" | toRelativeTime }}></li>
                          <li class="min-width-0"><a target="_blank" href="{{ $url }}">{{ .String "repository.full_name" }}</a></li>
                        </ul>
                      </li>
                    {{ end }}
                    </ul>
                  '';
                }
              ];
            }
          ];
        }
        {
          name = "Gaming";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "twitch-top-games";
                  limit = 20;
                  collapse-after = 13;
                  exclude = [
                    "just-chatting"
                    "pools-hot-tubs-and-beaches"
                    "music"
                    "art"
                    "asmr"
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
                    {
                      type = "reddit";
                      show-thumbnails = true;
                      subreddit = "pcgaming";
                    }
                    {
                      type = "reddit";
                      subreddit = "games";
                    }
                  ];
                }
                {
                  type = "videos";
                  style = "grid-cards";
                  collapse-after-rows = 3;
                  channels = [
                    "UCNvzD7Z-g64bPXxGzaQaa4g" # GameRanx
                    "UCZ7AeeVbyslLM_8-nVy2B8Q" # Skill Up
                    "UCHDxYLv8iovIbhrfl16CNyg" # GameLinked
                    "UC9PBzalIcEQCsiIkq36PyUA" # Digital Foundry
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "reddit";
                  subreddit = "gamingnews";
                  limit = 7;
                  style = "vertical-cards";
                }
              ];
            }
          ];
        }
        {
          name = "SelfHosted Services";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "custom-api";
                  title = "Audiobookshelf";
                  title-url = "\${AUDIOBOOKSHELF_URL}";
                  options = {
                    base-url = "\${AUDIOBOOKSHELF_URL}";
                    api-key = "\${AUDIOBOOKSHELF_KEY}";
                  };
                  cache = "5m";
                  template = ''
                    {{ $baseURL := .Options.StringOr "base-url" "" }}
                    {{ $apiKey := .Options.StringOr "api-key" "" }}

                    {{ define "errorMsg" }}
                      <div class="widget-error-header">
                        <div class="color-negative size-h3">ERROR</div>
                        <svg class="widget-error-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z"></path>
                        </svg>
                      </div>
                      <p class="break-all">{{ . }}</p>
                    {{ end }}

                    {{ $bearer := printf "Bearer %s" $apiKey }}
                    {{ $librariesRequestURL := concat $baseURL "/api/libraries" }}
                    {{ $librariesResponse := newRequest $librariesRequestURL
                      | withHeader "Content-Type" "application/json"
                      | withHeader "Authorization" $bearer
                      | getResponse }}

                    {{ if $librariesResponse.JSON.Exists "libraries" }}
                      {{ $all_libraries := $librariesResponse.JSON.Array "libraries" }}

                      {{ $books_count := 0 }}
                      {{ $books_duration := 0 }}
                      {{ $podcasts_count := 0 }}
                      {{ $podcasts_duration := 0 }}

                      {{ range $library := $all_libraries }}
                        {{ $lib_id := $library.String "id" }}
                        {{ $lib_request_url := concat $baseURL "/api/libraries/" $lib_id "/stats"}}
                        {{ $lib_stats := newRequest $lib_request_url
                          | withHeader "Content-Type" "application/json"
                          | withHeader "Authorization" $bearer
                          | getResponse }}
                        {{ $lib_type := $library.String "mediaType" }}
                        {{ $lib_item_count := $lib_stats.JSON.Int "totalItems" }}
                        {{ $lib_total_duration := $lib_stats.JSON.Int "totalDuration" }}
                        {{ if eq $lib_type "book" }}
                          {{ $books_count = add $books_count $lib_item_count }}
                          {{ $books_duration = add $books_duration $lib_total_duration }}
                        {{ else if eq $lib_type "podcast" }}
                          {{ $podcasts_count = add $podcasts_count $lib_item_count }}
                          {{ $podcasts_duration = add $podcasts_duration $lib_total_duration }}
                        {{ end }}
                      {{ end }}

                      {{ $books_duration = duration (concat (printf "%d" $books_duration) "s") }}
                      {{ $podcasts_duration = duration (concat (printf "%d" $podcasts_duration) "s") }}

                      <div class="flex flex-column gap-5">
                        <div class="flex justify-between text-center">
                          <div>
                            <div class="color-highlight size-h3">{{ $books_count }}</div>
                            <div class="size-h5 uppercase">Books</div>
                          </div>
                          <div>
                            <div class="color-highlight size-h3">{{ $books_duration }}</div>
                            <div class="size-h5 uppercase">Duration</div>
                          </div>
                          <div>
                            <div class="color-highlight size-h3">{{ $podcasts_count }}</div>
                            <div class="size-h5 uppercase">Podcasts</div>
                          </div>
                          <div>
                            <div class="color-highlight size-h3">{{ $podcasts_duration }}</div>
                            <div class="size-h5 uppercase">Duration</div>
                          </div>
                        </div>
                      </div>
                    {{ else }}
                      {{ template "errorMsg" "Could not fetch data from API!" }}
                    {{ end }}
                  '';
                }
                {
                  type = "custom-api";
                  title = "Immich Stats";
                  cache = "1d";
                  url = "https://immich.cronyakatsuki.xyz/api/server/statistics";
                  headers = {
                    x-api-key = "\${IMMICH_API_KEY}";
                    Accept = "application/json";
                  };
                  template = ''
                    <div class="flex justify-between text-center">
                      <div>
                          <div class="color-highlight size-h3">{{ .JSON.Int "photos" | formatNumber }}</div>
                          <div class="size-h6">PHOTOS</div>
                      </div>
                      <div>
                          <div class="color-highlight size-h3">{{ .JSON.Int "videos" | formatNumber }}</div>
                          <div class="size-h6">VIDEOS</div>
                      </div>
                      <div>
                          <div class="color-highlight size-h3">{{ div (.JSON.Int "usage" | toFloat) 1073741824 | toInt | formatNumber }}GB</div>
                          <div class="size-h6">USAGE</div>
                      </div>
                    </div>
                  '';
                }
                {
                  type = "custom-api";
                  title = "Jellyfin Stats";
                  base-url = "\${JELLYFIN_URL}";
                  options = {
                    url = "\${JELLYFIN_URL}";
                    key = "\${JELLYFIN_KEY}";
                  };
                  template = ''
                    {{ $url := .Options.StringOr "url" "" }}
                    {{ $key := .Options.StringOr "key" "" }}

                    {{- if or (eq $url "") (eq $key "") -}}

                      <p>Error: The URL or API Key was not configured in the widget options.</p>

                    {{- else -}}

                      {{- $requestUrl := printf "%s/emby/Items/Counts?api_key=%s" $url $key -}}
                      {{- $jellyfinData := newRequest $requestUrl | getResponse -}}

                      {{- if eq $jellyfinData.Response.StatusCode 200 -}}
                        <div class="flex flex-column gap-5">
                          <div class="flex justify-between text-center">

                            <div>
                              <div class="color-highlight size-h3">{{ $jellyfinData.JSON.Int "MovieCount" | formatNumber }}</div>
                              <div class="size-h5 uppercase">Movies</div>
                            </div>

                            <div>
                              <div class="color-highlight size-h3">{{ $jellyfinData.JSON.Int "SeriesCount" | formatNumber }}</div>
                              <div class="size-h5 uppercase">TV Shows</div>
                            </div>

                            <div>
                              <div class="color-highlight size-h3">{{ $jellyfinData.JSON.Int "EpisodeCount" | formatNumber }}</div>
                              <div class="size-h5 uppercase">Episodes</div>
                            </div>

                            <div>
                              <div class="color-highlight size-h3">{{ $jellyfinData.JSON.Int "SongCount" | formatNumber }}</div>
                              <div class="size-h5 uppercase">Songs</div>
                            </div>

                          </div>
                        </div>
                      {{- else -}}
                        <p>Failed: {{ $jellyfinData.Response.Status }}</p>
                      {{- end -}}
                    {{- end -}}
                  '';
                }
              ];
            }
            {
              size = "full";
              widgets = [
              ];
            }
          ];
        }
      ];
    };
  };

  systemd.services.glance.serviceConfig = {
    EnvironmentFile = ["${config.age.secrets.glance.path}"];
  };
}
