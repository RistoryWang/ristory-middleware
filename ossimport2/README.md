# ossimport2
### transfer localfile to oss

##### git clone https://github.com/RistoryWang/ossimport2.git
##### cd ossimport2    
##### docker-compose up -d



docker logs -f -t --tail 10000 oss
docker rm -f $(docker ps -a -q -f name=oss)
git clone https://github.com/RistoryWang/ossimport.git
docker-compose up -d


docker exec ossimport2 java -jar /root/ms/bin/ossimport2.jar -c /root/ms/conf/sys.properties stat detail

docker exec -it 1f4baadc95db /bin/bash
docker attach 1f4baadc95db