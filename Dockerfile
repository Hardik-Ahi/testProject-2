# comes with python pre-installed
FROM python:3.11-alpine
WORKDIR /root
COPY app.py .
LABEL name="hello world"
CMD ["python", "app.py"]