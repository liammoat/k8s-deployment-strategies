#### Flagger with Ingress

#### Note: This demo was originally created on AKS. There may be restrictions on private clusters especially around Ingress.

Since this demo doesn't use service mesh or grafana, use something like below to check for incoming traffic from fortio

```
kubectl logs pod/myapp-{podid} --follow -n canary-flagger             
```

Or check flagger's prometheus dashboard by port-forwarding to it (inside ingress-nginx ns)

```
kubectl port-forward service/flagger-pormetheus 9090 -n ingress-nginx
```

To manually check canary
```
port-forward service/myapp-canary 8080 -n canary-flagger
```

#### Doing canary deployments (Important)

* With Fortio (or any load testing tool), make sure to send traffic via ingress-controller 
* You can send the traffic to private-ip of the ingress-controller if needed as well.
* If you don't do this, canary deployments as there will not be enough requests to validate the success metrics defined in `canary.yaml`.

* It's highly recommended to Grafana or something similar to monitor the success rate instead of relying on logs during deployments.

#### Check recent events when things don't  go as expected

```
kubectl get ev -n canary-flagger -w
```

#### Enabling metrics

#### Common issues (no values found on nginx metric to canary)

See: 

* https://github.com/weaveworks/flagger/issues/421
* https://docs.flagger.app/v/master/tutorials/prometheus-operator

To ensure canary deployments are working as intended and traffic shifting happens correctly,
* Make sure that the traffic comes through to `app-canary` service 
* Make sure the app is monitored by `flagger-prometheus`. Flagger depends on this to make decisions, if this component is not working, then canary deployments will always fail. 
* Do a Port-forward on flagger/prometheus service in ingress-nginx namespace and ensure the app is registered as a target and is scraped correctly.

```
metrics:
- name: request-success-rate 
# minimum req success rate (non 5xx responses)percentage (0-100)        
    thresholdRange: 
    min: 99
    interval: 1m
- name: request-duration    # maximum req duration P99 milliseconds
    thresholdRange:
    max: 500
    interval: 1m
```