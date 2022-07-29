
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
configMapGenerator:
- name: %MICROSERVICE%-meta-info
  options:
    disableNameSuffixHash: true
  envs:
  - deploy.properties
