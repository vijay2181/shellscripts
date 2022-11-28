#generating server,client trustore and keystore
CERTS_PATH="/certs"
PASS="password"
CA_CERT="/certs/ca.crt"
CA_KEY="/certs/ca.key"

elements="kafka1.vijay4devops.co","client"

IFS=',' read -r -a array <<< "$elements"
for i in "$${array[@]}"
do
        if [[ ! -f $CERTS_PATH/$i.keystore.jks ]] && [[ ! -f $CERTS_PATH/$i.truststore.jks ]];then
        printf "Creating cert and keystore for $KAFKA..."
        # Create keystores
        keytool -genkey -noprompt \
                             -alias $i \
                             -dname "CN=$i, OU=Devops, O=Vijay Pvt Ltd, L=Hyderabad, C=IN" \
                             -keystore $CERTS_PATH/$i.keystore.jks \
                             -keyalg RSA \
                             -storepass $PASS \
                             -keypass $PASS  >/dev/null 2>&1

        # Create CSR, sign the key and import back into keystore
        keytool -keystore $CERTS_PATH/$i.keystore.jks -alias $i -certreq -file /tmp/$i.csr -storepass $PASS -keypass $PASS >/dev/null 2>&1

        openssl x509 -req -CA $CA_CERT -CAkey $CA_KEY -in /tmp/$i.csr -out /tmp/$i-ca-signed.crt -days 1825 -CAcreateserial -passin pass:$PASS  >/dev/null 2>&1

        keytool -keystore $CERTS_PATH/$i.keystore.jks -alias CARoot -import -noprompt -file $CA_CERT -storepass $PASS -keypass $PASS >/dev/null 2>&1

        keytool -keystore $CERTS_PATH/$i.keystore.jks -alias $i -import -file /tmp/$i-ca-signed.crt -storepass $PASS -keypass $PASS >/dev/null 2>&1

        # Create truststore and import the CA cert.
        keytool -keystore $CERTS_PATH/$i.truststore.jks -alias CARoot -import -noprompt -file $CA_CERT -storepass $PASS -keypass $PASS >/dev/null 2>&1
    echo " OK!"
       else
           printf "Keystore: $i.keystore.jks and truststore: $i.truststore.jks already exist..skip creating it.."
           echo " OK!"
    fi
done
