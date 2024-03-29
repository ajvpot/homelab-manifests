apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: zigbee2mqtt
  namespace: kube-system
spec:
  repo: https://k8s-at-home.com/charts/
  chart: zigbee2mqtt
  targetNamespace: default
  valuesContent: |-
    config:
      homeassistant: true
      permit_join: false
      mqtt:
        server: "mqtt://mosquitto:1883"
      serial:
        port: "tcp://ser2sock:10000"
    ingress:
      main:
        enabled: true
        hosts:
          - host: zigbee2mqtt.vanderpot.net
            paths:
              - path: /
        annotations:
          traefik.ingress.kubernetes.io/router.middlewares: default-secured@kubernetescrd
    persistence:
      data:
        enabled: true
        storageClass: local-path
        accessMode: ReadWriteOnce
        size: 2Gi
        annotations:
          "helm.sh/resource-policy": keep
    affinity: &aff
      nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          nodeSelectorTerms:
            - matchExpressions:
                - key: kubernetes.io/hostname
                  operator: In
                  values:
                    - nixkube