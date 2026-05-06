import urllib.request
import urllib.parse
from http.cookiejar import CookieJar

cj = CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))

login_data = urllib.parse.urlencode({
    'email': 'doctor@gmail.com',
    'password': '1234',
    'role': 'Doctor'
}).encode('utf-8')

try:
    print('Logging in...')
    req = urllib.request.Request('http://localhost:8080/login', data=login_data)
    res = opener.open(req)
    print('Login success')
except Exception as e:
    print('Login failed:', e)

# Test endpoints
endpoints = [
    '/doctor/appointments',
    '/doctor/patients',
    '/doctor/emr',
    '/doctor/prescriptions',
    '/doctor/lab-requests',
    '/doctor/lab-reports',
    '/doctor/availability',
    '/doctor/profile'
]

for ep in endpoints:
    try:
        res = opener.open('http://localhost:8080' + ep)
        print(ep, '-> 200 OK')
    except urllib.error.HTTPError as e:
        print(ep, '-> Error', e.code)
        html = e.read().decode('utf-8')
        if 'Exception' in html:
            start = html.find('Exception')
            print('EXCEPTION TRACE:', html[start:start+300])
        elif 'Message' in html:
            start = html.find('Message')
            print('ERROR MESSAGE:', html[start:start+300])
        else:
            print('ERROR HTML START:', html[:300])
