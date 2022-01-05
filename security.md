# Time Manager

- are they injectable (XSS, Script, HTML, . . . )?
  cf. Nikto
- are they vulnerable to sql injections, nosql?
- are there accessible configuration files?
  Routes are protected
- are password hashes difficult to break?
  We use bcrypt elixir.
  https://github.com/riverrun/bcrypt_elixir
- are routes accessible by unauthorized users?
  Routes are protected.
- are endpoints accessible by unauthorized users?
- is it possible to fill the database and cause a denial of service when rendering the page?
  No.
- are JWT tokens http-only? If not, how to recover these tokens?
- are the passwords sent in clear? If so how do you recover them?
- is the application available only in https? if not, how could a malicious user intercept a client’s requests
  to your server? ?

## Nikto

- Nikto v2.1.6

---

- Target IP: 10.15.191.84
- Target Hostname: 10.15.191.84
- Target Port: 8080
- Start Time: 2021-11-10 11:19:20 (GMT1)

---

- Server: No banner retrieved
- Retrieved x-powered-by header: Express
- The anti-clickjacking X-Frame-Options header is not present.
- The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type.
- No CGI Directories found (use '-C all' to force check all possible dirs)
- Allowed HTTP Methods: GET, HEAD
- Server banner changed from '' to 'Cowboy'
- 8127 requests: 0 error(s) and 5 item(s) reported on remote host
- End Time: 2021-11-10 11:19:32 (GMT1) (12 seconds)
