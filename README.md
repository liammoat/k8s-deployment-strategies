# Kubernetes Deployment Strategies

A collection of example implementations for Kubernetes deployment strategies.

**Note:** These samples are intended for demonstration purposes only. We would not recommend referencing these for production consumption.

## Strategies

### Canary
Canary deployment strategy involves deploying new versions of application next to stable production versions to see how the canary version compares against the baseline before promoting or rejecting the deployment. 

1. [Kubernetes](./strategies/canary/01-kubernetes)
2. [Kubernetes with Helm](./strategies/canary/02-kubernetes-with-helm)
3. [Traffic Splitting with NGINX](./strategies/canary/03-traffic-splitting-with-nginx)
4. [Flagger with NGINX](./strategies/canary/04-flagger-with-nginx)

## Contributors

* **Liam Moat**

    * GitHub: [@liammoat](https://github.com/liammoat)
    * Twitter: [@liammoat](https://www.twitter.com/liammoat)
    * Website: [www.liammoat.com](https://www.liammoat.com)

* **Suren Mohandass**

    * GitHub: [@suren-m](https://github.com/suren-m)
