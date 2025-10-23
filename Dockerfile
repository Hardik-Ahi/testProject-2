# comes with python pre-installed
FROM nginx:1.29.2-alpine
COPY page.html flag.png /usr/share/nginx/html
LABEL name="html page"