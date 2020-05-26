```
# Default values for service
# This is a YAML-formatted file.
# Do not change values here, utilize external files functionality to override default values

# Amount of instances of service to run
replicaCount: 1

# Limit used to set Container limit
# Xms and Xmx options calculated as:
# (Xmx and Xms) = memory_limit-memory_percent
# NOTE:
#  This is used only for Java/Scala applications
#  if `java_app = true`
#  Then you will have 3 env variables (for backwards compatibility), all variables will have the same value
#  JAVA_MEMORY=1234m
#  JAVA_XMX=1234m
#  JAVA_XMS=1234m
#  if `java_app = false`, then you can use memory request/limit from the section below (only applicable if `java = false`)
java_app: true
memory_limit: 1024
memory_percent: 20

# Set CPU Limits only
# Memory calculation is done in the template based on the Java Memory limit above
# Memory parameter can be used only if `java_app = false`
resources:
  limits:
    cpu: "0.1"
    # memory: 256Mi
  requests:
    cpu: "0.1"
    # memory: 256Mi

# https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
securityContext: {}
  # fsGroup: 1000
      

# How to manage deployment upgrades
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 0

# Image location and default tag for the service
image:
  repository: docker.tntdigital.io/tnt/<CHARTNAME>
  tag: master
  pullPolicy: IfNotPresent

# Service configuration
service:
  type: ClusterIP
  # If you need Headless Service then uncomment it (or override with custom values)
  # clusterIp: None

# Container Configuration
# By default should be at least one section, which represents the app/service running inside the container
# containerPort - The port the app/service is listening on and where the Kubernetes Service will send traffic
# servicePort   - The port the Kubernetes Service is listening on (all traffic comes to this port and is then distributed to the Pods with container(s))
# name          - Name of the port, should be uniqe per object. In short: used for discovery inside Kubernetes to connect Services and Pods together
container:
  ports:
    - name: http
      containerPort: 8080
      servicePort: 80
      protocol: TCP

# Container environment variables
extraVars: []
# - name: EXAMPLE_VAR_1
#   value: "example-value"

# https://kubernetes.io/docs/concepts/configuration/secret/#use-case-as-container-environment-variables
extraVarsFrom: []
  # - secretRef:
  #     name: mysecret

# Liveness and Readiness Checks
# https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.11/#probe-v1-core
# https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
# NOTE: to disable one of the checks set it to 'null'
#       in order to add another type of probe the existing ones need to be set to null, because you cannot have multiple probes
healthChecks:
  livenessProbe:
    httpGet:
      path: /echo/alive
      port: http
      scheme: HTTP
    # initialDelaySeconds: 10
    # failureThreshold: 3
    # periodSeconds: 10
    # successThreshold: 1
    # timeoutSeconds: 1
  readinessProbe:
    httpGet:
      path: /echo/ready
      port: http
      scheme: HTTP
    # initialDelaySeconds: 10
    # failureThreshold: 3
    # periodSeconds: 10
    # successThreshold: 1
    # timeoutSeconds: 1

# Ingress Controllers
# Service and Namespace Support two different Ingress Controllers
# The template allows you to have multiple Ingress rules and those rules can be bound to different Ingress Controllers
# The name of Ingress rule is a Key, while you are free to pick any name you want, try to keep it short, because it can be used as a suffix for automation
# Options:
#   enabled      - if set to 'true' it tells the template to generate an ingress rule for the specific ingress controller
#   annotations  - list of Key:Value options to instruct the ingress controller and other resources on what and how to deal with this ingress
#                 For example instructing external DNS to create additional hostnames for this ingress
#                 and/or which Certificate manager to use to enable SSL Certificate for HTTPS
#   suffix       - this is only used if 'host' is not set and 'clusterFqdn' is in use. We can then generate the main ingress hostname automatically (NameOfIngress)
#   clusterFqdn  - this is required when allowing the template to automatically generate the 'host' value (not applicable for extra `hosts`)
#   host         - FQDN hostname to use with this release, if specified this will disable automatic hostname generation
#   port         - ServicePort of the Service for the container (named or as integer if you know what you are doing)
#   path         - same meaning as location in nginx (default / )
#   tls          - enable HTTPS for the ingress rule only needed if certificate generation is not part of the ingress controller
#                             NOTE:
#                               * Some ingress controllers can handle TLS completely on their own (like Traefik, so in this case TLS can be left disabled)
#                               * Additional Hostnames have their own TLS/Port definitions)
#   secretName   - This is used with the `tls` option to override the name of the secret where our certificate is located (for example if we have created the certificates manually)
#
#   hosts           - object of additional hostnames attached to this service (per ingress, names should be unique)
#     host          - hostname (FDQN), if not set, a rule wont be created
#     path          - same meaning as location in nginx (default / )
#     port          - by default should be the same value as the service port (if empty, the template uses the port defined for the main domain)
#     secretName    - This is used with the `tls` option to override the name of the secret where our certificate is located (for example if we have created the certificates manually)
#     serviceName   -  By default this is the same as the main ingress domain, change this only if you know what are you doing

# hostNameOverride  - can be used if the name of the server is too long and you want to have a shorter version
#                     you must set clusterFqdn and unset host in order for hostNameOverride to work
#                     your hostname will look like the below (NameOfIngress if suffix: true):
#                      * If hostNameOverride is empty - <ReleaseName>-<NameSpace>[-<NameOfIngress>].clusterFqdn
#                      * If hostNameOverride is set   - <hostNameOverride>-<NameSpace>[-<NameOfIngress>].clusterFqdn

hostNameOverride: ""
ingress:
  internal:
    enabled: false
    suffix: false
    clusterFqdn: ""
    host: ""
    path: "/"
    port: http
    tls: false
    secretName: ""
    annotations: {}
    hosts: {}
      # - host: some-extra.hostname.here
      #   path: /
      #   port: http
      #   secretName: ""
      #   serviceName: ""
      # - host: some-other-extra.hostname.here
      #   path: /
      #   port: http
      #   secretName: ""
      #   serviceName: ""

## This is to Enable Or Disable deployment of ServiceMonitor to configure Prometheus scrape metrics for this deployment
serviceMonitor:
  enabled: false
  path: /metrics
  port: http
  interval: 30s
  metricRelabelings: []
    # # Example
    # - action: replace
    #   regex: (.*):.*
    #   replacement: ${1}
    #   sourceLabels:
    #     - instance
    #   targetLabel: instance
  ## Provides capabilities to add Extra Endpoints with their own parameters to scrape metrics
  extraEndpoints: []
    # # Example of extra endpoint
    # - honorLabels: true
    #   interval: 30s
    #   path: /custom-metrics
    #   port: http
    #   metricRelabelings: []

nodeSelector: {}

tolerations: []

affinity: {}

# The branch we are deploying to, to be overridden with --set during deployment
branch: master

restart: now
```