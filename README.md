# http to https Reverse Proxy für einen Loxone Miniserver Gen. 1

Die erste Generation des Loxone Miniservers unterstützt kein TLS und folglich keine Anfragen gegen APIs, welche auf https://... hören. Die nachfolgende Apache Reverse Proxy Konfiguration hilft einen Workaround dafür zu implementieren.

Der "HTTP header" des virtuellen Ausgangs muss der wie folgt konfiguriert werden:

```
Accept: application/json 
Content-Type: application/json 
Authorization: Bearer MySecureNukiToken
TargetURL: https://api.nuki.io
```
wobei die Header Variable "TargetURL" den korrekten Zieladresse enthalten muss.

## loxone-proxy.conf

```apache
ProxyRequests Off
ProxyPreserveHost Off

SSLProxyEngine On
SSLProxyVerify none
SSLProxyCheckPeerName Off
SSLProxyCheckPeerExpire Off

RewriteEngine On

# die Header-Variable "TargetURL" wird zunächst überprüft (muss mit https:// beginnen),
# anschließend wird der Wert extrahiert und die neue URL für den Proxy zusammengestellt.
RewriteCond %{HTTP:TargetURL} ^https://([A-Za-z0-9-]+\.)+[A-Za-z]{2,}$ [NC]
RewriteRule ^/(.*)$ %{HTTP:TargetURL}/$1 [P,L,NE]

# bei einer ungültigen Header-Variable wird der HTTP Fehler 400 (Bad Request) zurückgegeben.
RewriteRule ^ - [R=400,L]

RequestHeader unset TargetURL
RequestHeader set X-Forwarded-Proto "http"
RequestHeader set X-Forwarded-Host "%{HTTP_HOST}s"
RequestHeader set X-Forwarded-For "%{REMOTE_ADDR}s"
```
