instance="http://127.0.0.1:8383"

files=$(curl -s "$instance"/files/)

# Check for keygens on server
if echo "$files" | grep -i "keygen" >> /dev/null; then
  for file in $(echo "$files" | grep -i "keygen"); do
    echo "Deleting file $file"
    curl -X DELETE "$instance/files/$file"
  done
fi

# Delete common php payloads
if echo "$files" | grep -i ".php" >> /dev/null; then
  for file in $(echo "$files" | grep -i ".php"); do
    if curl -s "$instance/files/$file" | grep -i "base64_decode" >> /dev/null; then
      echo "Found payload, deleting file $file"
      curl -X DELETE "$instance/files/$file"
    fi
  done
fi

# Delete kernel object files
if echo "$files" | grep -iE ".*.ko" >> /dev/null; then
  for file in $(echo "$files" | grep -iE ".*.ko"); do
    echo "Deleting file $file"
    curl -X DELETE "$instance/files/$file"
  done
fi
