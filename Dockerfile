FROM public.ecr.aws/lambda/python:3.8

COPY ./app ./app

RUN pip install -r ./app/requirements.txt

CMD [ "app.main.handler" ]
