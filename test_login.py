import urllib.request
import urllib.parse
from http.cookiejar import CookieJar

cj = CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))

# 1. Try to register a new doctor
register_data = urllib.parse.urlencode({
    'fullName': 'Dr Test',
    'email': 'drtest@test.com',
    'password': 'password123',
    'confirmPassword': 'password123',
    'role': 'Doctor',
    'phone': '123456',
    'specialization': 'General',
    'experience': '5',
    'licenseId': 'LIC123'
}).encode('utf-8')

try:
    print('Registering...')
    req = urllib.request.Request('http://localhost:8080/register', data=register_data)
    res = opener.open(req)
    print('Register response:', res.getcode())
except Exception as e:
    print('Register failed:', e)

# 2. Try to login
login_data = urllib.parse.urlencode({
    'email': 'drtest@test.com',
    'password': 'password123',
    'role': 'Doctor'
}).encode('utf-8')

try:
    print('Logging in...')
    req = urllib.request.Request('http://localhost:8080/login', data=login_data)
    res = opener.open(req)
    print('Login response code:', res.getcode())
    print('Login final URL:', res.geturl())
    html = res.read().decode('utf-8')
    if 'Exception' in html or 'Error' in html or 'Status 500' in html:
        print('Found error in HTML!')
        # print snippet
        idx = html.find('Exception')
        if idx == -1: idx = html.find('Status 500')
        print(html[max(0, idx-200):idx+500])
    else:
        print('Dashboard loaded successfully, HTML length:', len(html))
except urllib.error.HTTPError as e:
    print('Login failed with HTTP error:', e.code)
    print(e.read().decode('utf-8')[:1000])
except Exception as e:
    print('Login failed:', e)
