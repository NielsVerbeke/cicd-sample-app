#!/bin/bash
set -euo pipefail

# Maak de directories aan als ze nog niet bestaan (-p optie)
mkdir -p tempdir
mkdir -p tempdir/templates
mkdir -p tempdir/static

# Kopieer de bestanden naar de juiste directories
cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# Maak een Dockerfile aan met de inhoud hieronder
cat > tempdir/Dockerfile << _EOF_
FROM python
RUN pip install flask
COPY  ./static /home/myapp/static/
COPY  ./templates /home/myapp/templates/
COPY  sample_app.py /home/myapp/
EXPOSE 5050
CMD python /home/myapp/sample_app.py
_EOF_

# Ga naar de tempdir directory en voer de Docker build en run uit
cd tempdir || exit
docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a

