echo "It will delete your minikube and create midterm exam, Are you sure?(Y/N)"

read choose

if [ "$choose" = "Y" ]
then

	echo "01. delete minikube and start a new one"
	minikube delete && minikube start --nodes 2 ;

	echo "02. get midterm exam yaml"
	git clone https://github.com/aeifkz/2023_K8s_Security.git
	cp 2023_K8s_Security/*.yaml .


	echo "03. create with yaml"
	for i in 0 1 2 3 4 5 
	do
		echo "kubectl create -f quiz-$i.yaml"
		kubectl create -f quiz-$i.yaml ;
	done

	echo "04. waiting for building midterm exam"
	for i in 0 1 2 3 4 5
        do
		kubectl -n quiz-$i wait pods quiz-$i --for=condition=ready --timeout=600s
        done

	echo "05. create flag file"
	worker0_flag=`echo ZmxhZ3tUaGUtRmFtaWxpYXItb2YtWmVyb30K  | base64 -d`
	worker1_flag=`echo ZmxhZ3tPbmUtUHVuY2gtTWFufQo= | base64 -d`
	worker2_flag=`echo ZmxhZ3tHZXRCYWNrZXJzfQo=  | base64 -d`
	worker3_flag=`echo ZmxhZ3tNYXJjaC1jb21lcy1pbi1saWtlLWEtbGlvbn0K | base64 -d`
	worker4_flag=`echo ZmxhZ3tZb3VyLUxpZS1pbi1BcHJpbH0K  | base64 -d`
	master_flag=`echo ZmxhZ3tZb3VfQXJlX01hc3Rlcl9vZl9LOHN9Cg== | base64 -d`
	vm_flag=`echo ZmxhZ3tEb19Ob3RfVG91Y2hfTXlfVk19Cg== | base64 -d`

	echo $worker0_flag > worker0_flag
	echo $worker1_flag > worker1_flag
	echo $worker2_flag > worker2_flag
	echo $worker3_flag > worker3_flag
	echo $worker4_flag > worker4_flag
	echo $master_flag > master_flag
	echo $vm_flag > vm_flag


	echo "06. assign flag file"	
	master_node=`kubectl get nodes  | grep    control-plane | awk {'print $1'}`
	worker_node=`kubectl get nodes  | grep -v control-plane | grep -v NAME | awk {'print $1'}`

	for i in 0 1 2 3 4
	do
		echo "docker cp worker${i}_flag $worker_node:/"
		docker cp worker${i}_flag $worker_node:/
	done

	echo "docker cp master_flag $master_node:/"
	docker cp master_flag $master_node:/
	cp vm_flag /tmp

	#clean work dir
	for i in 0 1 2 3 4
        do
                rm worker${i}_flag
        done

	rm master_flag 
	rm vm_flag

	echo "07. kill all kubectl port-forward process"
	kill -9 `ps aux | grep port-forward | grep -v grep | awk '{printf $2 " " }'`

	echo "Build complete!!! Enjoy your midterm exam!!!"

	echo "08. use following command to enable connect to midterm exam"
	echo "kubectl port-forward svc/service-quiz0 -n quiz-0 30389:8080 --address='0.0.0.0'"
	echo "kubectl port-forward svc/service-quiz1 -n quiz-1 30390:8081 --address='0.0.0.0'"
	echo "kubectl port-forward svc/service-quiz2 -n quiz-2 30391:8082 --address='0.0.0.0'"
	echo "kubectl port-forward svc/service-quiz3 -n quiz-3 30392:8083 --address='0.0.0.0'"
	echo "kubectl port-forward svc/service-quiz4 -n quiz-4 30393:8084 --address='0.0.0.0'"
	echo "kubectl port-forward svc/service-quiz5 -n quiz-5 30394:8085 --address='0.0.0.0'"

else
	echo "See You Next Time"
fi
