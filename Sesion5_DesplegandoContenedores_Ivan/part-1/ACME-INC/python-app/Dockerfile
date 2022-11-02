FROM python:3.9.15-alpine

ADD src/ app/
WORKDIR /app

RUN pip install -r requirements.txt


EXPOSE 8080
CMD ["python", "app.py"]
