FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    HEADLESS=true \
    BROWSER=Chrome \
    TIMEOUT=15s \
    CHROMEDRIVER_PATH=/usr/bin/chromedriver \
    CHROME_BINARY=/usr/bin/chromium

# Chromium for Selenium (distro-matched chromium-driver, since Selenium
# Manager does not resolve drivers for Chromium) + Node.js for Browser lib
RUN apt-get update && apt-get install -y --no-install-recommends \
        chromium chromium-driver nodejs npm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/tests
COPY requirements.txt ./
RUN pip install --no-cache-dir -U pip && pip install --no-cache-dir -r requirements.txt \
    && (rfbrowser init || python -m Browser.entry init)

COPY . .
RUN mkdir -p Results

CMD ["sh", "-c", "python -m pabot.pabot --processes 2 --pythonpath . --variablefile config/prod.yaml --outputdir Results Tests"]
