FROM python:3.12 AS main

WORKDIR /app

# Install pandoc and netcat
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    pandoc \
    netcat-openbsd \
    libgl1 \  
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
ENV NLTK_DATA=/app/nltk_data

# Download standard NLTK data, to prevent unstructured from downloading packages at runtime
RUN python -m nltk.downloader --exit-on-error -d /app/nltk_data punkt_tab averaged_perceptron_tagger averaged_perceptron_tagger_eng

# Disable Unstructured analytics
ENV SCARF_NO_ANALYTICS=true

COPY . .

CMD ["python", "main.py"]
