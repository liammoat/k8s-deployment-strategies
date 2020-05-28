# Kubernetes Deployment Strategies
A collection of example implementations for Kubernetes deployment strategies.

## Strategies

### Canary
Canary deployment strategy involves deploying new versions of application next to stable production versions to see how the canary version compares against the baseline before promoting or rejecting the deployment. 

1. [Kubernetes Native](./strategies/canary/01-kubernetes-native)
2. [Helm](./strategies/canary/02-helm)
3. [Traffic Splitting with Ingress](./strategies/canary/03-traffic-splitting-with-ingress)
4. [Service Mesh](./strategies/canary/04-service-mesh)

## Please note
These samples are intended for demonstration purposes only. We would not recommend referencing these for production consumption.

## Contributors

* **Liam Moat**

    * GitHub: [@liammoat](https://github.com/liammoat)
    * Twitter: [@liammoat](https://www.twitter.com/liammoat)
    * Website: [www.liammoat.com](https://www.liammoat.com)

* **Suren Mohandass**

    * GitHub: [@surenmcode](https://github.com/surenmcode)
