def call (Map config = [:]) {

/*
  USAGE:
  helmDeploy(environment: 'nonprod', stage: 'dev' )
    environment       - the kubernetes cluster to deploy to
    namespace         - the namespace to deploy to, optional
    serviceName       - application/service name, used to name the helm release
    stage             - decides which values.yaml to use from helm-release/<STAGE>.yaml, also identifies which namespace to deploy to when namespace not specified
    dockerImageName   - docker image to deploy
    dockerTag         - docker image tag/version to deploy
    dockerRegistry    - docker registry where the image is store
    chart             - chart to use when deploying, defaults to 'tnt-apps/apps-generic-chart'
    helmImage         - the docker image used to run helm commands, defaults to 'nexus-repo.tntad.fedex.com/alpine/helm:2.15.2'
    kubectlImage      - the docker image used to run kubectl commands, defaults to 'nexus-repo.tntad.fedex.com/kubectl:1.16'
*/

  def deployment = [
    environment: (config.environment != null) ? config.environment : (env.DEPLOY_ENVIRONMENT != null) ? env.DEPLOY_ENVIRONMENT : 'nonprod',
    namespace: (config.namespace != null) ? config.namespace : (env.DEPLOY_NAMESPACE != null) ? env.DEPLOY_NAMESPACE : '',
    serviceName: (config.serviceName != null) ? config.serviceName : (env.ARTEFACT_ID != null) ? env.ARTEFACT_ID : '',
    stage: (config.stage != null) ? config.stage : (env.STAGE != null) ? env.STAGE : 'development',
    dockerImageName: (config.dockerImageName != null) ? config.dockerImageName : (env.DOCKER_IMAGE_NAME != null) ? env.DOCKER_IMAGE_NAME : '',
    dockerRegistry: (config.dockerRegistry != null) ? config.dockerRegistry : (env.DOCKER_REGISTRY != null) ? env.DOCKER_REGISTRY : 'nexus-repo.tntad.fedex.com',
    dockerTag: (config.dockerTag != null) ? config.dockerTag : (env.DOCKER_TAG != null) ? env.DOCKER_TAG : '',
    chart: (config.chart != null) ? config.chart : (env.HELM_CHART != null) ? env.HELM_CHART : 'tnt-apps/apps-generic-chart',
    helmImage: (config.helmImage != null) ? config.helmImage : (env.HELM_IMAGE != null) ? env.HELM_IMAGE : 'nexus-repo.tntad.fedex.com/alpine/helm:3.1.2',
    kubectlImage: (config.kubectlImage != null) ? config.kubectlImage : (env.KUBECTL_IMAGE != null) ? env.KUBECTL_IMAGE : 'nexus-repo.tntad.fedex.com/kubectl:1.16',
  ]

  // If no namespace is specified then use env.APP + deployment.STAGE
  if ( deployment.namespace == "" ) {
    switch(deployment.stage.toLowerCase()) {
      case ['dev', 'development']:
        deployment.namespace = env.APP.replace("_","-") + "-dev"
        break;
      case ['test', 'release']:
        deployment.namespace = env.APP.replace("_","-") + "-test"
        break;
      case ['prod', 'production']:
        deployment.namespace = env.APP.replace("_","-")
        break;
      default:
        println("Unrecongnised stage '" + deployment.stage + "', not sure which namespace to deploy to."); 
        break; 
    }
  }

  deployment.serviceName = deployment.serviceName + "-" + deployment.stage

  switch(deployment.environment) {
    case 'nonprod':
      deploy(env.AKS_NON_PROD_NEUR_CREDS, deployment);
      // deploy(env.AKS_NON_PROD_WEUR_CREDS, deployment); // cannot deploy till verizon routes in place
      break;
    case 'prod':
      sh 'echo deployment to production disabled'
      // deploy(env.AKS_PROD_NEUR_CREDS, deployment);
      // deploy(env.AKS_PROD_WEUR_CREDS, deployment); // cannot deploy till verizon routes in place
      break;
    default:
      println("Cluster not passed, or unknown cluster passed"); 
      break;
  }
}

def deploy(credentials, Map deployment = [:]) {
  withKubeConfig(credentialsId: credentials) {

    // Delpoy app
    docker.image(deployment.helmImage).inside('-v '+WORKSPACE+':/.config -v '+WORKSPACE+':/.cache --entrypoint=') {
      sh " \
      helm repo add tnt-apps https://chart-registry.tnt-digital.io/apps && \
      helm upgrade ${deployment.serviceName} ${deployment.chart} \
        --install --wait --timeout=5m --namespace ${deployment.namespace} \
        -f https://gitlab.tntad.fedex.com/tools/helm/kubernetes-values/-/raw/master/${deployment.environment}-helm.yaml \
        -f helm-release/${deployment.stage}.yaml \
        --set image.repository='${deployment.dockerRegistry}" + "/" + "${deployment.dockerImageName}' \
        --set image.tag=${deployment.dockerTag} \
        --set branch=" + env.BRANCH_NAME.replace("/", "_") + " \
      "
    }

    // Output app URL
    docker.image(deployment.kubectlImage).inside('--entrypoint=') {
      sh  label: 'CLICK HERE FOR APPLICATION URL', script: 'kubectl get ing --namespace ' + deployment.namespace + ' -l "app=' + deployment.serviceName + ',release=' + deployment.serviceName + '" -o jsonpath="https://{.items[0].spec.rules[0].host}"'
    }
  }

}