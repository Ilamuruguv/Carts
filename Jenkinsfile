#!/usr/bin/env groovy



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
	echo "IMAGE_NAME : " + IMAGE_NAME
	sh 'echo $USER'
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
		    	//sh 'mvn -DskipTests -Dmaven.test.skip=true   clean compile' 
 
				
				stage 'Package' 
		    	//sh 'mvn -DskipTests -Dmaven.test.skip=true package' 
 
 				//sh 'sudo usermod -a -G docker ec2-user'
				sh 'docker build -t carts .'
				sh 'docker login --username=ilamuruguv --password=manika'
				sh 'docker tag carts ilamuruguv/com.ila.samples:carts28'
 				sh 'docker push ilamuruguv/com.ila.samples:carts28'
 				
 				sh 'export GOOGLE_APPLICATION_CREDENTIALS=/home/ec2-user/myk8sample/'
 				sh 'gcloud auth activate-service-account --key-file=/home/ec2-user/myk8sample/login.json'
				sh 'gcloud container clusters get-credentials cluster-1 --zone us-central1-a --project mykubecluster-175021'
				
				sh 'kubectl create secret docker-registry regsecret --docker-server=https://hub.docker.com/r/ilamuruguv/com.ila.samples/ --docker-username=ilamuruguv --docker-password=manika --docker-email=ilamuruguv@gmail.com'
				sh 'kubectl create -f carts-deploy.yaml'
				sh 'kubectl create -f expose-svc.yaml'
				
	    	
	    	} 
 
	//}
}
}