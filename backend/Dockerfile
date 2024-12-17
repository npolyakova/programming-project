FROM python:3.9

WORKDIR /code/backend

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir --upgrade -r requirements.txt

COPY app /app

RUN pip install "fastapi[standard]"

RUN pip install "PyJwt"

CMD ["fastapi", "run", "/app/main.py", "--port", "8080"]
