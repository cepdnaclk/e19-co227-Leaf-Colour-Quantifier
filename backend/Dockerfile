FROM python:3.9

# 
WORKDIR /code

# 
COPY ./requirements.txt /code/requirements.txt

# 
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y

# 
COPY ./rest_api /code/rest_api
COPY ./image_processing /code/image_processing
COPY ./main.py /code

EXPOSE 5000
# 
CMD ["python", "main.py"]