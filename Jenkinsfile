#!/usr/bin/env groovy


properties([[$class: 'ParametersDefinitionProperty', parameterDefinitions: [ 
[$class: 'hudson.model.StringParameterDefinition', name: 'PHASE', defaultValue: "BUILD"],
[$class: 'hudson.model.StringParameterDefinition', name: 'TARGET_ENV', defaultValue: "DEV"],
[$class: 'hudson.model.StringParameterDefinition', name: 'K8S_CLUSTER_URL',defaultValue: " https://192.168.99.100:8443"],
[$class: 'hudson.model.StringParameterDefinition', name: 'K8S_CONTEXT',defaultValue: "default"],
[$class: 'hudson.model.StringParameterDefinition', name: 'K8S_USERNAME',defaultValue: "root"],
[$class: 'hudson.model.PasswordParameterDefinition', name: 'K8S_PASSWORD',defaultValue: ""],
[$class: 'hudson.model.StringParameterDefinition', name: 'K8S_NAME',defaultValue: "ila"],
[$class: 'hudson.model.StringParameterDefinition', name: 'K8S_PODS_REPLICAS',defaultValue: "1"],
[$class: 'hudson.model.StringParameterDefinition', name: 'K8S_SERVICE_ACCOUNT',defaultValue: "default"],
[$class: 'hudson.model.BooleanParameterDefinition', name: 'USE_ROOT_NS',defaultValue: false]
]]])

/**
    jdk1.8 = fixed name for java
    M3 = fixed name for maven
    general_maven_settings = fixed name for maven settings Jenkins managed file
*/

echo "Build branch: ${env.BRANCH_NAME}"

node("docker") {
	stage 'Checkout'
	checkout scm
	
	pom = readMavenPom file: 'pom.xml'
	PROJECT_NAME = pom.groupId ?: pom.parent.groupId + ":" + pom.artifactId;
	SERVICE_NAME=pom.artifactId;
	NAMESPACE=pom.groupId ?: pom.parent.groupId;
	
	TARGET_ENV=TARGET_ENV.toLowerCase()
	if(params.USE_ROOT_NS)
	{
		KUBE_NAMESPACE=pom.properties['kube.namespace']
	}else{
		KUBE_NAMESPACE=pom.properties['kube.namespace']+"-"+TARGET_ENV
	}
	
	REPLICA_COUNT="${params.K8S_PODS_REPLICAS}"
	IMAGE_NAME=pom.properties['docker.registry']+"/"+NAMESPACE+"/"+pom.artifactId+":latest"
	echo "Artifact: " + PROJECT_NAME
	//env.DOCKER_HOST="tcp://localhost:4243"
	//env.DOCKER_CONFIG="${WORKSPACE}/.docker" 
	def branchName
	
	// Create kubectl.conf  file here from Pipeline properties provided.
	
	withEnv(["PATH=${env.PATH}:${tool 'M3'}/bin:${tool 'jdk1.8'}/bin", "JAVA_HOME=${tool 'jdk1.8'}", "MAVEN_HOME=${tool 'M3'}"]) { 
			
		echo "JAVA_HOME=${env.JAVA_HOME}"
		echo "MAVEN_HOME=${env.MAVEN_HOME}"
		echo "PATH=${env.PATH}"

		/** wrap([$class: 'ConfigFileBuildWrapper', managedFiles: [
			[fileId: 'maven-settings.xml', variable: 'MAVEN_SETTINGS'],
			]]) {
			
			*/
			 branchName = (env.BRANCH_NAME ?: "master").replaceAll(/[^0-9a-zA-Z_]/, "-")
			 
			
			if ("${PHASE}" == "BUILD" || "${PHASE}" == "BUILD_DEPLOY" ) { 
				stage 'Compile' 
		    	sh 'mvn -DskipTests -Dmaven.test.skip=true   clean compile' 
 
				
				stage 'Package' 
		    	sh 'mvn -DskipTests -Dmaven.test.skip=true package' 
 
				sh 'docker build -t carts .'
				//sh 'docker login --username=ilamuruguv --password=manika'
				//sh 'docker tag carts ilamuruguv/com.ila.samples:cats11'
 				//sh 'docker push ilamuruguv/com.ila.samples:carts'
 				
				
				
	    	
	    	} 
 
		/**	if ("${PHASE}" == "BUILD_DEPLOY" || "${PHASE}" == "DEPLOY" ) { 
				 // deploy to k8s
				if (branchName == 'master') {
					stage ('Deploy to Staging') {
						withEnv([
                        "APP_NAME=${SERVICE_NAME}",
                        "K8S_CTX=${K8S_CONTEXT}",
                        "APP_NS=${KUBE_NAMESPACE}",
                        "TARGET_ENV=TEST",
                        "IMAGE_NAME=${IMAGE_NAME}",
                        "SERVICE_ACCOUNT=${K8S_SERVICE_ACCOUNT}",
                        "KUBECTL=/opt/app/kubernetes/v1.3.4/bin/kubectl",
                        "KUBECTL_OPTS=--server=${K8S_CLUSTER_URL} --insecure-skip-tls-verify=true  --password=${K8S_PASSWORD}  --username=${K8S_USERNAME}"
						]) {
						sh "./k8s/deploy.sh"
					}
				}

			} else if (branchName=="develop") {
					stage ('Deploy to Development') {
						withEnv([
                        "APP_NAME=${SERVICE_NAME}",
                        "K8S_CTX=${K8S_CONTEXT}",
                        "APP_NS=${KUBE_NAMESPACE}",
                        "TARGET_ENV=dev",
                        "IMAGE_NAME=${IMAGE_NAME}",
                        "SERVICE_ACCOUNT=${K8S_SERVICE_ACCOUNT}",
                        "KUBECTL=/opt/app/kubernetes/v1.3.4/bin/kubectl",
                        "KUBECTL_OPTS=--server=${K8S_CLUSTER_URL} --insecure-skip-tls-verify=true --password=${K8S_PASSWORD}  --username=${K8S_USERNAME}"
						]) {
						sh "./k8s/deploy.sh"
					}
				}
			}
	    	} 
 
	}*/
}
}