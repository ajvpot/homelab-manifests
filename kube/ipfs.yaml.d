---
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: ipfs
  namespace: kube-system
spec:
  repo: https://charts.jmmaloney4.xyz/
  chart: ipfs
  targetNamespace: default
  valuesContent: |-
    ingress:
      webui:
        enabled: true
        serviceName: api
        hosts:
          - host: ipfs.vanderpot.net
            paths:
              - path: "/"
        annotations:
          traefik.ingress.kubernetes.io/router.middlewares: default-secured@kubernetescrd
    env:
      IPFS_PATH: /data
      TZ: UTC
    config:
      Identity:
        PeerID: 12D3KooWC7LWRmgdafofcPkKiNgN1WLhRpczn7ijHHvQMnk1MLdV
      Datastore:
        StorageMax: 32TB
        StorageGCWatermark: 90
        GCPeriod: 1h
        Spec:
          mounts:
            - child:
                path: blocks
                shardFunc: "/repo/flatfs/shard/v1/next-to-last/2"
                sync: true
                type: flatfs
              mountpoint: "/blocks"
              prefix: flatfs.datastore
              type: measure
            - child:
                compression: none
                path: datastore
                type: levelds
              mountpoint: "/"
              prefix: leveldb.datastore
              type: measure
          type: mount
        HashOnRead: false
        BloomFilterSize: 0
      Addresses:
        Swarm:
          - "/ip4/0.0.0.0/tcp/4001"
          - "/ip6/::/tcp/4001"
          - "/ip4/0.0.0.0/udp/4001/quic"
          - "/ip6/::/udp/4001/quic"
        Announce: []
        AppendAnnounce: []
        NoAnnounce: []
        API: "/ip4/0.0.0.0/tcp/5001"
        Gateway: "/ip4/0.0.0.0/tcp/8080"
      Discovery:
        MDNS:
          Enabled: true
          Interval: 10
      Routing:
        Type: dht
      Ipns:
        RepublishPeriod: ''
        RecordLifetime: ''
        ResolveCacheSize: 128
      Bootstrap:
        - "/dnsaddr/bootstrap.libp2p.io/p2p/QmNnooDu7bfjPFoTZYxMNLWUQJyrVwtbZg5gBMjTezGAJN"
        - "/dnsaddr/bootstrap.libp2p.io/p2p/QmQCU2EcMqAqQPR2i9bChDtGNJchTbq5TbXJJ16u19uLTa"
        - "/dnsaddr/bootstrap.libp2p.io/p2p/QmbLHAnMoJPWSCR5Zhtx6BHJX9KiKNN6tpvbUcqanj75Nb"
        - "/dnsaddr/bootstrap.libp2p.io/p2p/QmcZf59bWwK5XFi76CZX8cbJ4BhTzzA3gU1ZjYZcYW3dwt"
        - "/ip4/104.131.131.82/tcp/4001/p2p/QmaCpDMGvV2BGHeYERUEnRQAwe3N8SzbUtfsmvsqQLuvuJ"
        - "/ip4/104.131.131.82/udp/4001/quic/p2p/QmaCpDMGvV2BGHeYERUEnRQAwe3N8SzbUtfsmvsqQLuvuJ"
      Gateway:
        HTTPHeaders:
          Access-Control-Allow-Headers:
            - X-Requested-With
            - Range
            - User-Agent
          Access-Control-Allow-Methods:
            - GET
          Access-Control-Allow-Origin:
            - "*"
        RootRedirect: ''
        Writable: false
        PathPrefixes: []
        APICommands: []
        NoFetch: false
        NoDNSLink: false
        PublicGateways:
      API:
        HTTPHeaders: {}
      Swarm:
        AddrFilters:
        DisableBandwidthMetrics: false
        DisableNatPortMap: false
        RelayClient: {}
        RelayService: {}
        Transports:
          Network: {}
          Security: {}
          Multiplexers: {}
        ConnMgr:
          Type: basic
          LowWater: 600
          HighWater: 900
          GracePeriod: 20s
      AutoNAT: {}
      Pubsub:
        Router: ''
        DisableSigning: false
      Peering:
        Peers:
      DNS:
        Resolvers: {}
      Migration:
        DownloadSources: []
        Keep: ''
      Provider:
        Strategy: ''
      Reprovider:
        Interval: 12h
        Strategy: all
      Experimental:
        FilestoreEnabled: false
        UrlstoreEnabled: false
        GraphsyncEnabled: false
        Libp2pStreamMounting: false
        P2pHttpProxy: false
        StrategicProviding: false
        AcceleratedDHTClient: false
      Plugins:
        Plugins:
      Pinning:
        RemoteServices: {}
      Internal: {}
    persistence:
      data:
        enabled: true
        type: hostPath
        hostPath: /bulk/home/kube/ipfs
        mountPath: /data
    affinity: &aff
      nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          nodeSelectorTerms:
            - matchExpressions:
                - key: kubernetes.io/hostname
                  operator: In
                  values:
                    - nixkube
