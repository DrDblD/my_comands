# Первое число - версия ядра, вторая - номер сборки. 
csptestf -enum -info

certmgr -list -store uMy -chain

certmgr -enumstores all_locations

cpconfig -license -view

csptest -tlsc -server localhost -port 8443 -exchange 3 -proto 6 -autocheck -verbose

cpconfig -loglevel ocsp -mask 0xF  && cpconfig -loglevel ocsp_fmt -mask 0x39 && cpconfig -loglevel tsp -mask 0xF && cpconfig -loglevel tsp_fmt -mask 0x39 && cpconfig -loglevel cades -mask 0xF && cpconfig -loglevel cades_fmt -mask 0x39

csptest -absorb -certs

csptest -keyset -enum_cont -fqcn -verifyc

csptest -keycopy -contsrc \\.\HDIMAGE\TestUser23 -contdest \\.\HDIMAGE\TestUser23copy -pindest 123 -silent

java ru.CryptoPro.JCP.tools.Check -all 2>&1 | less

java ru.CryptoPro.JCP.tools.License -serial "serial_number" -combase "company_name_in_base64"

java ru.CryptoPro.JCP.tools.License -serial "serial_number" -company "company_name"

csptestf -passwd -change 14535 -container '\\.\HDIMAGE\equifax_load'

csptest -tlsc -server bki-b2b-test.scoring.ru -port 443 -exchange 3 -proto 6 -autocheck -verbose --cert "C=RU, L=Новосибирск, S=" (хэш серта тоже можно)

csptestf -passwd -check -pininfo -authinfo -container '\\.\HDIMAGE\equifax_load'

# JCP и CSP - две автономные системы независимые друг от друга. Их можно натравить на разные хранилища контейнеров (HDImageStore находящиеся в разных расположениях)
# JCP не требует хранить сертификаты в хранилище CSP, в Java сертификаты Root и CA подключаются через TrustStore. 
# Сертификат клиента желательно всей цепочкой до корневого хранить в контейнере с ключём

# Вот так можно проверить наличие контейнера 

$jdk_path/bin/keytool -list -providername JCP -storetype HDImageStore -keystore NONE -storepass 1 -alias 'equifax'

# Вот так можно посмотреть какие компоненты установлены с JCP

$jdk_path/bin/java ru.CryptoPro.JCP.tools.Check -all
