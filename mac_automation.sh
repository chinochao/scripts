#!/bin/bash
#
# Roberto Chaud 
# https://github.com/chinochao/scripts
# 
#
# Description: A bash script to install packages to a new Mac system.

BIN_PATH="$HOME/bin"

get_arch() {
  local arch=$(uname -m)
  if [ "$arch" == "x86_64" ]; then
    echo "amd64"
  elif [ "$arch" == "arm64" ]; then
    echo "arm64"
  else
    echo "Unknown architecture: $arch_value"
    exit 1
  fi
}

final() {
  source $HOME/.bash_profile
}

kubectl() {
    echo "## Installing kubectl"
    cmd_path="$BIN_PATH/kubectl"
    arch=$(get_arch)
    version=$(curl -L -s https://dl.k8s.io/release/stable.txt)
    curl -sL -o "$cmd_path" "https://dl.k8s.io/release/$version/bin/darwin/$arch/kubectl"
    chmod 0755 "$cmd_path"
    echo " - Installed kubectl $version $arch"
}

kubesw() {
    echo "## Installing kubesw"
    cmd_path="$BIN_PATH/kubesw"
  ,m/    cat << EOF > "$cmd_path"
#!/bin/bash
unset options i
while IFS= read -r -d $'\0' f; do
  options[i++]="\$f"
done < <(find \$HOME/.kube -maxdepth 1 -type f -print0 )

select opt in \${options[@]} "Quit"; do
  case \$opt in
    "Quit")
      echo "Quitting script"
      break
      ;;
    \$opt)
      echo "Selected Kubernetes config: \$opt"
      KUBECONFIG="\$opt"
      export KUBECONFIG
      kubectl get ns -o wide
      kubectl get nodes -o wide
      break
      ;;
    *)
      echo "Not available"
      ;;
  esac
done
EOF
    chmod 0755 "$cmd_path"
    echo " - Installed kubesw"
}

k3sup() {
    echo "## Installing k3sup"
    git_repo="alexellis/k3sup"
    cmd_path="$BIN_PATH/k3sup"
    version=$(curl -L -s https://github.com/$git_repo/releases/latest | grep "repo_releases" | grep -o 'href="[^"]*"' | awk -F'/' ' {print $5}' | tr -d '"')
    arch=$(get_arch)
    curl -sL -o "$cmd_path" "https://github.com/$git_repo/releases/download/$version/k3sup-darwin$value"
    chmod 0755 "$cmd_path"
    echo " - Installed k3sup $version $arch"
}

# terraform() {
#     echo "## Installing terraform"
#     cmd_path="$BIN_PATH/terraform"
#     version=$(curl -L -s "https://developer.hashicorp.com/terraform/install" | grep -o '(latest).*(latest)' | grep -o 'value="[^"]*"' | awk -F'"' '{print $2}')
#     arch=$(get_arch)
#     curl -sL -o "$cmd_path" "https://releases.hashicorp.com/terraform/${version}/terraform_${version}_darwin_${arch}.zip"
#     chmod 0755 "$cmd_path"
#     echo " - Installed terraform $version $arch"
# }

all() {
    kubectl
    kubesw
    k3sup
    final
}

case "$1" in
        all)
            all
            ;;
        kubectl)
            kubectl
            final
            ;;
        kubesw)
            kubesw
            final
            ;;
        k3sup)
            k3sup
            final
            ;;
        # terraform)
        #     terraform
        #     final
        #     ;;
        *)
            echo ""
            echo "            Usage  .:.  mac_automation.sh \$arg1"
            echo "-----------------------------------------------------"
            echo "all            = Install all"
            echo "kubectl        = Command line tool"
            echo "kubesw         = Command to pick/set KUBECONFIG"
            echo "k3sup          = Deploy K3s in seconds"
            echo "terraform      = Infrastructure as Code"
            echo ""
            exit 1
 
esac

# Terraform
# Ansible but doesnt use binary                  