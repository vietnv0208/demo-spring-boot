max_attempts=2000
retry_interval=1
link_url=http://localhost:31000

#sleep first
sleep $retry_interval
attempt=1
while [ $attempt -le $max_attempts ]; do
  kubectl get pod
  curl -X get $link_url
  curl  $link_url
  sleep $retry_interval
  attempt=$((attempt + 1))

done
echo "Done $max_attempts."
exit 1
