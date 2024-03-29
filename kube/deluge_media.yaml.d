apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: deluge-media
  namespace: kube-system
spec:
  repo: https://k8s-at-home.com/charts/
  chart: deluge
  targetNamespace: default
  valuesContent: |-
    additionalContainers:
      exporter:
        name: exporter
        image: tobbez/deluge_exporter:latest
        imagePullPolicy: IfNotPresent
        envFrom:
          - secretRef:
              name: deluge-exporter-env
        env:
          - name: DELUGE_HOST
            value: "{{.Release.Name}}-deluge-rpc"
          - name: DELUGE_PORT
            value: "58846"
        ports:
          - name: exporter
            containerPort: 9354
            protocol: TCP
    ingress:
      main:
        enabled: true
        hosts:
          - host: dl.vanderpot.net
            paths:
              - path: /
        annotations:
          traefik.ingress.kubernetes.io/router.middlewares: default-secured@kubernetescrd
    persistence:
      config:
        enabled: true
        type: hostPath
        hostPath: /zfs/home/torrent/config
      downloads:
        enabled: true
        type: hostPath
        hostPath: /bulk/home/torrent/data
    service:
      metrics:
        enabled: true
        primary: false
        type: ClusterIP
        ports:
          metrics:
            enabled: true
            protocol: TCP
            port: 9354
            targetPort: 9354
      rpc:
        enabled: true
        primary: false
        type: NodePort
        ports:
          rpc:
            enabled: true
            protocol: TCP
            port: 58846
            targetPort: 58846
            nodePort: 30847
      bt:
        enabled: true
        primary: false
        type: NodePort
        externalTrafficPolicy: Local
        ports:
          tcp:
            enabled: true
            protocol: TCP
            port: 30150
            nodePort: 30150
            targetPort: 30150
          udp:
            enabled: true
            protocol: UDP
            port: 30150
            nodePort: 30150
            targetPort: 30150
    affinity: &aff
      nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          nodeSelectorTerms:
            - matchExpressions:
                - key: kubernetes.io/hostname
                  operator: In
                  values:
                    - nixkube
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: deluge-media
  namespace: default
  labels:
    release: prometheus
spec:
  selector:
    matchLabels:
      app.kubernetes.io/instance: deluge-media
      app.kubernetes.io/name: deluge
  endpoints:
    - port: metrics