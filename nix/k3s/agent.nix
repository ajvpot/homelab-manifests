{ config, lib, pkgs, ... }:
{
  imports = [ ./. ];

  services.k3s.role = "agent";
  services.k3s.tokenFile = "/node-token";
  services.k3s.serverAddr = "https://10.10.10.112:6443";
  services.k3s.extraFlags = "--container-runtime-endpoint unix:///run/containerd/containerd.sock";
}
