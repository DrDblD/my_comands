# stable single container deployment for guttenberg (1 cpu 2Gb mem)
docker stop gotenberg && echo "stop gotenberg - ok" || echo "stop gotenberg failure"
docker rm gotenberg && echo "rm gotenberg - ok" || echo "rm gotenberg failure"
docker run -d -it --restart=on-failure --name=gotenberg -p=80:3000 gotenberg/gotenberg:7 \
       gotenberg \
       --api-disable-health-check-logging \
       --prometheus-disable-collect \
       --log-level=debug \
       --uno-listener-restart-threshold=0 \
       --uno-listener-start-timeout=20s \
       --api-timeout=30s