# Kubernetes Deployment Strategies
A collection of example implementations for Kubernetes deployment strategies.

## Strategies

### Canary
Canary deployment strategy involves deploying new versions of application next to stable production versions to see how the canary version compares against the baseline before promoting or rejecting the deployment. 

1. [Kubernetes Native](./strategies/canary/01-kubernetes-native)
2. [Helm](./strategies/canary/02-helm)
3. [Traffic Splitting with Ingress](./strategies/canary/03-traffic-splitting-with-ingress)
4. [Flagger with Nginx Ingress Controller](./strategies/canary/04-flagger-with-nginx)
5. [Flagger with Service Mesh](./strategies/canary/05-flagger-with-servicemesh)

## Please note
These samples are intended for demonstration purposes only. We would not recommend referencing these for production consumption.

## Contributors

* **Liam Moat**

    * GitHub: [@liammoat](https://github.com/liammoat)
    * Twitter: [@liammoat](https://www.twitter.com/liammoat)
    * Website: [www.liammoat.com](https://www.liammoat.com)

* **Suren Mohandass**

    * GitHub: [@suren-m](https://github.com/suren-m)
