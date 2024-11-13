FROM python:3.9

RUN pip3 install jupyter==1.0.0 wheel setuptools notebook==6.4.11

EXPOSE 8080
WORKDIR /myapp

COPY requirements.txt ./

RUN pip3 install -r requirements.txt

COPY ./ /myapp

# run ember server on container start
ENTRYPOINT ["jupyter"]
CMD ["notebook", "--no-browser", "--ip=0.0.0.0", "--port=8080", "--allow-root"]
