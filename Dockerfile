FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    HEADLESS=true \
    BROWSER=Chrome \
    TIMEOUT=15s

# Chromium for Selenium + Node.js for the Browser (Playwright) library
RUN apt-get update && apt-get install -y --no-install-recommends \
        chromium nodejs npm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/tests
COPY requirements.txt ./
RUN pip install --no-cache-dir -U pip && pip install --no-cache-dir -r requirements.txt \
    && (rfbrowser init || python -m Browser.entry init)

COPY . .
RUN mkdir -p Results

CMD ["sh", "-c", "python -m pabot.pabot --processes 2 --outputdir Results Tests"]
