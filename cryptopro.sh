# Первое число - версия ядра, вторая - номер сборки. 
csptestf -enum -info

certmgr -list -store uMy -chain

certmgr -enumstores all_locations

cpconfig -license -view

csptest -tlsc -server localhost -port 8443 -exchange 3 -proto 6 -autocheck -verbose

cpconfig -loglevel ocsp -mask 0xF  && cpconfig -loglevel ocsp_fmt -mask 0x39 && cpconfig -loglevel tsp -mask 0xF && cpconfig -loglevel tsp_fmt -mask 0x39 && cpconfig -loglevel cades -mask 0xF && cpconfig -loglevel cades_fmt -mask 0x39

csptest -absorb -certs