# istioctl allows you to retrieve information about proxy configuration using the proxy-config or pc command.

#For example, to retrieve information about cluster configuration for the Envoy instance in a specific pod:

istioctl proxy-config cluster <pod-name> [flags]

# To retrieve information about bootstrap configuration for the Envoy instance in a specific pod:

istioctl proxy-config bootstrap <pod-name> [flags]

# To retrieve information about listener configuration for the Envoy instance in a specific pod:

istioctl proxy-config listener <pod-name> [flags]

# To retrieve information about route configuration for the Envoy instance in a specific pod:

istioctl proxy-config route <pod-name> [flags]

# To retrieve information about endpoint configuration for the Envoy instance in a specific pod:

istioctl proxy-config endpoints <pod-name> [flags]
