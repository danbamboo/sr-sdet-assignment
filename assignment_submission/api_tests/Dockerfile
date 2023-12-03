FROM python:3.12.0-alpine

WORKDIR /app

#Copy is setp to api_tests since we are building from makefile outside of current directory
COPY api_tests/requirements.txt .   
RUN pip install --no-cache-dir -r requirements.txt

CMD ["sh"]
