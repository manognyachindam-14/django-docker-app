# Use slim Python base for smaller footprint and security
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN apt-get update \
    && apt-get install -y gcc libpq-dev netcat-openbsd \
    && pip install --upgrade pip \
    && pip install -r requirements.txt \
    && apt-get purge -y --auto-remove gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . .

# Expose app port
EXPOSE 8000

# Start server (to be overridden by Docker Compose)
CMD ["gunicorn", "tutorial.wsgi:application", "--bind", "0.0.0.0:8000"]
