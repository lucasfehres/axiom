# the user agent is a lie
microsoft-edge \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu-sandbox \
  --in-process-gpu \
  --user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0" \
  --override-enabled-profile-template-with-empty-profile \
  "$@"
