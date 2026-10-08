FROM python:3.12-slim

# no .pyc files, unbuffered logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .

# install deps without keeping the download cache, then remove pip/setuptools:
# the running app never needs a package manager, and pip (plus the libraries it
# vendors: urllib3, msgpack, setuptools) was the only fixable CVE source in the image
RUN pip install --no-cache-dir -r requirements.txt \
 && pip uninstall -y pip setuptools wheel \
 && rm -rf /usr/local/lib/python3.12/site-packages/pip* /usr/local/lib/python3.12/site-packages/setuptools*

COPY app ./app

# never run the app as root
RUN useradd --uid 10001 --no-create-home appuser
USER 10001

EXPOSE 5001

CMD ["python", "app/app.py"]
